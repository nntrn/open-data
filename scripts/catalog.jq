# cat data/texas.json | jq -L scripts 'include "catalog"; fmt_results'

def capitalize: 
  gsub("((?<c>[a-zA-Z])(?<a>[\\w\\d\\s]+))"; (.c|ascii_upcase) + .a;"x");

def slugify($text):
  $text
  | tostring
  | gsub("\\.";"")
  | gsub("[^a-zA-Z0-9]{1,2}";"-")
  | ascii_downcase;

def simple_clean_text:
  gsub("(?<b>[\"\\(\\/]) ";.b)
  |gsub("(?<a>[a-z])\"(?<b>[a-zA-Z])"; .a + "\" " + .b)
  # | gsub(" (?<b>[\\.\\:])";.b)
  | gsub("(?<a>[a-z])\\.(?<b>[A-Z])"; .a + ". " + .b;"x")
  | gsub("[\\s_]+";" ")
  | gsub("^[\\s]+|[\\s]+$";"")
  | gsub("\\[[^\\]]+";"")
  ;

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

# removes html
def strip_html:
  gsub("&lt;";"<")
  | gsub("&gt;";">")
  | gsub("<[^>]*>";"")
  | gsub("\\*";"")
  | gsub("[[:^ascii:]]";"";"x")
  | gsub("[\\s]{2,}";" ");

def format_description:
  tostring
  | strip_html
  | gsub(":[\\n][\\n\\s]+?";": ")
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

def format_title:
  gsub("^[^a-zA-Z0-9]";"")
  | gsub("^Strategic[_\\s]Measure[s\\s_-]+";"(%)";"x")
  | gsub("^Strategic Direction";"($)")
  | gsub("\\([^\\)]{30,}\\)|[\\[\\]]";"")
  | simple_clean_text
  ;

def format_title($str): $str | format_title;

def build_markdown:
  map(if (env.MARKDOWN_EXCLUDE|length)>0 then select(.name|test(env.MARKDOWN_EXCLUDE;"x")|not) else . end )
  | map(select(.name|(test("[A-Z][a-z]";"x") and (test("DEMO|[Dd]emo|TEST|[Tt]est|ARCHIVE|[Aa]rchive")|not) ) ))
;

def catalog_list:
  map( if (env.MARKDOWN_EXCLUDE|length)>0 then select(.name|test(env.MARKDOWN_EXCLUDE;"x")|not) else . end )
  | map(select(.name|(test("[A-Z][a-z]";"x") and (test("DEMO|[Dd]emo|TEST|[Tt]est|ARCHIVE|[Aa]rchive")|not) ) ))
  ;

def markdown_catalog(s):
  map(
    select(.domain|test(".co$")|not) |
    (if (env.MARKDOWN_EXCLUDE|length)>0 then select(.name|test(env.MARKDOWN_EXCLUDE;"x")|not) else . end) |
    select(.name|(test("[A-Z][a-z]";"x") and (test("DEMO|[Dd]emo|TEST|[Tt]est|ARCHIVE|[Aa]rchive")|not)))
  )
  | group_by_count(s) as $gbc | $gbc
  | map(
      [
        "## \(.key)",
        "",
        ( .value 
          | sort_by(.name,.id) 
          | map(
            select(.description[0] != .name) 
            | 
            [
              "- **\(format_title(.name))**",
              "[Data](\(.url)) | [Meta](\(.info)) | Last updated in \(.data_updated_at|tostring|gsub("-.*";""))",
              if (.description[0]|length) > 40 then .description[0] else null end,
              if (.description[1]|length) > 40 and (.description[1]|length) < 100  and (.description[1]|test("^[A-Z]")) then .description[1] else null end
            ]
            | flatten
            | map(select(length > 0))
            | join("  \n  ")
          )
          | join("\n\n")
        ),
        (if (.value|length) > 15 then "\n[[TOP]](#table-of-contents)\n" else "" end)
      ] 
      | join("\n") 
    ) 
  | join("\n") as $content
  | 
  [
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
