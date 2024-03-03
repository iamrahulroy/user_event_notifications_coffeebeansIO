# README

## Instructions
```
# cd into project folder
bundle install
rails db:migrate

# make sure nothing's running on port 3000, else use -p option to specify port
rails server
# open http://localhost:3000/
```


## Notes
* Tests are done in hurry because I wanted to save time.
* Sidekiq and Workers aren't used to save time.
