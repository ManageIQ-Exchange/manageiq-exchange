[Back to Guides](../README.md)

# Getting Started

- [Setting Environment](#setting-my-environment)
- [Install gems](#installation)
- [Setting Database](#setting-database)

##Setting my environment


### Oauth for connecting to github
- GITHUB_OAUTH_ID
- GITHUB_OAUTH_SECRET


First you need create a Application [here](https://github.com/settings/applications/new), you can check the [GitHub Guideline](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) for more information

### Base secret:

- SECRET_KEY_BASE

### Rails config

- RAILS_ENV
- RAILS_LOG_TO_STDOUT

### Devise
- EXCHANGE_MAILER_HOST
- EXCHANGE_MAILER_PORT
- EXCHANGE_EMAIL_SENDER

The easiest way to set the encironments is with a bash script or by CLI.

```
$ export GITHUB_OAUTH_ID=VALUE
```
##Installation


```bash
$ bundle

```
You can use *bin/setup* to prepare your enviroment 

##Setting database

```bash
$bin/rails db:create db:migrate db:seed

```
You can use *bin/setup* to prepare your enviroment 


##Start Server

```bash
$bin/rails s

```

If you wanna use manageiq-exchange in another PORT you can use -p argument

```bash
$bin/rails s -p <PORT NUMBER>

```