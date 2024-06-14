# open data

* Austin: https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov
* Texas.gov: https://api.us.socrata.com/api/catalog/v1?domains=data.texas.gov
* Texas: https://data.texas.gov/api/catalog/v1?only=dataset&limit=2000&q=texas
* Crime: https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=2000&q=crime
* Datasets: https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=2000&q=datasets


```sh
./scripts/update.sh
```

```sh
curl -o data/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov"
./scripts/markdown.sh data/austin.json -Y >austin.md
```


```sh
CATALOG_URL='https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=5000'

curl -o data/texas-gov.json "${CATALOG_URL}&domains=data.texas.gov"
curl -o data/texas.json "${CATALOG_URL}&q=texas"
curl -o data/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov"
curl -o data/crime.json "${CATALOG_URL}&q=crime"

./scripts/markdown.sh data/texas-gov.json -Y >texas-gov.md
./scripts/markdown.sh data/texas.json -Y >texas.md
./scripts/markdown.sh data/austin.json -Y >austin.md
./scripts/markdown.sh data/crime.json -Y >crime.md

./scripts/build-catalog.sh -Y -t dataset -q 'q=dataset' -g domain >dataset.md
./scripts/build-catalog.sh -Y -t police -q 'q=police' -g domain >police.md

./scripts/create.sh data/austin.json
```