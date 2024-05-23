# atx

* Austin: https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov
* Texas.gov: https://api.us.socrata.com/api/catalog/v1?domains=data.texas.gov
* Texas: https://data.texas.gov/api/catalog/v1?only=dataset&limit=2000&q=texas
* Crime: https://data.texas.gov/api/catalog/v1?only=dataset&limit=2000&q=crime


Austin: 
* https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov  

Texas.gov: 
* https://api.us.socrata.com/api/catalog/v1?domains=data.texas.gov

Texas: 
* https://data.texas.gov/api/catalog/v1?only=dataset&limit=2000&q=texas

Crime:
* https://data.texas.gov/api/catalog/v1?only=dataset&limit=2000&q=crime



```sh
CATALOG_URL='https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=2000'

curl -o data/texas-gov.json "${CATALOG_URL}&domains=data.texas.gov"
curl -o data/texas.json "${CATALOG_URL}&q=texas"
curl -o data/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov"

./scripts/markdown.sh data/texas-gov.json -Y >texas-gov.md
./scripts/markdown.sh data/texas.json -Y >texas.md
./scripts/markdown.sh data/austin.json -Y >austin.md
```


[data.austintexas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=data.austintexas.gov
[datahub.austintexas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov
[data.texas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=data.texas.gov