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
    FIVE_MINUTE = 60 * 5000 #in ms 
    OnlineUsers.find().fetch().forEach (user) ->
      if( (now - user.lastActivity) > FIVE_MINUTE )
        OnlineUsers.remove(user._id)
    return
  ,60000

  #Increments the Games Running
  Meteor.setInterval () ->
    runningGames = GameRooms.find({state: "launched"}).fetch()
    console.log("Games Running:" + runningGames.length)
    for n, i in runningGames
      console.log("Game Number:" + i)
      # console.log(n.gameData.MapGrid.tiles)
      n.gameData.MapGrid.tiles = MapMethods.newGeneration(n.gameData.MapGrid.tiles)
      console.log(n.gameData.Age) 
      GameRooms.update(n._id, 
        $set : 
          gameData  :
            Age     : n.gameData.Age+1
            MapGrid : 
              tiles : n.gameData.MapGrid.tiles )
    return
  ,2000

  #Delete Games if the users are no longer in them every 4 seconds
  Meteor.setInterval () ->
    runningGames = GameRooms.find({state: "launched"}).fetch()
    for game in runningGames 
      console.log("Players" + game.players )
      for player in game.players
        user = OnlineUsers.findOne({userId : player})
        console.log(user)
        if( (user is undefined) or (user.gameId isnt game._id))
          console.log("User must be in a different game or not in a game")
          console.log("User is:" + user) 
          console.log("gameid is " + game._id)
          location = game.players.indexOf(player)
          console.log("Id of PLayer Removing " + player)
          console.log("location in array:" + location)
          console.log("Players array" + game.players)
          if(location >= 0)
            if game.playerCount is 1
              History.insert({gamePlayed: new Date()})
              GameRooms.remove(game._id)
              console.log("Game Removed")
            else
              newCount = game.playerCount-1
              game.players.splice(location, 1) 
              game.playerColorArray.splice(location, 1)
              GameRooms.update(game._id,
                $set:
                  playerColorArray : game.playerColorArray
                  playerCount : newCount
                  players : game.players
              )
              console.log("Player Removed")
        else
          console.log("Were Good, the user is still in")
  ,4000

