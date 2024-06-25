# Resources

## Domains

* [data.austintexas.gov]  
* [datahub.austintexas.gov]  
* [data.texas.gov]

## API

* [data.austintexas.gov/api/views/<strong>&lt;resource_id&gt;</strong>][VIEWS]

* [data.austintexas.gov/resource/<strong>&lt;resource_id&gt;</strong>.json][DATASET RESOURCE]


## Discovery

* https://dev.socrata.com/docs/other/discovery#?route=overview

* https://catalog.data.gov/api/3/action/package_search?rows=10&start=0


## Catalog

```
https://api.us.socrata.com/api/catalog/v1?ids={{ids}}
&domains={{domains}}
&search_context={{search_context}}
&categories={{categories}}
&tags={{tags}}
&q={{q}}
&min_should_match={{min_should_match}}
&only={{only}}
&attribution={{attribution}}
&license={{license}}
&derived_from={{derived_from}}
&provenance={{provenance}}
&for_user={{for_user}}
&column_names={{column_names}}
&order={{order}}
&derived={{derived}}
&boostOfficial={{boostOfficial}}
```

* Count of each domain  
  [api.us.socrata.com/api/catalog/v1/domains](https://api.us.socrata.com/api/catalog/v1/domains)

* Facets  
  [api.us.socrata.com/api/catalog/v1/domains/<strong>&lt;domain&gt;/facets](https://api.us.socrata.com/api/catalog/v1/domains/datahub.austintexas.gov/facets)
  
* [api.us.socrata.com/api/catalog/v1?domains=<strong>&lt;metadata_domain&gt;</strong>&only=dataset][CATALOG]

* Search Austin Catalog for 'budget':  
  [api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset<strong>&q=budget</strong>][austin_catalog_budget]

---

* Find by query term: `/catalog/v1?q=`  
  Limit the results to those having some or all of the text in:  
  **name**, **description**, **category**, **tags**, **column fieldnames** and **column descriptions**

* Find by id: `/catalog/v1{?ids}`  
  https://api.us.socrata.com/api/catalog/v1?ids=a7mk-8suc,q5as-kyim

* Find by **[domain]**: `/catalog/v1{?domains,search_context}`   
  https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&search_context=

* Find by name: `/catalog/v1{?names}`  
  https://api.us.socrata.com/api/catalog/v1?names=

* Find by **[categories]** or **[tags]**: `/catalog/v1{?categories,tags,search_context}`  
  https://api.us.socrata.com/api/catalog/v1?categories=education  
  https://api.us.socrata.com/api/catalog/v1?search_context=data.seattle.gov

* Find by type: `/catalog/v1{?only}`  
  Can be: dataset, calendar,stories
  https://api.us.socrata.com/api/catalog/v1?only=dataset

* Find by attribution: `/catalog/v1{?attribution}`  
  https://api.us.socrata.com/api/catalog/v1?attribution=

* Find by license: `/catalog/v1{?license}`  
  https://api.us.socrata.com/api/catalog/v1?license=

* Find by query term: `/catalog/v1{?q,min_should_match}`  
  https://api.us.socrata.com/api/catalog/v1?q,min_should_match=

* Find by parent id: `/catalog/v1{?parent_ids}`  
  https://api.us.socrata.com/api/catalog/v1?parent_ids=

* Find assets derived from others: `/catalog/v1{?derived_from}`  
  https://api.us.socrata.com/api/catalog/v1?derived_from=

* Find by provenance: `/catalog/v1{?provenance}`  
  https://api.us.socrata.com/api/catalog/v1?provenance=official

* Find by owner: `/catalog/v1{?for_user}`  
  https://api.us.socrata.com/api/catalog/v1?for_user=xxry-dhpx

* Find by granted shares: `/catalog/v1{?shared_to,domains}`  
  https://api.us.socrata.com/api/catalog/v1?shared_to,domains=

* Find by column name: `/catalog/v1{?column_names}`  
  https://api.us.socrata.com/api/catalog/v1?column_names=

* Find by visibility: `/catalog/v1{?visibility}`  
  https://api.us.socrata.com/api/catalog/v1?visibility=

* Find by audience: `/catalog/v1{?audience}`  
  https://api.us.socrata.com/api/catalog/v1?audience=

* Find by publication status: `/catalog/v1{?published}`  
  https://api.us.socrata.com/api/catalog/v1?published=

* Find by approval status: `/catalog/v1{?approval_status}`  
  https://api.us.socrata.com/api/catalog/v1?approval_status=

* Find hidden/unhidden assets: `/catalog/v1{?explicitly_hidden}`  
  https://api.us.socrata.com/api/catalog/v1?explicitly_hidden=

* Find assets hidden/unhidden from the data.json catalog: `/catalog/v1{?data_json_hidden}`  
  https://api.us.socrata.com/api/catalog/v1?data_json_hidden=true

* Find derived/base assets: `/catalog/v1{?derived}`  
  https://api.us.socrata.com/api/catalog/v1?derived=

* Sort order: `/catalog/v1{?order}`  
  https://api.us.socrata.com/api/catalog/v1?order=

* Pagination: `/catalog/v1{?offset,limit}`  
  https://api.us.socrata.com/api/catalog/v1?offset,limit=

* Deep scrolling: `/catalog/v1{?scroll_id,limit}`  
  https://api.us.socrata.com/api/catalog/v1?scroll_id,limit=

* Boosting official assets: `/catalog/v1{?boostOfficial}`  
  https://api.us.socrata.com/api/catalog/v1?boostOfficial=

* Getting visibility information: `/catalog/v1{?show_visibility}`  
  https://api.us.socrata.com/api/catalog/v1?show_visibility=true
  https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset&show_visibility=true
  






<!--  -->
[austin_catalog_budget]: api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset&q=budget
[CATALOG]: https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov&only=dataset
[VIEWS]: https://data.austintexas.gov/api/views/ym8w-n945
[DATASET RESOURCE]: https://data.austintexas.gov/resource/ym8w-n945.json
[domain]: https://api.us.socrata.com/api/catalog/v1/domains
[domain_categories]: https://api.us.socrata.com/api/catalog/v1/domain_categories?limit=1000
[tags]: https://api.us.socrata.com/api/catalog/v1/domain_tags?limit=100
[categories]: https://api.us.socrata.com/api/catalog/v1/categories?limit=1000

[data.austintexas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=data.austintexas.gov
[datahub.austintexas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=datahub.austintexas.gov
[data.texas.gov]: https://api.us.socrata.com/api/catalog/v1?domains=data.texas.gov