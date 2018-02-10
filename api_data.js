define({ "api": [
  {
    "type": "get",
    "url": "/api/version",
    "title": "Get API Version",
    "version": "1.0.0",
    "name": "GetVersion",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Api",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "version",
            "description": "<p>Version of the API</p>"
          },
          {
            "group": "Success 200",
            "type": "Object[]",
            "optional": false,
            "field": "providers",
            "description": "<p>Authentication endpoints</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "allowedValues": [
              "[\"github\"]"
            ],
            "optional": false,
            "field": "providers.type",
            "description": "<p>Type of provider oauth</p>"
          },
          {
            "group": "Success 200",
            "type": "Boolean",
            "optional": false,
            "field": "providers.enabled",
            "description": "<p>Whether the provide is enabled or not</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.id_application",
            "description": "<p>Id of the application in the oauth provider</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.server",
            "description": "<p>Server Address</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.version",
            "description": "<p>API Prefix</p>"
          },
          {
            "group": "Success 200",
            "type": "Boolean",
            "optional": false,
            "field": "providers.verify",
            "description": "<p>Does it need verify?</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{\n    \"data\": {\n        \"version\": \"1.0\",\n        \"providers\": {\n            \"github.com\": {\n                \"type\": \"github\",\n                \"enabled\": true,\n                \"id_application\": \"ID_OF_APPLICATION\",\n                \"server\": \"api.github.com\",\n                \"version\": \"v3\",\n                \"verify\": true\n            }\n        }\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/api_controller.rb",
    "groupTitle": "Api"
  },
  {
    "type": "get",
    "url": "/spin_candidates",
    "title": "Request list of spin_candidates for the user",
    "version": "1.0.0",
    "name": "GetSpinCandidate",
    "group": "SpinCandidate",
    "permission": [
      {
        "name": "user",
        "title": "User Authentication Needed",
        "description": ""
      }
    ],
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "version",
            "description": "<p>Version of the API</p>"
          },
          {
            "group": "Success 200",
            "type": "Object[]",
            "optional": false,
            "field": "providers",
            "description": "<p>Authentication endpoints</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "allowedValues": [
              "[\"github\"]"
            ],
            "optional": false,
            "field": "providers.type",
            "description": "<p>Type of provider oauth</p>"
          },
          {
            "group": "Success 200",
            "type": "Boolean",
            "optional": false,
            "field": "providers.enabled",
            "description": "<p>Whether the provide is enabled or not</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.id_application",
            "description": "<p>Id of the application in the oauth provider.</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.server",
            "description": "<p>Server Address</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "providers.version",
            "description": "<p>API Prefix</p>"
          },
          {
            "group": "Success 200",
            "type": "Boolean",
            "optional": false,
            "field": "providers.verify",
            "description": "<p>Does it need verify?</p>"
          }
        ]
      }
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/spin_candidates_controller.rb",
    "groupTitle": "SpinCandidate"
  },
  {
    "type": "get",
    "url": "/tags/:id",
    "title": "Request tag info",
    "version": "1.0.0",
    "name": "GetTagInfo",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>Tag id or name</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "data.id",
            "description": "<p>ID of the tag</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.name",
            "description": "<p>Tag name</p>"
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.created_at",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.updated_at",
            "description": ""
          }
        ],
        "No Content 204": [
          {
            "group": "No Content 204",
            "optional": false,
            "field": "NoContent",
            "description": "<p>Response has no content</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{\n    \"data\": {\n        \"id\": 1,\n        \"name\": \"report\",\n        \"created_at\": \"2018-01-26T12:18:11.959Z\",\n        \"updated_at\": \"2018-01-26T12:18:11.959Z\"\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/tags_controller.rb",
    "groupTitle": "Tags"
  },
  {
    "type": "get",
    "url": "/tags?query=",
    "title": "Request search",
    "version": "1.0.0",
    "name": "GetTagQuery",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": true,
            "field": "query",
            "description": "<p>?] Search parameter</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "data.id",
            "description": "<p>ID of the tag</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.name",
            "description": "<p>Tag name</p>"
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.created_at",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.updated_at",
            "description": ""
          }
        ],
        "No Content 204": [
          {
            "group": "No Content 204",
            "optional": false,
            "field": "NoContent",
            "description": "<p>Response has no content</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{\n    \"data\": {\n        \"id\": 1,\n        \"name\": \"report\",\n        \"created_at\": \"2018-01-26T12:18:11.959Z\",\n        \"updated_at\": \"2018-01-26T12:18:11.959Z\"\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/tags_controller.rb",
    "groupTitle": "Tags"
  },
  {
    "type": "get",
    "url": "/tags",
    "title": "Request index of tags",
    "version": "1.0.0",
    "name": "GetTags",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Tags",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Object[]",
            "optional": false,
            "field": "data",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "data.id",
            "description": "<p>ID of the tag</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.name",
            "description": "<p>Tag name</p>"
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.created_at",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Date",
            "optional": false,
            "field": "data.updated_at",
            "description": ""
          }
        ],
        "No Content 204": [
          {
            "group": "No Content 204",
            "optional": false,
            "field": "NoContent",
            "description": "<p>Response has no content</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{ \"data\":\n    [\n    {\n       \"id\": 1,\n       \"name\": \"report\",\n       \"created_at\": \"2018-01-26T12:18:11.959Z\",\n       \"updated_at\": \"2018-01-26T12:18:11.959Z\"\n    },\n    {\n       \"id\": 2,\n       \"name\": \"playbook\",\n       \"created_at\": \"2018-01-26T12:18:11.965Z\",\n       \"updated_at\": \"2018-01-26T12:18:11.965Z\"\n    },\n    {\n       \"id\": 3,\n       \"name\": \"dialogue\",\n       \"created_at\": \"2018-01-26T12:18:11.970Z\",\n       \"updated_at\": \"2018-01-26T12:18:11.970Z\"\n    },\n    {\n        \"id\": 4,\n        \"name\": \"workflow\",\n        \"created_at\": \"2018-01-26T12:18:11.974Z\",\n        \"updated_at\": \"2018-01-26T12:18:11.974Z\"\n      }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/tags_controller.rb",
    "groupTitle": "Tags"
  },
  {
    "type": "get",
    "url": "/users",
    "title": "Request user index",
    "version": "1.0.0",
    "name": "GetUsers",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Users",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "Object[]",
            "optional": false,
            "field": "data.user",
            "description": "<p>User data</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.github_id",
            "description": "<p>ID of user in source control</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.login",
            "description": "<p>Login</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.url_profile",
            "description": "<p>Url of the profile in source control</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "meta",
            "description": "<p>Metadata</p>"
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "meta.current_page",
            "description": "<p>Current page in pagination</p>"
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "meta.total_pages",
            "description": "<p>Total number of pages</p>"
          },
          {
            "group": "Success 200",
            "type": "Integer",
            "optional": false,
            "field": "meta.total_count",
            "description": "<p>Total number of elements</p>"
          }
        ],
        "No Content 204": [
          {
            "group": "No Content 204",
            "optional": false,
            "field": "NoContent",
            "description": "<p>Response has no content</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{\n    \"data\": [\n        {\n            \"github_id\": \"7500590\",\n            \"login\": \"chargio\",\n            \"url_profile\": \"https://github.com/chargio\"\n        }\n    ],\n    \"meta\": {\n        \"current_page\": 1,\n        \"total_pages\": 1,\n        \"total_count\": 1\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/users_controller.rb",
    "groupTitle": "Users"
  },
  {
    "type": "get",
    "url": "/users/:id",
    "title": "Request user info",
    "version": "1.0.0",
    "name": "GetUsersShow",
    "permission": [
      {
        "name": "none"
      }
    ],
    "group": "Users",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Integer",
            "optional": false,
            "field": "id",
            "description": "<p>User unique ID.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": ""
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.github_id",
            "description": "<p>Github numeric ID</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.login",
            "description": "<p>Github login</p>"
          },
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "data.user.url_profile",
            "description": "<p>Profile link</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success",
          "content": "{\n    \"data\": {\n        \"github_id\": \"7500590\",\n        \"login\": \"chargio\",\n        \"url_profile\": \"https://github.com/chargio\"\n    }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "No Content 404": [
          {
            "group": "No Content 404",
            "optional": false,
            "field": "UserNotFound",
            "description": "<p>User has not been found</p>"
          },
          {
            "group": "No Content 404",
            "type": "Integer",
            "optional": false,
            "field": "UserNotFound.status",
            "description": "<p>404</p>"
          },
          {
            "group": "No Content 404",
            "type": "String",
            "optional": false,
            "field": "UserNotFound.code",
            "description": "<p>user_not_found</p>"
          },
          {
            "group": "No Content 404",
            "type": "String",
            "optional": false,
            "field": "UserNotFound.title",
            "description": "<p>Error title</p>"
          },
          {
            "group": "No Content 404",
            "type": "String",
            "optional": false,
            "field": "UserNotFound.Detail",
            "description": "<p>Additional detail on error</p>"
          },
          {
            "group": "No Content 404",
            "type": "Object",
            "optional": false,
            "field": "UserNotFound.extra",
            "description": ""
          },
          {
            "group": "No Content 404",
            "type": "String",
            "optional": false,
            "field": "UserNotFound.extra.username",
            "description": "<p>User ID</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "User not found",
          "content": "{\n    \"status\": 404,\n    \"code\": \"user_not_found\",\n    \"title\": \"This user is not in the database\",\n    \"detail\": \"Maybe the id of user is wrong\",\n    \"extra_info\": {\n        \"username\": \"7500591\"\n    }\n}",
          "type": "json"
        }
      ]
    },
    "filename": "/home/travis/build/ManageIQ-Exchange/manageiq-exchange/app/controllers/v1/users_controller.rb",
    "groupTitle": "Users"
  }
] });
