require 'letsencrypt_standalone/base'
require 'letsencrypt_standalone/certificate'
require 'letsencrypt_standalone/client'
require 'letsencrypt_standalone/config'
require 'letsencrypt_standalone/domain'
require 'letsencrypt_standalone/version'

module LetsencryptStandalone
  PROD_URL  = 'https://acme-v01.api.letsencrypt.org/'
  STAGE_URL = 'https://acme-staging.api.letsencrypt.org/'
end
