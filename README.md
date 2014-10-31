[![Build Status](https://travis-ci.org/timhabermaas/hairspray-tickets.png?branch=master)](https://travis-ci.org/timhabermaas/hairspray-tickets)
[![Coverage Status](https://coveralls.io/repos/timhabermaas/hairspray-tickets/badge.png?branch=master)](https://coveralls.io/r/timhabermaas/hairspray-tickets?branch=master)
[![Code Climate](https://codeclimate.com/github/timhabermaas/hairspray-tickets.png)](https://codeclimate.com/github/timhabermaas/hairspray-tickets)

#Hairspray Tickets


##How to get it running?

1. Install Ruby (1.9+) and the Bundler gem.
2. Setup the database and populate database with `seeds.rb`:
  `bundle exec rake db:setup`.
3. Start the server by running `bundle exec rake rails s`.

##How to run the tests?

`bundle exec rake`

There are also some Jasmine Specs for the angular client which can be
invoked by going to http://localhost:3000/specs.
