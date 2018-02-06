[Back to Guides](../README.md)

# Api


- [Query params](#query-params)
  - [Expand Resources](#expand-resources)
  - [Pagination](#pagination)



## Query Params

### Expand resources

By default API returns the values of **attributes** for normal users, if you wanna get more attributes you can get them with **expand=resources**

**Request**
```bash

http://localhost:3000/users?expand=resources

```
**Return**
```json
{
  "github_id":   "789",
  "login":       "john",
  "url_profile": "https://github.com/john"
}
  

```
**Request**
```bash

http://localhost:3000/users?expand=resources

```
**Return**
```json
{
  "github_id":         "789",
  "login":             "john",
  "url_profile":       "https://github.com/john",
  "name":              "John",
  "avatar":            "https://avatars2.githubusercontent.com/u/345?v=4",
  "company":           "Exchange Company",
  "github_type":       "User",
  "github_blog":       "",
  "github_location":   "Madrid,Spain",
  "github_bio":        "John Bio",
  "github_created_at": "2017-12-13T08:55:34.493Z",
  "github_updated_at": "2017-12-13T12:50:34.493Z"
}
```

For more information about how this is working you can see the [produc/json_returns.yml](https://github.com/ManageIQ-Exchange/manageiq-exchange/blob/master/product/json_returns.yml) file

```yaml
users:
  attributes: ["github_id","github_login","github_html_url"]
  expand: ["name", "github_avatar_url","github_company","github_type","github_blog","github_location","github_bio","github_created_at","github_updated_at"]
  staff: ["sign_in_count","current_sign_in_at","last_sign_in_at","current_sign_in_ip","last_sign_in_ip","created_at","updated_at"]
  admin: ["id","email"]
  columns:
    github_login: "login"
    github_html_url: "url_profile"
    github_avatar_url: "avatar"
    github_company: "company"
```
### Pagination


The information about Pagination will be in the meta object

```json

"meta":{
  "current_page":       3,
  "total_pages":        4,
  "total_count":        4,
  "next_page":          4,
  "prev_page":          2,
  "href_previous_page": "http://localhost:3000/users?limit=1&page=2"
  "href_next_page":     "http://localhost:3000/users?limit=1&page=4"
}

```

- **Current page** is the request page
- **Total page** is the total pages for this request
- **Total count** is the count of the records for this request
- **Next page** is the next page number
  - If the page is not the last one
- **Prev page** is the previous page number
  - If the page is not the first one
- **Href Prev page** is the url to call previous page request
  - If the page is not the first one
- **Href next page** is the url to call next page request
  - If the page is not the last one

The href next_previous page will have al query params that you sent in the initial request.

By default the number of records per page is 20, you can change this number with the query param **limit=number**

**Sample**

```bash
curl -X GET "http://localhost:3000/users?limit=1&page=3"
```

```json
{
  "data":[ ... ],
  "meta":{
    "current_page":       3,
    "total_pages":        4,
    "total_count":        4,
    "next_page":          4,
    "prev_page":          2,
    "href_previous_page": "http://localhost:3000/users?limit=1&page=2",
    "href_next_page":     "http://localhost:3000/users?limit=1&page=4"
  }
}
```

```bash
curl -X GET "http://localhost:3000/users?limit=1&page=1"
```

```json
{
  "data":[ ... ],
  "meta":{
    "current_page":       1,
    "total_pages":        4,
    "total_count":        4,
    "next_page":          2,
    "href_next_page":     "http://localhost:3000/users?limit=1&page=4"
  }
}
```

```bash
curl -X GET "http://localhost:3000/users?limit=1&page=4"
```

```json
{
  "data":[ ... ],
  "meta":{
    "current_page":       4,
    "total_pages":        4,
    "total_count":        4,
    "prev_page":          3,
    "href_previous_page":     "http://localhost:3000/users?limit=1&page=3"
  }
}
```