# Open Data Catalogs

**Catalogs that I query from [Socrata](https://api.us.socrata.com/api/catalog/v1?only=dataset):**

- [austin.md](./catalog/austin.md)
- [cdc.md](./catalog/cdc.md)
- [crime.md](./catalog/crime.md)
- [datasets.md](./catalog/datasets.md)
- [jobs.md](./catalog/jobs.md)
- [police.md](./catalog/police.md)
- [public-safety.md](./catalog/public-safety.md)
- [salaries.md](./catalog/salaries.md)
- [shootings.md](./catalog/shootings.md)
- [survey.md](./catalog/survey.md)
- [texas-gov.md](./catalog/texas-gov.md)
- [texas.md](./catalog/texas.md)

---

Read my answers on StackOverflow:  
https://stackoverflow.com/search?q=user:7460613+socrata

View (unorganized) notes:  
https://github.com/nntrn/open-data/wiki


## Scripts

```sh
# update documents in ./catalogs
./scripts/update-catalogs.sh data catalog

# update domains list in docs/domains.md
./scripts/domains.sh >docs/domains.md

# remove commit history for catalog docs
./scripts/flush-commits.sh  'catalog/*.md'
```

## Socrata

Get views for domain: [/api/views.json](https://data.austintexas.gov/api/views.json)

List of open government domains:  
https://api.us.socrata.com/api/catalog/v1/domains

```
https://api.us.socrata.com/api/catalog/v1
?order=updatedAt%20DESC
&domains=datahub.austintexas.gov,data.texas.gov
&only=dataset
&limit=2000
```
[View](https://api.us.socrata.com/api/catalog/v1?order=updatedAt%20DESC&domains=datahub.austintexas.gov,data.texas.gov&only=dataset&limit=2000)


## Datasets I like

### Texas

- [Austin Demographics]  
  % living alon, median home price, % below poverty, income bracket

- [Austin District 7 Housing Directory]

- [Austin Workforce Demographics]  
  Group by: [age group]

- [Texas life sentences]

### APD

- [APD Computer Aided Dispatch Incidents]

- [Austin Crime Charges]  
  gender, officer, race, gender, etc [(count)][austin_crime_count]

- [Use of Force]  
  This dataset contains offense incidents where any physical contact with a subject was made by an officer

- [Arrests]  
  Group by: [ethnicity and gender]

- [Austin Hate Crimes]  
  Group by: [Race] | [Bias]


### Misc 

- [Waste Summary] in Texas  
  &dash; [limit to waste by Tesla]  
  &dash; [sum quantity for each corp in 2024]

- [Cincinnati Salaries]  
  w/ gender, race, and age range

- [Major US Open Data Domains]  
  An incomplete collection of open data domains throughout the U.S. (intended for comparison with King County open data)

- [Washington State Hospital Quarterly Revenue]  
  This dataset provides revenue figures for several clinical units and patient-types
  
  
<!-- URLs -->

[Waste Summary]: https://data.texas.gov/resource/79s2-9ack.json
[limit to waste by Tesla]: https://data.texas.gov/resource/79s2-9ack.json?form_submitter=TESLA
[sum quantity for each corp in 2024]: https://data.texas.gov/resource/79s2-9ack.json?$select=form_submitter,handling_code,count(handling_code),sum(p_quantity_generated)&$group=form_submitter,handling_code&$where=record_date>'2024-01-01'&$limit=10000
[Cincinnati Salaries]: https://data.cincinnati-oh.gov/resource/wmj4-ygbf.json
[Washington State Hospital Quarterly Revenue]: https://data.wa.gov/id/kwf8-x25v.json
[Major US Open Data Domains]: https://data.kingcounty.gov/resource/waaj-pqt3.json
[Arrests]: https://data.austintexas.gov/resource/9tem-ywan.json
[Use of Force]: https://data.austintexas.gov/resource/8dc8-gj97.json?$order=occurred_on_date%20DESC
[ethnicity and gender]: https://data.austintexas.gov/resource/9tem-ywan.json?$group=subject_race_ethnicity,subject_gender&$select=subject_race_ethnicity,subject_gender,count(*)&$order=subject_race_ethnicity
[APD Computer Aided Dispatch Incidents]: https://data.austintexas.gov/resource/22de-7rzg.json?$order=response_datetime%20DESC
[Austin Crime Charges]: https://datahub.austintexas.gov/resource/mv2b-q2wb.json
[austin_crime_count]: https://datahub.austintexas.gov/resource/mv2b-q2wb.json?$group=charges_description&$select=charges_description,count(*)
[Austin District 7 Housing Directory]: https://data.austintexas.gov/resource/4syj-z4ky.json?council_district=7
[Austin Demographics]: https://datahub.austintexas.gov/resource/puux-7swp.json
[Austin Workforce Demographics]: https://datahub.austintexas.gov/resource/fxtq-ff2c.json
[age group]: https://datahub.austintexas.gov/resource/fxtq-ff2c.json?$select=age_group,sum(employee_count)&$group=age_group&hr_f_year_id=2023&$order=age_group
[Austin Hate Crimes]: https://data.austintexas.gov/resource/xtu5-exci.json
[Bias]: https://data.austintexas.gov/resource/xtu5-exci.json?$group=bias&$select=bias,count(race_ethnicity_of_offenders)&$order=bias
[Race]: https://data.austintexas.gov/resource/xtu5-exci.json?$group=race_ethnicity_of_offenders&$select=race_ethnicity_of_offenders,count(bias)
[Texas life sentences]: https://data.texas.gov/id/fgzd-wjkz.json?sentence_years=%27Life%27&$limit=10000
