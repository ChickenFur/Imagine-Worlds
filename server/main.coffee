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
      keys = Object.keys(n.gameData);
      console.log("updating Game" + keys)
      n.gameData.tock()
      GameRooms.update(n._id, {MapGrid : n.gameData.MapGrid})
    return

  ,1000


