Gem::Specification.new do |spec|
  spec.name = 'aes_ruby'
  spec.version     = '0.0.0'
  spec.summary     = 'A ruby implementation of the 128 bit Advanced Encryption Standard.'
  spec.description = 'This gem provides AES encryption and decryption functionality.'
  spec.authors     = ['lidrad']
  spec.files       = ['lib/aes_ruby.rb']
  spec.require_path = 'lib'

  spec.add_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
