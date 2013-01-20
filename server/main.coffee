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
    console.log("Server ReStarted")
    #code to run on server at startup
  #Checks user HeartBeat  
  Meteor.setInterval () ->
    now = new Date() 
    ONE_MINUTE = 60 * 1000 #in ms 
    OnlineUsers.find().fetch().forEach (user) ->
      if( (now - user.lastActivity) > ONE_MINUTE )
        OnlineUsers.remove(user._id)
    return
  ,2000
  #Increments the Games Running
  Meteor.setInterval () ->
    runningGames = GameRooms.find({state: "launched"}).fetch()
    for n, i in runningGames
      n.gameData.MapGrid.tiles = MapMethods.newGeneration(n.gameData.MapGrid.tiles)
      console.log(n.gameData.Age) 
      GameRooms.update(n._id, 
        $set : 
          gameData  :
            Age     : n.gameData.Age+1
            MapGrid : 
              tiles : n.gameData.MapGrid.tiles )
      console.log("Updated DB")
      return
  ,1000
  #Delete Games if the users are no longer in them every few minutes
  Meteor.setInterval () ->
    runningGames = GameRooms.find({state: "launched"}).fetch()
    for game in runningGames 
      for player in game.players
        user = OnlineUsers.findOne({userId : player})
        if(user.gameId is game._id)
          console.log("Were Good, the user is still in")
        else
          console.log("User must be in a different game or not in a game")  
          location = game.players.indexOf(this.userId)
          if game.playerCount is 1
            History.insert({gamePlayed: new Date()})
            GameRooms.remove(game._id)
          else
            game.players.splice(location, 1) 
            game.playerCount--
            GameRooms.update(game._id,
              $set:
                playerCount : game.playerCount
                players : game.players
            )
  ,1000
