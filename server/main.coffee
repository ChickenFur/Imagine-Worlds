if (Meteor.isServer) 

  Meteor.publish "onlineUsers", () ->
    OnlineUsers.find({}) 

  Meteor.publish "gameRooms", () ->
    GameRooms.find({})

  Meteor.publish "history", () ->
    History.find({})

  Meteor.publish "messages", () ->
    Messages.find({})

  Meteor.startup () -> 
    console.log("Server Started")
    #code to run on server at startup

  Meteor.setInterval () ->
    now = new Date() 
    ONE_MINUTE = 60 * 1000 #in ms 
    OnlineUsers.find().fetch().forEach (user) ->
      if( (now - user.lastActivity) > ONE_MINUTE )
        OnlineUsers.remove(user._id)
    runningGames = GameRooms.find({state: "launched"}).fetch()
    for n, i in runningGames
      n.gameData.MapGrid.tiles = MapMethods.newGeneration(n.gameData.MapGrid.tiles)
      console.log( n.gameData.MapGrid.tiles)
      GameRooms.update(n._id, {$set : {MapGrid : n.gameData.MapGrid} })
    return

  ,1000


