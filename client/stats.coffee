Template.stats.totalUsers = ->
  Meteor.users.find().count()
Template.stats.gamesPlayed = ->
  games.find().count()
Template.stats.gamesRunning = ->
  games.find({running: true}).count()
