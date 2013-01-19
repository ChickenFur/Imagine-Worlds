if (Meteor.isServer) 
  Meteor.publish "onlineUsersByGame", (gameId) ->
    self = this
    uuid = Meteor.uuid();
  
    handle = OnlineUsers.find({gameId:gameId}).observe(
      added : (doc, idx) ->
        self.set("currentUsers", uuid, {name: name, gameId: gameId})
        self.flush()
      removed : (doc, idx) ->
        self.set("currentUsers", uuid {name: name, gameId: gameId})
        self.flush()
      )
    self.complete()
    self.flush()
    self.onStop () ->
      handle.stop()
    

  Meteor.publish "gameRooms", () ->
    return GameRooms.find({})

  Meteor.publish "history", () ->
    return History.find({})

  Meteor.publish "messages", () ->
    return Message.find({})

  Meteor.startup () -> 
    console.log("Server Started")
    #code to run on server at startup

  Meteor.setInterval ->
    now = new Date() 
    ONE_MINUTE = 60 * 1000 #in ms 
    OnlineUsers.find().fetch().forEach (user) ->
      if( (now - user.lastActivity) > ONE_MINUTE )
        OnlineUsers.remove(user._id)
    ,1000
