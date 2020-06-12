Gem::Specification.new do |s|
  s.name        = 'unifi-api'
  s.version     = '1.0.0'
  s.date        = '2020-06-11'
  s.summary     = "UniFi OS API client in Ruby"
  s.description = "A gem to capture select events in the UniFi Os Environment"
  s.authors     = ["Dustin Essington"]
  s.email       = 'aetaric@gmail.com'
  s.files       = ["lib/unifi/api.rb", "lib/unifi/errors/errors.rb"]
  s.homepage    =
    'https://ui.com'
  s.license       = 'WTFPL'
  s.add_runtime_dependency 'jwt', '~> 2.2'
end
