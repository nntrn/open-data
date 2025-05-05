#!/usr/bin/env bash

#   EXAMPLE USAGE:
#   ---------------------------------------------------
#     $ datajson=($(ls -1 data/*.json))
#     $ for i in ${datajson[@]}; do echo $i; ./scripts/write-jekyll-data.sh $i >_${i}; done
#
#     $ for i in $(ls -1 data/*.json); do ./scripts/write-jekyll-data.sh $i > ${i//data\//_data/open/} ;  done

write_jekyll_data() {
  cat $1 | jq '.results
  | map(
    (.resource|{id,name,description,attribution,updatedAt,createdAt,columns:.columns_field_name}) +
    { 
      permalink,
      domain: .metadata.domain,
      tags: .classification.domain_tags,
      category: .classification.domain_category,
      url: "https://\(.metadata.domain)/id/\(.resource.id).json",
      meta_url: "https://\(.metadata.domain)/api/views/\(.resource.id)",
      foundry_url: "https://dev.socrata.com/foundry/\(.metadata.domain)/\(.resource.id)"
    } +
    {columns: (
      .resource 
        | {columns_field_name,columns_datatype,columns_name} as $dat
        | [range(0;$dat.columns_field_name|length)]
        | map([ 
            (($dat.columns_datatype[.]|ascii_downcase | split(" ") | last) as $l | $l + (" " * (15-($l|length)))),
            $dat.columns_field_name[.]
        ]|join(""))
        | map(select(.|test(":@computed_region")|not))
    )|sort}
  )
  | tojson|gsub("[\u00A0\u0008\t\r]+";" ";"x")|fromjson'
}

if [[ -d $1 ]]; then
  datajson=($(ls -1 $1/*.json))
  datadir=${1//\//}
  for i in $(ls -1 $datadir/*.json); do
    newpath="_data/open/$(basename $i)"
    echo "Writing $newpath"
    write_jekyll_data $i >$newpath
  done
elif [[ -f $1 ]]; then
  newpath=_data/open/${1##*/}
  echo "Writing $newpath"
  write_jekyll_data $1 >$newpath
else
  cat $1 | write_jekyll_data

fi
