Meteor.subscribe('onlineUsersByGame')
CurrentUsers = new Meteor.Collection("currentUsers")

Meteor.autosubscribe () ->
  Meteor.subscribe("onlineUsersByGame", Session.get("GameStatus").gameId)

Template.master.launchingGame = ->
   Session.get("GameStatus")

Template.master.inGame = ->
  if Session.get("GameStatus")
    if GameRooms.findOne(Session.get("GameStatus").gameId).state is "launched"
      return true
  return false

Meteor.setInterval ->
  if(Meteor.userId)
    now = (new Date()).getTime()
    gameId = "MainLobby"
    if(Session.get("GameStatus"))
      gameId = Session.get("GameStatus").gameId

    if( OnlineUsers.findOne({userId: Meteor.userId()}) )
      OnlineUsers.update({ userId: Meteor.userId()},
        $set :
          active: true
          lastActivity: now
          gameId: gameId    
      )
    else
      OnlineUsers.insert(
        userId: Meteor.userId()
        name: Meteor.user().profile.name
        active: true
        lastActivity: now
        gameId: gameId 
      )
 ,1000
