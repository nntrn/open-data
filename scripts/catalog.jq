# cat data/texas.json | jq -L scripts 'include "catalog"; fmt_results'

def capitalize: 
  gsub("((?<c>[a-zA-Z])(?<a>[\\w\\d\\s]+))"; (.c|ascii_upcase) + .a;"x");

def slugify($text):
$text|tostring|gsub("[^a-zA-Z0-9]{1,2}";"-")|ascii_downcase;

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

def clean_description:
  gsub("&lt;";"<")|gsub("&gt;";">")
  | gsub("<[^>]*>[\\s]?";"")
  | split("[\\n]+")
  | map(gsub("[\\t\\r]";"")| gsub("(?<a>[^\\n]{72,90}) "; .a + "\n"; "m")|select(length>0))
  | flatten(2)
  | join("\n")
  | gsub("[\\n]{2,}";"\n\n")
  | split("\n");

def result_item:
  (.resource | {name,id,description,updatedAt}) + {
    description:(.resource.description| clean_description),
    link,
    url: "https://\(.metadata.domain)/resource/\(.resource.id).json",
    classification: (get_classification),
    columns: (.resource | column_map_table)
  };

def get_simple_item: {
  description:(.resource.description| clean_description),
  link,
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

def group_by_count(f;select): group_by(f)
  |map({
    key: (.[0]|f),
    value: map(select)
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
          (.description|join(" ")|split(". ")[0]? // "") as $desc
          | select(.description[0] != .name)
          | [
            "- **\(format_title(.name))**  ",
            "  [Data](\(.url)) | [Meta](\(.info))  ",
            (if ($desc|length)>0 then "  \($desc)  \n" else "" end)
            # ""
          ] | join("\n")
        )
        | join("\n")
      ),
      (if (.value|length) > 15 then  "\n[[TOP]](#table-of-contents)\n\n" else "" end)
    ] | join("\n")
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
