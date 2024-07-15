#!/usr/bin/env bash

cat <<-'EOF'
# domains

Get list of domains:  
[/api/catalog/v1/domains][1]

Get datasets for finances.worldbank.org and data.cdc.gov:  
[/api/catalog/v1?only=dataset&domains=finances.worldbank.org,data.cdc.gov][2]

EOF

curl -s 'https://api.us.socrata.com/api/catalog/v1/domains' |
  jq -r '"root,count,domain" as $header
    | .results
    | map(select((.count > 1) and (.domain|test("demo")|not)) |
      . +{root: (.domain|split(".")[1:]|join("."))})
    | sort_by(.root,.domain)
    | map([.root,.count,.domain]|join(","))
    | join("\n")
    | [$header,($header|gsub("[a-z]";"=")),.]|join("\n")' domains.json |
  column -s, -t |
  sed 's,^,    ,g'

cat <<-'EOF'

<!-- Resources -->

[1]: https://api.us.socrata.com/api/catalog/v1/domains
[2]: https://api.us.socrata.com/api/catalog/v1?only=dataset&domains=finances.worldbank.org,data.cdc.gov

EOF
