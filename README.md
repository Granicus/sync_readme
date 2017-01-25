# SyncReadme

sync_readme is a gem designed to help you synchronize a readme between a repository and a confluence wiki page. The idea is that on merge to master, you can run the sync to take docs FROM the readme and put them in the confluence page.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'sync_readme'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sync_readme

Then set up a .sync_readme.yml file

``` yaml
default:
  url: http://confluence.url.here
  page_id: 123456
  filename: Readme.md
```

You'll also need to set environement variables with credentials to update the page in question:

```
CONFLUENCE_USERNAME=jsmith
CONFLUENCE_PASSWORD=$UPER $ECURE PA$$WORD
```

## Usage
```
sync_readme [configuration]
```

## Adding to Gitlab-CI

1. If you haven't already, create the pages you want to sync to on confluence and get their ids.
2. Create your `.sync_readme.yml` file like the one above (or see the example)
3. Add `gem 'sync_readme'` to your apps gemfile
4. Add the following job to your .gitlab-ci.yml

``` yaml
Sync To Confluence:
  stage: update_docs # Replace that with the stage you want this to run, or make a new stage for it
  only: master # In general you only want to run this on your master branch probably after you deploy
  script:
    - bundle exec sync_readme --all # Alternately just the profile you want to run
```

## Development

Set up a copy of ruby 2.3.1 (We suggest rbenv)

`bundle install`

## Running Tests

`bundle exec rspec`

## Contributing

Contributions are welcome as long as they contain tests for the behaviours added or changed.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
