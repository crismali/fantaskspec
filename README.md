Fantaskspec
===========
Makes it easy to test your Rake tasks with RSpec.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "fantaskspec"
```

And then execute:

    $ bundle

Then whereever you're configuring RSpec (`spec_helper`, `rails_helper`, whatever):

```ruby
RSpec.configure do |config|
  # ...
  config.infer_rake_task_specs_from_file_location!
  # ...
end
```
That will make it so that specs in `spec/lib/tasks` and `spec/tasks` will automatically have a type
of `:rake` (unless you override it).

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

RSpec.describe "some_task" do
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
Here `subject` and `task` are both our Rake task called `some_task`. Fantaskspec gives
us a handy `depend_on` matcher so we can ensure are dependencies are correct.

Here we're assuming we've called `config.infer_rake_task_specs_from_file_location!` in our
`RSpec.configure` block so we don't need to specify `type: :rake` in any of our example groups
as long as the test is located at `spec/tasks` or `spec/lib/tasks`.

We also have access to `task_name`, which is just the Fantaskspec's best guess at the name of the task
we're specifying is, based on the description string we pass to `describe` or `context`.

Rake testing gotchas
--------------------
There are 2 ways to get your Rake task's code to execute: by calling either `execute` or `invoke` on the task (or subject).
`execute` will execute the Rake task but none of its dependencies. `invoke` will execute the task and dependencies, but
the task and its dependencies will be disabled unless you call `reenable` on all of them. If you stick with `execute you
probaly won't have any problems.

Contributing
------------

1. [Fork it](https://github.com/crismali/fantaskspec/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
