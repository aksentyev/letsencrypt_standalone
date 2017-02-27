## Installation

    $ gem install letsencrypt_standalone

## Usage

config file like this:

```
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

Run

`le_standalone -h`

choose acme backend

```
LE_ENVIRONMENT=staging
```
