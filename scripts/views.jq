

def clean_html:
  gsub("&lt;";"<")
  | gsub("&gt;";">")
  | gsub("<[^>]*>";"")
  | gsub("\\*";"")
  | gsub("[[:^ascii:]]";"";"x")
  | gsub("\n[\\t]";"\n  - ")
  | gsub("\\.[\\s]{2,}";".\n")
  | gsub("[\\t]+";"  ")
;

def clean_view: select(.assetType == "dataset") | del(.tableAuthor,.approvals,.grants,.owner);

def deep_flatten:
  [ paths(scalars) as $path | {
      "key": ($path|join("_")|gsub("_[0-9]+";"")|gsub(" ";"_")|ascii_downcase),
      "value": (if ($path|last|type) == "number" then getpath($path[0:-1]) else getpath($path) end)
    }
  ] | unique | from_entries;

def extract_desc:tostring|clean_html|split("\n")|map(select(test("[A-Z][a-z]")));

def neat_view:
  (.description|extract_desc) as $desc
  | {
    name,
    url: "https://\(.domaincname)/resource/\(.id).json",
    meta_url: "https://\(.domaincname)/api/views/\(.id)",
    category: (
      .metadata_custom_fields_dataset_category_category_tile // 
      .category // 
      .metadata_custom_fields_ownership_department_name // 
      .metadata_custom_fields_microsite_tags 
    ),
    domain: .domaincname,
    description: $desc,
    summary:($desc|map(select(length < 400 and test("^[A-Z][a-z]")))|max_by(length)),
    last_update: (.rowsupdatedat|strflocaltime("%b %Y")?)
  };

def slugify($text):
  $text
  | tostring
  | gsub("\\.";"")
  | gsub("[^a-zA-Z0-9]{1,2}";"-")
  | ascii_downcase;

def simple_clean_text:
  gsub("(?<b>[\"\\(\\/]) ";.b)
  |gsub("(?<a>[a-z])\"(?<b>[a-zA-Z])"; .a + "\" " + .b)
  | gsub("(?<a>[a-z])\\.(?<b>[A-Z])"; .a + ". " + .b;"x")
  | gsub("[\\s_]+";" ")
  | gsub("^[\\s]+|[\\s]+$";"")
  | gsub("\\[[^\\]]+";"")
  ;

def capitalize: 
  gsub("((?<c>[a-zA-Z])(?<a>[\\w\\d\\s]+))"; (.c|ascii_upcase) + .a;"x");

def title_from_filename:split("/")|last|split(".")|first|capitalize;

def format_title:
  gsub("^[^a-zA-Z0-9]";"")
  | gsub("^Strategic[_\\s]Measure[s\\s_-]+";"(%)";"x")
  | gsub("^Strategic Direction";"($)")
  | gsub("\\([^\\)]{30,}\\)|[\\[\\]]";"")
  | simple_clean_text
  ;

def format_title($str): $str | format_title;

def write_markdown($groupby):
  (input_filename|title_from_filename) as $filename
  | map(select((.category|length)>0))
  | map(select(.name|(test("[A-Z][a-z]";"x") and (test("DEMO|[Dd]emo|TEST|[Tt]est|ARCHIVE|[Aa]rchive|UTILITIES")|not) ) ))
  | group_by(.["\($groupby)"])
  | ([
      "<details id=\"table-of-contents\"><summary><strong>Table of Contents</strong></summary>",
      "",
      map("- [\(.[0][$groupby])](#\(slugify(.[0][$groupby])))"),
      "",
      "</details></br>",
      "",
      "> **NOTE**  ",
      "> (%) denotes strategic dataset",
      ""
     ]|flatten|join("\n")) as $toc
  | map(
      "\n## \(.[0][$groupby])\n\n" + (
        sort_by(.name)
        | map(["- **\(.name)**","[Data](\(.url)) | [Meta](\(.meta_url)) | Last update: \(.last_update)",.summary]
        | map(select(length > 0))|join("  \n  "))|join("\n\n")
      )
    )
  | flatten
  | join("\n\n")| "# \($filename)\n\n\($toc)\n\n\(.)";

def write_markdown: write_markdown(.category);

def view:
  map(clean_view)
  | map(deep_flatten)
  | map(neat_view);

def results:
  .results
  | map(
    (.resource|del(.page_views,.columns_format,.columns_description,.columns_datatype,.columns_field_name,.columns_name)) +
    (.classification.domain_metadata|from_entries|with_entries(.key|=(ascii_downcase|gsub("-";"_"))  )) +
    ({
      name: format_title(.resource.name),
      domain_category: .classification.domain_category,
      category: (.classification.domain_category// .strategic_area_strategic_direction_outcome //.ownership_department_name ), 
      domaincname: .metadata.domain,
      rowsupdatedat: (.resource.updatedAt|gsub("\\..*";"")|strptime("%Y-%m-%dT%H:%M:%S")|mktime )
    })
  ) 
  |map(neat_view) 
;
