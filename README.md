# Setsy

Settings for your classes. Depends on ActiveRecord, ActiveModel, and ActiveSupport 5.1 (okay so Rails 5.1+), but a PR can take care of this easily!

## Note

This is not very tidy as it is. But it's battle-tested.

## You want this if...

You want this if you don't want to have a zillion columns per model to manage your settings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'setsy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install setsy

## Usage

First, create a migration for a JSONB column. Call it `settings_data`, or something. Just don't call it `settings` if you want to be able to call `settings` on an instance. Default of `{}`

In `app/models/user.rb`:

```ruby
class User < ApplicationRecord
  
  include ::Setsy::DSL
  
  # each setting can be a hash, like posts_limit, or just
  DEFAULT_SETTINGS = {
    posts_limit: { value: 10 },
    favorite_color: 'blue'
  }.freeze

  # do some stuff.
  # setsy <attribute_name>, <options>, <block of readers>
  setsy :settings, column: :settings_data, defaults: DEFAULT_SETTINGS do |conf|
    conf.reader :posts_limit_and_color do
      "posts limit is #{posts_limit} and color is #{favorite_color}"
    end
  end
end
```

These attributes will become available on `User#settings`, and will be backed by the `settings_data` column which you created as a JSONB column.

Then in your controller or view or something,

```erb 
<% @user = User.first %>
<% if @user.settings.posts_limit.default? %>
Posts limit is default. 
<% else %>
Posts limit is <%= @user.settings.posts_limit %> 
<% end %>
<%= @user.settings.posts_limit_and_color %> 
```

## Testing

See `spec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshmn/setsy.
