# README

This is the API only backend application for Galaxy. It is prepared to be deployed on OpenShift online using 3 pods (React frontend, this backend, database)

It has been developed using:
* Ruby 2.4
* Rails 5.1 (API MODE)
* Devise
* Tiddle
* Octokat

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
Please review Developers.md

