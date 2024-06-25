# Open Data Catalogs

**Catalogs that I query from [Socrata](https://api.us.socrata.com/api/catalog/v1?only=dataset):**

* [austin.md](./catalog/austin.md)
* [crime.md](./catalog/crime.md)
* [datasets.md](./catalog/datasets.md)
* [jobs.md](./catalog/jobs.md)
* [police.md](./catalog/police.md)
* [public-safety.md](./catalog/public-safety.md)
* [salaries.md](./catalog/salaries.md)
* [shootings.md](./catalog/shootings.md)
* [survey.md](./catalog/survey.md)
* [texas-gov.md](./catalog/texas-gov.md)
* [texas.md](./catalog/texas.md)
  

## Update Catalogs

```sh
./scripts/update-catalogs.sh data catalog

# update single catalog
jq -L scripts -r 'include "views";results|write_markdown' data/austin.json
```

## Personal Favorite

- [Waste Summary for Tesla](https://data.texas.gov/resource/79s2-9ack.json?form_submitter=TESLA)

- [Waste Summary for Companies in 2024](https://data.texas.gov/resource/79s2-9ack.json?$select=form_submitter,handling_code,count(handling_code),sum(p_quantity_generated)&$group=form_submitter,handling_code&$where=record_date>'2024-01-01'&$limit=10000)

- [Cincinnati Salaries](https://data.cincinnati-oh.gov/resource/wmj4-ygbf.json)  
  w/ gender, race, and age range

- [Austin Demographics](https://datahub.austintexas.gov/resource/puux-7swp.json)  
  (householder_living_alone, median_home_sale_price, below_poverty, hh_income_200000_or_more)

- [Austin District 7 Housing Directory](https://data.austintexas.gov/resource/4syj-z4ky.json?council_district=7)


### Crime

- [APD Computer Aided Dispatch Incidents](https://data.austintexas.gov/resource/22de-7rzg.json?$order=response_datetime%20DESC)

- [Austin Crime Charges](https://datahub.austintexas.gov/resource/mv2b-q2wb.json)  
  gender, officer, race, gender, etc [(count)](https://datahub.austintexas.gov/resource/mv2b-q2wb.json?$group=charges_description&$select=charges_description,count(*))

- [APD Use of Force](https://data.austintexas.gov/resource/8dc8-gj97.json?$order=occurred_on_date%20DESC)

- [APD Arrests](https://data.austintexas.gov/resource/9tem-ywan.json?$group=subject_race_ethnicity,subject_gender&$select=subject_race_ethnicity,subject_gender,count(*)&$order=subject_race_ethnicity)  
  Group by ethnicity and gender
  
- [Hate Crime](https://data.austintexas.gov/resource/xtu5-exci.json?$group=bias&$select=bias,count(race_ethnicity_of_offenders)&$order=bias)  
  Bias: `$group=bias&$select=bias,count(race_ethnicity_of_offenders)&$order=bias`  
  Offenders: `$group=race_ethnicity_of_offenders&$select=race_ethnicity_of_offenders,count(bias)`