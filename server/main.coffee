if (Meteor.isServer) 
  Meteor.startup () -> 
    console.log("Server Started")
    #code to run on server at startup

  Meteor.setInterval ->
    now = new Date() 
    ONE_MINUTE = 60 * 1000 #in ms 
    OnlineUsers.find().fetch().forEach (user) ->
      if( (now - user.lastActivity) > ONE_MINUTE )
        OnlineUsers.remove(user._id)
# Meteor.setInterval ->
#   now = new Date()
#   OnlineUsers.update({lastActivity: > 1 } {$set {active: false}})
#   ,10000