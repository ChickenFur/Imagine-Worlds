Meteor.subscribe('onlineUsers')
Meteor.subscribe('gameRooms')

Template.master.launchingGame = ->
   Session.get("GameStatus")

Meteor.setInterval ->
  now = (new Date()).getTime()
  OnlineUsers.find({'active' : true, 'lastActivity': {lt: now -30 + 1000}}).forEach (onlineActivity) ->
    if onlineActivity && onlineActivity.userId
      OnlineUsers.update({userId:onlineActivity.userId},{$set: {'active': false}})
      Meteor.users.update(onlineActivity.userId,{$set: {'profile.online': false}})
 ,1000000



#Meteor.users.update({_id: Meteor.userId()}, {$set : {profile.online : true}})