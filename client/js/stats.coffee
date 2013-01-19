Template.stats.totalUsers = ->
  Meteor.users.find().count()
Template.stats.gamesPlayed = ->
  History.find({}).count()
Template.stats.gamesRunning = ->
  GameRooms.find({}).count()