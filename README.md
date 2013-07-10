Not a lot implemented yet. Code is messy. Some examples, if you feel curious:

``` ruby
$: << File.expand_path('lib')
require 'uri_mapper/uri'

google = UriMapper::Uri.new('http://google.com?search=foo')

# full map + change uri in block
google.map { |u| u.query['search'] = 'bar' }.to_s # => "http://google.com?search=bar"

# only change query component
google.map(:query) { |q| q['search'].upcase! }.to_s # => "http://google.com?search=FOO"

# a bit simpler if the change is static
google.map(:query => {'search' => 'bar'}).to_s # => "http://google.com?search=bar"

# change other components as well (not implemented yet)
# dawanda = UriMapper::Uri.new('http://de.dawanda.com')
# dawanda.map(:subdomain => 'en') # =>

# or, if `map` seems weird for the use case, maybe `merge`?
google.merge(:query => 'color=blue').to_s # => "http://google.com?search=foo&color=blue"
```
