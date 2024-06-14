# open data

Catalog for open data 

* [austin.md](./austin.md)
* [crime.md](./crime.md)
* [datasets.md](./datasets.md)
* [police.md](./police.md)
* [salaries.md](./salaries.md)
* [shootings.md](./shootings.md)
* [texas-gov.md](./texas-gov.md)
* [texas.md](./texas.md)


## Update Catalogs

```sh
./scripts/update.sh data
```

## Example 

```sh
curl -o data/austin.json "${CATALOG_URL}&domains=datahub.austintexas.gov"

./scripts/markdown.sh data/austin.json -Y >austin.md
./scripts/markdown.sh data/austin.json -Y --group .classification 
```

## Personal Favorite

* [Waste Summary for Tesla](https://data.texas.gov/resource/79s2-9ack.json?form_submitter=TESLA)  

* [Waste Summary for Companies in 2024](https://data.texas.gov/resource/79s2-9ack.json?$select=form_submitter,handling_code,count(handling_code),sum(p_quantity_generated)&$group=form_submitter,handling_code&$where=record_date>'2024-01-01'&$limit=10000)  
  
* [Cincinnati Salaries w/ gender, race, and age range](https://data.cincinnati-oh.gov/resource/wmj4-ygbf.json)

* [Austin Demographics](https://datahub.austintexas.gov/resource/puux-7swp.json) (householder_living_alone, median_home_sale_price, below_poverty, hh_income_200000_or_more)
