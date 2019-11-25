# websolr-gem
A Websolr gem to make RSolr/Sunspot-based applications faster

This gem makes some changes to the connection class that RSolr defaults to. Namely, it configures Faraday to use the [Typhoeus](https://github.com/typhoeus/typhoeus) adapter, which is significantly faster (especially when dealing with SSL/TLS). It also adds support for HTTP Keep-Alive and Websolr's [Advanced Authentication](https://docs.websolr.com/article/172-advanced-auth) system. Preliminary tests of the gem found latency reduction between 45-75%.

## Installation

Add the gem to your Gemfile and run `bundle install`:

```ruby
gem 'websolr'
```

This will add Websolr and Typhoeus to your app. The gem creates an initializer that sets up and manages the connection when the application loads.


## Todo:
- [ ] Test with apps that do not use Sunspot
- [ ] Support for getting settings via YAML?
- [ ] Support for read-only, or different credentials for read/write ops?
- [ ] Test coverage
- [ ] Documentation
