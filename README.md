# README

This is the API only backend application for Galaxy. It is prepared to be deployed on OpenShift online using 3 pods (React frontend, this backend, database)

It has been developed using:
* Ruby 2.4
* Rails 5.1 (API MODE)
* Devise
* Tiddle
* Octokat


## Getting Help

If you find a bug, please report an [Issue](https://github.com/miq-consumption/manageiq-galaxy/issues/new)
and see our [contributing guide](CONTRIBUTING.md).

If you have a question, please [post to Stack Overflow](https://stackoverflow.com/questions/tagged/manageiq-galaxy).


Thanks!

## Documentation

If you're reading this at https://github.com/miq-consumption/manageiq-galaxy you are
reading documentation for our `master`, which is not yet released.

- [0.1.0 (master) Documentation](https://github.com/miq-consumption/manageiq-galaxy/tree/master)
  - [![API Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://www.rubydoc.info/github/miq-consumption/manageiq-galaxy/master)
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
- GALAXY_MAILER_HOST
- GALAXY_MAILER_PORT
- GALAXY_EMAIL_SENDER


## Developer documentation
Please review [Developers Guide](Developers.md)

