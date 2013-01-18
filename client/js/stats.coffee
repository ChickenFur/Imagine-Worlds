Template.stats.totalUsers = ->
  Meteor.users.find().count()
Template.stats.gamesPlayed = ->
  GameRooms.find({}).count()
Template.stats.gamesRunning = ->
  GameRooms.find({ state: "running"}).count()