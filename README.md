# websolr-gem
A Websolr gem to make RSolr/Sunspot-based applications faster

This gem makes some changes to the connection class that RSolr defaults to. Namely, it configures Faraday to use the [Typhoeus](https://github.com/typhoeus/typhoeus) adapter, which is significantly faster (especially when dealing with SSL/TLS). It also adds support for HTTP Keep-Alive and Websolr's [Advanced Authentication](https://docs.websolr.com/article/172-advanced-auth) system.

Preliminary tests of the gem found latency and speed increased dramatically:

<table>
	<tr>
		<th></th>
		<th>Reindex 50K Documents<br />(batch size of 50)</th>
		<th>1K Random Searches</th>
		<th>1K Random Operations<br />(read/update)</th>
</th>
 	</tr>
 	<tr>
  		<td>No Gem</td>
   		<td>496.8 s</td>
		<td>196.7 s</td>
		<td>63.6 s</td>
 	</tr>
	<tr>
  		<td>With Gem</td>
   		<td>279.1 s</td>
		<td>44 s</td>
		<td>17.6 s</td>
 	</tr>
	<tr>
  		<td>Speed Increase</td>
   		<td>78%</td>
		<td>347%</td>
		<td>261%</td>
 	</tr>
	<tr>
  		<td>Latency Decrease</td>
   		<td>43.8%</td>
		<td>77.6%</td>
		<td>72.3%</td>
 	</tr>
</table>
					
Another benefit of using Typhoeus is access to the Hydra, which makes it possible to make requests in parallel, theoretically allowing one to speed up indexing significantly.

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
- [ ] Support for queueing failed requests?
- [ ] Support for throttling?
- [ ] Support for parallel reindexing?
- [ ] Test coverage
- [ ] Documentation
