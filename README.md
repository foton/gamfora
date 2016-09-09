# --- Work in progress! ---

# Gamfora - Gamification for anyone/anything
Rails engine in form of gem for including gamification into your Rails app.
Game admin creates game(s), add metrics, actions, players and teams to them. Than any player can play an action and get rewards to his/her scores.
And of course any player can display leaderboards for any metric (for players or teams). 

## Usage
Typical usage will be
- instal gem
- add `config/initializers/gamfora.rb` with content
```ruby
Gamfora.game_owner_class = "User"
Gamfora.game_owner_name_attribute = "username"
Gamfora.player_class = "User"
Gamfora.player_name_attribute = "name"
```
- use 
```ruby
game=Gamfora::Game.find_by_name("my_game")
game.play_action(:issue_commented, current_user)
game.player_for(current_user).scores
game.player_leaderboards.find(:tolar_metrics)
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'gamfora'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install gamfora
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
