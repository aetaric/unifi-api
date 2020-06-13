# UniFi-Api
A simple gem that queries the UniFi OS API

This gem is incomplete. It will allow you to query for all IPS/IDS/Switching alerts as well as archiving events.

## Installation
This gem isn't published on RubyGems, so you will have to build out the gem file yourself.
  1. Clone the git source
  2. `gem build unifi-api.gemspec`
  3. `sudo gem install unifi-api-1.0.0.gem`

## Usage
  To include in a project...
  `require 'unifi/api'`
  
  Login is done on class init.
  `unifi = UniFi::Api.new('192.168.0.1', 'ubnt', 'ubnt')`

## Contributing
  Fork, fix, PR... You know the drill.

## Bugs and Issues
  I've tried rather hard to ensure there are no bugs with this gem so far. If you do find one, file an issue outlining the following:
  * UniFi OS version
  * UniFi Network Version
  * What you expected to happen
  * What happened instead
  * Any produced errors
