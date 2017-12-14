# DEVELOPERS GUIDE

This is the API only backend application for Galaxy. It is prepared to be deployed on OpenShift online using 3 pods (React frontend, this backend, database)

It has been developed using:
* Ruby 2.4
* Rails 5.1 (API MODE)
* Devise
* Tiddle
* Octokat

### Authentication Scheme

Authentication is done using GitHub, the API does not store any method to authenticate users that is not a token.

In order to make the application work:
- Generate an application oauth authentication in GitHub
- Use the application ID (not the secret) and the user to generate a new GitHub code
- The GitHub code is a short term authentication for GitHub

Once your front end has an authentication code from GitHub

Open a session where the params[:code] include the token

- The application will authenticate agains GitHub using the code provided and the application ID and secret that identifies the application in github
- It will respond with a Token
- If the GitHub user does not exist, it will be created automatically

Once the token has been created you can use it to authenticate:

- Include the github id (numberic), and the Token in requests that need authentication
    - X-USER-ID: the github user (numeric)
    - X-USER-TOKEN: the token returned by the application
 
If a valid id and token are included, even when creating new session, authentication won't be done against GitHub.
 
 
# Documentation

Up to date documentation can be found on the following link:

[Developers documentation](http://www.rubydoc.info/github/miq-consumption/manageiq-galaxy)

For development, you will need a mean to gather a code and token from GitHub. Users are created automatically when they are authenticated

For instance, you can use [manageiq-galaxy-web](https://github.com/miq-consumption/manageiq-galaxy)

You will also need to define environment variables:
```bash
export GITHUB_OAUTH_ID=YOUR_GITHUB_CREATED_APP_ID
export GITHUB_OAUTH_SECRET=YOUR_GITHUB_CREATED_APP_SECRET
```

If you store this in a file, you can load it doing:
```bash
 $ source my_file.sh
 ```
