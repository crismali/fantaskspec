Fantaskspec
===========
[![Gem Version](https://badge.fury.io/rb/fantaskspec.svg)](http://badge.fury.io/rb/fantaskspec)
[![Build Status](https://travis-ci.org/crismali/fantaskspec.svg?branch=master)](https://travis-ci.org/crismali/fantaskspec)

Makes it easy to test your Rake tasks with RSpec. [Read this for more.](https://devmynd.com/blog/2015-3-testing-rake-tasks-with-rspec-and-fantaskspec)

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "fantaskspec"
```

And then execute:

    $ bundle install

Then in your `spec_helper` or `rails_helper`:

```ruby
require "fantaskspec"

RSpec.configure do |config|
  # ...
  config.infer_rake_task_specs_from_file_location!
  # ...
end
```
That will make it so that specs in `spec/lib/tasks` and `spec/tasks` will automatically have a type
of `:rake` (unless you override it). If you don't want to use `infer_rake_task_specs_from_file_location!`
you can explicitly set the spec type like so:

```ruby
RSpec.describe "namespace:foo", type: :rake do
  # Lots of lovely specs
end
```

### Loading your Rake tasks
This gem doesn't load your Rake tasks for you, that's something you have to do. If you're using Rails, just
add `Rails.application.load_tasks` to your `rails_helper.rb`. If you're not using Rails, just `require` the files you need.

Usage
-----
Given a task that looks like this:
```ruby
desc "Some rake task"
task some_task: :environment do
  puts "I don't do much."
end
```
We can test it like this:
```ruby
require "spec_helper"

RSpec.describe "namespace:taskname", type: :rake do
  it { is_expected.to depend_on(:environment) }

  it "executes some code" do
    expect(subject.execute).to eq(task.execute)
  end

  context "some sort of context" do
    it "still uses 'some_task' as the name of the task" do
      expect(task_name).to eq("some_task")
      expect(task_name).to eq(subject.name)
    end
  end
end
```
Here `subject` and `task` are both the Rake task `some_task`. Fantaskspec also gives us the handy `depend_on` matcher so we can ensure our dependencies are correct.

If you only care about some of your task's dependencies you can use `depend_on_subset` instead of `depend_on`.

Here we're assuming we've called `config.infer_rake_task_specs_from_file_location!` in our
`RSpec.configure` block so we don't need to specify `type: :rake` in any of our example groups
as long as the test is located at `spec/tasks` or `spec/lib/tasks`.

We also have access to `task_name`, which is just the Fantaskspec's best guess at the name of the task
we're specifying is, based on the description string we pass to `describe` or `context`.

`to_task_arguments`
-------------------
If your task requires arguments, just use the `to_task_arguments` helper.

```
arguments = to_task_arguments("foo", "bar")
task.execute(arguments)
```

Rake testing gotchas
--------------------
There are 2 ways to get your Rake task's code to execute: by calling either `execute` or `invoke` on the task (or subject).
`execute` will execute the Rake task but none of its dependencies. `invoke` will execute the task and dependencies, but
the task and its dependencies will be disabled unless you call `reenable` on all of them. If you stick with `execute you
probaly won't have any problems.

Contributing
------------

1. [Fork it](https://github.com/crismali/fantaskspec/fork)
2. Clone it locally
3. `cd` into the project root
4. `bundle install`
5. `appraisal install`
6. Run the specs with `appraisal rspec`
7. Create your feature branch (`git checkout -b my-new-feature`)
8. Commit your changes (`git commit -am 'Add some feature'`)
9. Push to the branch (`git push origin my-new-feature`)
10. Create a new Pull Request
