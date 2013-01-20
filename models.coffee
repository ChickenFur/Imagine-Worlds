History = new Meteor.Collection("history")
History.allow({
  insert : (userId, doc) ->
    true
  update : (userId, doc) ->
    true
  remove : (userId, doc) ->
    true
  })
GameRooms = new Meteor.Collection("gameRooms")
GameRooms.allow({
  insert : (userId, doc) ->
    true
  update : (userId, doc) ->
    true
  remove : (userId, doc) ->
    true
  })
OnlineUsers = new Meteor.Collection("onlineUsers")
OnlineUsers.allow({
  insert : (userId, doc) ->
    true
  update : (userId, doc) ->
    true
  remove : (userId, doc) ->
    true
  })
Messages = new Meteor.Collection("messages")
Messages.allow({
  insert : (userId, doc) ->
    true
  update : (userId, doc) ->
    true
  remove : (userId, doc) ->
    true
  })

Meteor.methods({
  createGame: (options) -> 
    console.log("Creating Game Room")
    GameRooms.insert
      owner: this.userId
      title: options.title
      state: "chatRoom"

  launchGame: (options) ->
    newGameData = makeGame(options.gameSize)
    playersWColor = assignColors(GameRooms.findOne(options.gameId).players)
    console.log("newGameData")
    GameRooms.update options.gameId, 
      $set :
        gameData : newGameData
        players : playersWColor
    
  getGameName: (options) ->
    GameRooms.findOne(options._id).title
  
  numOfGames: ->
    theNum = GameRooms.find({}).count()
    console.log(theNum)
    theNum

  closeGame: () ->
    GameRooms.remove({owner: this.userId})
    console.log("Creator Left Game Room, Closing")

  })