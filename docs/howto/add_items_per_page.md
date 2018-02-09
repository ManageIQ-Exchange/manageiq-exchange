[Back to Guides](../README.md)

# Configure items to return in request by default 

You can configure it in **config/secrets.yml**

```yaml
  return_configuration:
    items_per_page: 20
```

If request don't have query param **limit**, the application will use the value by default **items_per_page**