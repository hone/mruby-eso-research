MRuby::Gem::Specification.new('eso-research') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Terence Lee'
  spec.summary = 'ESO Research'
  spec.bins    = ['eso-research']
  spec.add_dependency 'mruby-print', :core => 'mruby-print'
  spec.add_dependency 'mruby-yaml', :github => 'hone/mruby-yaml'
  spec.add_dependency 'mruby-getopts', :github => 'hone/mruby-getopts'
  spec.add_dependency 'mruby-io', :mgem => 'mruby-io'
  spec.add_dependency 'mruby-array-ext', :core => 'mruby-array-ext'
  spec.add_dependency 'mruby-enumerator', :core => 'mruby-enumerator'
  spec.add_dependency 'mruby-mtest', :mgem => 'mruby-mtest'
end
