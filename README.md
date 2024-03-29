# Bitary

Ruby-based implementation of the bit array data structure.

It's still under development, but as of now, it implements simple and well-optimized logic allowing you to set, unset and retrieve bits (as well as some extra features, see below).

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add bitary
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
$ gem install bitary
```

## Usage

Documentation still needs to be written, but here is a breakdown
of the main capabilities brought by the current bit array implementation:

```ruby
require 'bitary'

bit_array_sz = Bitary.new(128) # give an explicit size. Defaults to 64 bits used per item
bit_array_ar = Bitary.new(
  [255, 10, 20],
  bits_per_item: Bitary::Size::BYTE # 8 bits
) # create based on some integer array

bit_array_sz.bits_per_item # 64
bit_array_ar.bits_per_item # 8

bit_array_ar.size # 128
bit_array_ar.size # 24

# set/unset/get
bit_array_sz[23] = 1 # set bit at position 23 (0-indexed)
bit_array_sz[23] # 1
bit_array_sz[32] # 0

bit_array_ar[0] # 1
bit_array_ar[0] = 0 # unset bit at position 0 (0-indexed)
bit_array_ar[0] # 0

# traverse
bit_array_sz.each_byte do |byte|
  # do something with each byte
end

# convert
bit_array_ar.to_a # [127, 10, 20]
bit_array_ar.to_s # "01111111 00001010 00010100"

# increase/decrease bits used per item
bit_array_ar.bits_per_item = Bitary::Size::LONG # 64 bits
bit_array_ar.to_a # [8_325_652]
bit_array_ar.to_s # "0000000000000000000000000000000000000000011111110000101000010100"

bit_array_sz.bits_per_item # 64
bit_array_sz.to_a # [1_099_511_627_776, 0]
bit_array_sz.bits_per_item = Bitary::Size::INT # 32 bits
bit_array_sz.to_a # [256, 0, 0, 0]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests and `rake rubocop` to lint your code. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Patacode/bitary.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
