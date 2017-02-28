## Installation

    $ gem install letsencrypt_standalone

## Usage

config file like this:

```js
{
  "path": "./",
  "ssl_dir": "ssl_certs", //relative to "path"
  "email": "admin@example.com",
  "domains": [
    {
      "host": "example.com"
    }
  ]
}

```

Full config example:
```js
{
  "path": "./",
  "ssl_dir": "ssl_certs", //relative to "path"
  "email": "admin@example.com", //let's encrypt account email
  "domains": [
    {
      "host": "api.partnerchat.ru", // fqdn 
      "private_key": "private_key.pem", // private key, will be generated automatically if the field does not exist
      // certificates files. if exists fullchain.pem will be used to check expiration date.
      // New certificates will be automatically obtained when expiration date comes in 2 two days
      "certificates": { 
        "certificate": "cert.pem",
        "chain": "chain.pem",
        "fullchain": "fullchain.pem"
      }
    }
  ],
  "account": "account.pem" // let's encrypt account key. Will be automatically generated if the field not exists
}
```
Run

`le_standalone -h`

choose acme backend

```
LE_ENVIRONMENT=staging // if the variable doesn't exist will be used production backend
```
