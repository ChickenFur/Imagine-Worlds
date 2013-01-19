Template.stats.gamesPlayed = ->
  History.find({}).count()
Template.stats.gamesRunning = ->
  GameRooms.find({}).count()
Template.stats.onlineUsers = ->
  OnlineUsers.find({}).count()