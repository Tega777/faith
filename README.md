# Faith

**This is a work in progress. Tasks can't be run from a CLI yet, and many
features are unimplemented.**

Faith is an **powerful and extremely versatile task runner**. Using a lovely
Ruby DSL, you can:

- Define named tasks
    - Can be invoked with arguments and options*
- Assign dependencies between tasks
- Group tasks together into sensible and organised namespaces
- Build sequences of tasks which run in order
    - Can either exit or continue if one task fails*
- Create parallel groups of tasks*
- Add mixins, which wrap tasks to enhance their environment by running _before_
  and _after_ tasks

\* - Not yet implemented

## DSL Example

```ruby
# A very simple, not-real-world example

# Create two mixins, which can provide `number` to a task
mixin 'a' do
    before do
        provide number: 5
    end
end

mixin 'b' do
    before do
        provide number: 4
    end
end

# Now, create an executable task which uses those provided values
task 'example', mixins: ['a', 'b'] do
    puts mixins['a'].number * mixins['b'].number # => 20
end
```

## Use Case

Faith should make a great starting point for building your own bespoke testing
framework, or if you feel like you're outgrowing Rake.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faith'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install faith

## Name

Named after [Faith Connors](https://en.wikipedia.org/wiki/Faith_Connors), a
**runner** from the _Mirror's Edge_ video games.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronC81/faith.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
