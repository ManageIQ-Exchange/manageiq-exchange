[![Build Status](https://travis-ci.org/ManageIQ-Exchange/manageiq-exchange.svg?branch=master)](https://travis-ci.org/ManageIQ-Exchange/manageiq-exchange)
[![API Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/miq-consumption/manageiq-exchange/master)
[![Coverage Status](https://coveralls.io/repos/github/ManageIQ-Exchange/manageiq-exchange/badge.svg?branch=master)](https://coveralls.io/github/ManageIQ-Exchange/manageiq-exchange?branch=master)

# README

This is the API only backend application for Exchange. It is prepared to be deployed on OpenShift online using 3 pods (React frontend, this backend, database)

It has been developed using:
* Ruby 2.4
* Rails 5.1 (API MODE)
* Devise
* Tiddle
* Octokat


## Getting Help

If you find a bug, please report an [Issue](https://github.com/ManageIQ-Exchange/manageiq-exchange/issues/new)
and see our [contributing guide](CONTRIBUTING.md).

If you have a question, please [post to Stack Overflow](https://stackoverflow.com/questions/tagged/manageiq-exchange).


Thanks!

## Documentation

If you're reading this at https://github.com/ManageIQ-Exchange/manageiq-exchange you are
reading documentation for our `master`, which is not yet released.

- [0.1.0 (master) Documentation](https://github.com/ManageIQ-Exchange/manageiq-exchange/tree/master)
  - [![API Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/ManageIQ-Exchange/manageiq-exchange/master)
  - [Guides](docs)
## ENVIRONMENT VARIABLES

### Oauth for connecting to github
- GITHUB_OAUTH_ID
- GITHUB_OAUTH_SECRET

### Base secret:

- SECRET_KEY_BASE

### Rails config

- RAILS_ENV
- RAILS_LOG_TO_STDOUT

### Devise
- EXCHANGE_MAILER_HOST
- EXCHANGE_MAILER_PORT
- EXCHANGE_EMAIL_SENDER

## Docker configuration to test ManageIq-Exchange

First you need to create the directory ``postgres-exchange-data``  on the same level of the docker-compose file. In this directory we'll store all database information from our postgres docker.

Remember set `GITHUB_OAUTH_ID`,`GITHUB_OAUTH_SECRET` in docker-compose file

```bash
docker-compose build
docker-compose up
```

In your first build you will need to create the database so...
```bash
docker-compose run --rm exchange bash

rails db:create db:migrate
```

You will see a prompt like root@64bfb5e14bb5:/app#`, this means that you are inside the docker. Execute:
```bash
bundle
rails db:create db:migrate
exit
```
You will see some querys, after that you can go to `http://localhost:3000/` and test ManageIQ-Exchange

To stop environment you can use `CTRL+C` and `docker-compose down`

You can restore the environment with `docker-compose up` next time without recreate database.

If you wanna remove the database and start again you only need to remove all content in `/docker-compose down/*`

## Developer documentation
Please review [Developers Guide](Developers.md)



