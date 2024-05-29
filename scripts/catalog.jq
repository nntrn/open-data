# cat data/texas.json | jq -L scripts 'include "catalog"; fmt_results'

def capitalize: 
  gsub("((?<c>[a-zA-Z])(?<a>[\\w\\d\\s]+))"; (.c|ascii_upcase) + .a;"x");

def slugify($text):
  $text
  | tostring
  | gsub("\\.";"")
  | gsub("[^a-zA-Z0-9]{1,2}";"-")
  | ascii_downcase;

def uncase($str): 
  $str | gsub("(?<a>[a-z])(?<b>[A-Z])";.a + " " + .b)|gsub("_";" ");

def column_map($i):
  { key: .columns_field_name[$i],
    value: ([
      "[\(.columns_datatype[$i])]",
      (.columns_description[$i]? // uncase(.columns_name[$i]))
    ]|join(" "))
  };

def column_map_table: {
    name: .columns_name,
    field: .columns_field_name, 
    datatype: .columns_datatype,
    description: .columns_description
  } as $r 
  | [range(0;($r.name|length))]
  | map([$r.field[.],($r.datatype[.]|ascii_downcase),$r.description[.]]|join("\t"));

def get_domain_tags:
  map(.classification.domain_tags)
  |flatten
  |sort
  |group_by(.)
  |map({key: .[0],value: length}|select(.value > 1))
  |from_entries;

def get_classification: 
  .classification | 
  if (.domain_category == "See Category Tile") 
  then (.domain_metadata|from_entries)["Dataset-Category_Category-Tile"] 
  else 
    .domain_category? // 
    (.domain_metadata|from_entries)["Dataset-Category_Category-Tile"]? // 
    (.domain_metadata|from_entries)["Ownership_Department-name"]? //
    (.categories|first|capitalize)? // 
    "Other"
  end;

def get_columns: 
  .resource as $r 
  | [range(0;($r.columns_name|length))]
  | map(. as $i |$r|column_map($i));

def deep_flat_object:
  [ paths(scalars) as $path | {
      "key": ($path|join("_")|gsub("_[0-9]+";"")),
      "value": (if ($path|last|type) == "number" then getpath($path[0:-1]) else getpath($path) end)
    }
  ] | unique | from_entries;

def split_sentences:
  gsub("(?<end>[a-z]{3}[\\.\\?])\\s(?<start>[A-Z])"; .end + "~~split~~" + .start; "x")
  | gsub("[-\\s_]{5,}";"~~split~~")
  | split("~~split~~");

def get_excerpt:
  "\(.)\n" 
  | split("[\\n\\r]+";"x")[0]
  | (gsub("\\.\\s(?<s>[A-Z])"; ".~~"+ .s)|split("~~")|first);

def get_excerpt($str): $str | get_excerpt;

# removes html
def clean_text:
  gsub("&lt;";"<")
  | gsub("&gt;";">")
  | gsub("<[^>]*>";"")
  | gsub("\\*";"")
  | gsub("[[:^ascii:]]";"";"x")
  | gsub("[\\s]{2,}";" ");

def format_description:
  tostring
  | clean_text
  | split("\n")
  | map(gsub("[\\t\\r]";"")| gsub("(?<a>[^\\n]{72,90}\\. )"; .a + "\n"; "m")|select(length>0))
  | map(split_sentences)
  | map(select(length > 0))
  | flatten
  | map(select(test("^[A-Z\\s\\d:]+$";"x")|not)|gsub("^[\\s]+|[\\s]$";""))
  | join("\n")
  | split("[\\n]+";"x")
  ;


def result_item:
  (.resource | {name,id,description,updatedAt}) + {
    description:(.resource.description| format_description),
    link,
    url: "https://\(.metadata.domain)/resource/\(.resource.id).json",
    classification: (get_classification),
    columns: (.resource | column_map_table)
  };

def get_simple_item: {
  description:(.resource.description| format_description),
  link,
  domain: .metadata.domain,
  url: "https://\(.metadata.domain)/resource/\(.resource.id).json",
  info: "https://\(.metadata.domain)/api/views/\(.resource.id)",
  department: (.classification.domain_metadata|from_entries)["Ownership_Department-name"],
  update_frequency: (.classification.domain_metadata|from_entries)[ "Publishing-Information_Update-Frequency"],
  classification: (get_classification)
  };

def get_simple:  map((.resource | {name,id,data_updated_at}) + get_simple_item) ;

def get_verbose: map(result_item);

def simple_group_by: 
  get_simple
  | map(select(.name| test("(BOUNDARIES|Strategic Measure|TRANSPORTATION|deprecated)")|not))
  | group_by(.classification)
  | map({
      key: .[0].classification, 
      value: map(del(.classification))
    });

def group_by_class($class): 
  (.results? // .)| group_by($class)
  | map({
      key: .[0][$class], 
      value: map(del(.[$class]))
    });

def group_by_count(f): group_by(f)
  |map({
    key: (.[0]|f),
    value: map(del(f))
  });


def format_title($str):
  $str
  |gsub("[^a-zA-Z0-9\\s\\.,']";" ")
  |gsub("Strategic Measure[s ]+";"(%)")
  |gsub("Strategic Direction ";"($)")
  |gsub("Strategic ";"")
  |gsub("[\\s]+";" ")
  |gsub(" e.g..*";"")
  |ltrimstr(" ")
  |rtrimstr(" ");

def markdown_catalog(s):
  map( if (env.MARKDOWN_EXCLUDE|length)>0 then select(.name|test(env.MARKDOWN_EXCLUDE;"i")|not) else . end )
  | group_by_count(s) as $gbc
  | $gbc
  | map([
      "## \(.key)",
      "",
      ( .value 
        | sort_by(.name) 
        | map(
          select(.description[0] != .name)
          | [
            "- **\(format_title(.name))**  ",
            "  [Data](\(.url)) | [Meta](\(.info))  ",
            ( if (.description[0]|length) > 0 then "  \( .description[0])" else null end),
            # (if (.description[0]|length)>8 then "  \(.description[0])" else "" end),
            # (.description|join("\n")|split("\n")|map(select(test("^[A-Z\\s]{0,10}$")|not))|.[0]|map("  \(.)")|join("\n")),
            ""
          ]|map(select(type != null)) | join("\n")
        )
        | join("\n")
      ),
      (if (.value|length) > 15 then  "\n[[TOP]](#table-of-contents)\n" else "" end)
    ] 
    | join("\n")
  ) | join("\n") as $content
  | [
    "# \(env.MARKDOWN_TITLE)",
    "",
    "<details id=\"table-of-contents\"><summary><strong>Table of Contents</strong></summary>",
    "",
    ($gbc|map("- [\(.key)](#\(slugify(.key)))")|join("\n")),
    "",
    "</details><br>",
    "",
    "> **NOTE**  ",
    "> (%) denotes strategic dataset",
    "",
    "",
    $content,
    ""
  ]
  | join("\n");


def markdown_list(md): map(md)|join("\n");
