# Oauth2 server-side implementation

A demonstration of oauth2 server-side flow using the google 
oauth endpoint

[Check it out](https://oauth2-183700.appspot.com/)

### Getting started
        $ bundle install
### Configuring       
Provide your own client id, client secret, redirect uri
 in token.yaml
 ```yaml
client_id: # client id 
client_secret: # client secret 
redirect_uri: # redirect uri
```
 
### Running server

        $ ruby lib/server.rb

