if (Meteor.isServer) 
  Meteor.startup () -> 
    console.log("Server Started")
    #code to run on server at startup

# Meteor.setInterval ->
#   now = new Date()
#   OnlineUsers.update({lastActivity: > 1 } {$set {active: false}})
#   ,10000