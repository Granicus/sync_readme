# SyncReadme

`sync_readme` is a gem designed to help you synchronize a readme between a repository and a confluence wiki page. The idea is that on merge to master, you can run the sync to take docs FROM the readme and put them in the confluence page.

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
default: readme                     # optional if not set, default runs all configurations

readme:
  url: http://confluence.url.here   # required
  page_id: 123456                   # required
  filename: Readme.md               # required
  username: foo                     # optional, generally better as an environment variable
  password: bar                     # optional, generally better as an environment variable
  notice: this file is sync'd!      # optional, adds the notice (as html) to the top of the confluance docs
  strip_title: false                # optional, defaults false, strips the first h1 (#) tag from the file
  syntax_highlighting: true         # optional, defaults true, uses coderay syntax highlighting on code blocks
```

You'll also need to set environment variables with credentials to update the page in question:

The Atlassian Cloud supports [API tokens](https://confluence.atlassian.com/cloud/api-tokens-938839638.html), which can be used for `CONFLUENCE_PASSWORD`

```
CONFLUENCE_USERNAME=jsmith
CONFLUENCE_PASSWORD=$UPER $ECURE PA$$WORD
```

## Usage
```
sync_readme [configuration]
```

## Adding to Gitlab-CI

1. Create a confluence user specifically to sync with
2. If you haven't already, create the pages you want to sync to on confluence and get their IDs.
3. Create your `.sync_readme.yml` file like the one above (or see the example)
4. Add `gem 'sync_readme'` to your apps gemfile
5. Set `CONFLUENCE_USERNAME` and `CONFLUENCE_PASSWORD` as CI Variables.
6. Add the following job to your .gitlab-ci.yml
   ``` yaml
   Sync To Confluence:
     stage: update_docs                # Replace that with the stage you want this to run
     only: master                      # Only run on master branch probably after you deploy
     script:
       - bundle exec sync_readme --all # Alternately just the profile you want to run
    ```

## Development

Set up a copy of ruby 2.3.1 (We suggest rbenv)

`bundle install`

## Running Tests

`bundle exec rspec`

## Contributing

Contributions are welcome as long as they contain tests for the behaviors added or changed.

## License

The gem is available as open source under the terms of the [BSD-3-Clause](http://opensource.org/licenses/BSD-3-Clause).
