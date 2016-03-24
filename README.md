## Installation

    $ gem install letsencrypt_standalone

## Usage

config file like this:

```
{
  "path": "./",
  "email": "admin@example.com",
  "domains": [
    {
      "host": "example.com"
    }
  ]
}

```

choose acme backend

```
LE_ENVIRONMENT=staging
```
