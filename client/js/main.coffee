Meteor.subscribe('onlineUsers')
Meteor.subscribe('gameRooms')

Template.master.launchingGame = ->
   Session.get("GameStatus")

Template.master.inGame = ->
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
 ,10000


  # OnlineUsers.find({'active' : true, 'lastActivity': {lt: now -30 + 1000}}).forEach (onlineActivity) ->
  #   if onlineActivity && onlineActivity.userId
  #     OnlineUsers.update({userId:onlineActivity.userId},{$set: {'active': false}})
  #     Meteor.users.update(onlineActivity.userId,{$set: {'profile.online': false}})

#Meteor.users.update({_id: Meteor.userId()}, {$set : {profile.online : true}})