# Queries

```console
 $ ./scripts/markdown.sh data/texas.json -Y >texas.md
```

[Employee turnover rate](https://data.austintexas.gov/resource/ym8w-n945.json)

[Dataset](https://data.austintexas.gov/resource/28ys-ieqv.json)

## BUDGET & FINANCE

[City of Austin current budget](https://data.austintexas.gov/resource/g5k8-8sud.json?$select=department_name,COUNT(key)&$group=department_name)

[Current projects funded by the Capital Budget](https://data.austintexas.gov/resource/n982-sd58.json)

## LIVING IN AUSTIN

[Austin Projects](https://data.austintexas.gov/resource/ngdb-nm9b.json)

[LGBTQIA+ Quality of Life Study](https://data.austintexas.gov/resource/34qp-i76m.json)
questions: https://data.austintexas.gov/api/views/34qp-i76m

[Tobacco- and Smoke-Free Worksite, Housing & Campus Policies in Travis County](https://data.austintexas.gov/resource/a5m3-3rf3.json)

[Wage That an Individual Must Earn to Support a Family in Austin](https://data.austintexas.gov/resource/jfwk-6vr6.json?$order=release_year%20DESC)
This data set exists to understand the financial requirements to live in Travis County to support a family

[Park Ranking (ACL)](https://data.austintexas.gov/resource/4e5n-wnfg.json?$order=survey_question%20DESC)

[Median family income](https://data.austintexas.gov/resource/imdv-bz5y.json)

## COMMUNITY

[Austin District Demographic Data](https://data.austintexas.gov/resource/puux-7swp.json)

[Asian American Quality of Life](https://data.austintexas.gov/resource/hc5t-p62z.json)
* [`select=ethnicity,count(id)&$group=ethnicity`](https://data.austintexas.gov/resource/hc5t-p62z.json?$select=ethnicity,count(id)&$group=ethnicity)

[Community Survey by District](https://data.austintexas.gov/resource/9afg-f72h.json?$order=council_district%20DESC,id%20DESC)

[Travis County 4-Year High School Graduation Rates by Campus](https://data.austintexas.gov/resource/kzjr-yr6n.json)

[Unemployment Rate](https://data.austintexas.gov/resource/tg7m-tpy9.json)

## HOUSING

[Affordable Housing Inventory](https://data.austintexas.gov/resource/ifzc-3xz8.json?&$limit=5000)

[Comprehensive Affordable Housing Directory](https://data.austintexas.gov/resource/4syj-z4ky.json?&$limit=5000)

## Traffic

[2017 Traffic Fatalities](https://data.austintexas.gov/resource/rx3x-btgd.json)

[Real-Time Traffic Incident Reports](https://data.austintexas.gov/resource/dx9v-zd7x.json?$order=traffic_report_status_date_time%20DESC)

[Austin Crash Report Data - Crash Level Records](https://data.austintexas.gov/resource/y2wy-tgr5.json)

  * Crash Severity - Most severe injury suffered by any one person involved in the crash 
    0=UNKNOWN, 1=INCAPACITATING INJURY, 2=NON-INCAPACITATING INJURY, 3=POSSIBLE INJURY, 4=KILLED, 5=NOT INJURED

[Austin Crash Report Data - Crash Victim Demographic Records](https://data.austintexas.gov/resource/xecs-rpy9.json)

  * Person Ethnicity ID. Coded as:   
    0: UNKNOWN, 1: WHITE, 2: HISPANIC, 3: BLACK, 4: ASIAN, 5: OTHER, 6: AMER. INDIAN/ALASKAN NATIVE, 94: REPORTED INVALID, 95: NOT REPORTED
    
  * The gender of the person involved in the crash  
    0 indicating unknown, 1 indicating male and 2 indicating female.

## Death

[Death rate by suicide](https://data.austintexas.gov/resource/c96y-6jb2.json)

[Death rate by unintentional overdose](https://data.austintexas.gov/resource/ws8n-38ja.json)

[Suicide By Age Group And Gender 2012-2018](https://data.austintexas.gov/resource/cxhd-bvc3.json)

[Male Suicides by Age Group](https://data.austintexas.gov/resource/cxhd-bvc3.json?&$select=gender,age_group_in_years,COUNT(record_number)&$group=gender,age_group_in_years&$where=gender=%27MALE%27)

[Average age at death in Travis County by ZIP Code, 2011-2015](https://data.austintexas.gov/resource/ci7a-cwah.json)

## APD

[APD Average Response Time by Day and Hour](https://data.austintexas.gov/resource/fsje-8gq2.json?&$order=response_datetime%20DESC)

[Use of force](https://data.austintexas.gov/resource/8dc8-gj97.json?&$limit=5000&$order=occurred_on_date%20DESC)

[Warnings - instances where a warning was issued to the subject of the interaction for a violation.](https://data.austintexas.gov/resource/qwt7-pfwv.json)

### ARRESTS

https://data.austintexas.gov/resource/9tem-ywan.json

[Arrests by race/gender](https://data.austintexas.gov/resource/9tem-ywan.json?&$select=subject_gender,subject_race_ethnicity,COUNT(case_report_number)&$group=subject_gender,subject_race_ethnicity)

[Arrests by race](https://data.austintexas.gov/resource/9tem-ywan.json?&$select=subject_race_ethnicity,COUNT(case_report_number)&$group=subject_race_ethnicity)

### CRIME

QUERY
https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset&q=police

Data dictionary:  
https://data.austintexas.gov/resource/6w8q-suwv.json

Crime:  
https://data.austintexas.gov/resource/fdj4-gpfu.json

## Inmates

* https://data.texas.gov/id/fgzd-wjkz.json
* https://data.texas.gov/views/fgzd-wjkz

[Life sentence](https://data.texas.gov/id/fgzd-wjkz.json?&$where=sentence_years='Life')

[age < 30](https://data.texas.gov/id/fgzd-wjkz.json?&$where=age%20<%2030)

[Travis inmates by gender and race](https://data.texas.gov/id/fgzd-wjkz.json?&$select=gender,race,COUNT(case_number)&$group=gender,race&$where=county='Travis')

[Inmate count by county](https://data.texas.gov/id/fgzd-wjkz.json?&$select=county,COUNT(case_number)&$group=county)

## Hate crime
[Catalog](https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset&q=hate%20crime)

* [2017](https://data.austintexas.gov/resource/79qh-wdpx.json)
* [2018](https://data.austintexas.gov/resource/idj2-d9th.json)
* [2019](https://data.austintexas.gov/resource/e3qf-htd9.json)
* [2020](https://data.austintexas.gov/resource/mi2a-twn5.json)
* [2021](https://data.austintexas.gov/resource/dmxv-zsfa.json)
* [2022](https://data.austintexas.gov/resource/73qr-3v9c.json)
* [2023](https://data.austintexas.gov/resource/xtu5-exci.json)
* [2024](https://data.austintexas.gov/resource/t99n-5ib4.json)

## CATALOG

* Find by id: `/catalog/v1{?ids}`
* Find by domain: `/catalog/v1{?domains,search_context}`
* Find by name: `/catalog/v1{?names}`
* Find by categories or tags: `/catalog/v1{?categories,tags,search_context}`
* Find by type: `/catalog/v1{?only}`
* Find by domain-specific metadata: `/catalog/v1{?set%2dName_key%2dName,search_context}`
* Find by attribution: `/catalog/v1{?attribution}`
* Find by license: `/catalog/v1{?license}`
* Find by query term: `/catalog/v1{?q,min_should_match}`
* Find by parent id: `/catalog/v1{?parent_ids}`
* Find assets derived from others: `/catalog/v1{?derived_from}`
* Find by provenance: `/catalog/v1{?provenance}`
* Find by owner: `/catalog/v1{?for_user}`
* Find by granted shares: `/catalog/v1{?shared_to,domains}`
* Find by column name: `/catalog/v1{?column_names}`
* Find public/private assets (DEPRECATED): `/catalog/v1{?public}`
* Find by visibility: `/catalog/v1{?visibility}`
* Find by audience: `/catalog/v1{?audience}`
* Find by publication status: `/catalog/v1{?published}`
* Find by approval status: `/catalog/v1{?approval_status}`
* Find hidden/unhidden assets: `/catalog/v1{?explicitly_hidden}`
* Find assets hidden/unhidden from the data.json catalog: `/catalog/v1{?data_json_hidden}`
* Find derived/base assets: `/catalog/v1{?derived}`
* Sort order: `/catalog/v1{?order}`
* Pagination: `/catalog/v1{?offset,limit}`
* Deep scrolling: `/catalog/v1{?scroll_id,limit}`
* Boosting official assets: `/catalog/v1{?boostOfficial}`
* Getting visibility information: `/catalog/v1{?show_visibility}`

---

Austin catalog:  
https://api.us.socrata.com/api/catalog/v1?only=dataset&limit=2000&q=austin

dataset:  
https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset&limit=2000&q=police

---

?$query=SELECT%20location,%20magnitude%20WHERE%20magnitude%20%3E%204.2

```
https://soda.demo.socrata.com/resource/4tka-6guv.csv?$query=SELECT location, magnitude WHERE magnitude > 4.2

/api/views/metadata/v1?limit=10&page=1
```