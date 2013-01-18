GameRooms = new Meteor.Collection("gameRooms")
OnlineUsers = new Meteor.Collection("onlineUsers")

Meteor.methods({
  createGame: (options) -> 
    console.log("Creating Game Room")
    GameRooms.insert
      owner: this.userId
      title: options.title
      state: "chatRoom"
  getGameName: (options) ->
    return GameRooms.findOne(options._id).title
  
  numOfGames: ->
    theNum = GameRooms.find({}).count()
    console.log(theNum)
    return theNum

  closeGame: () ->
    GameRooms.remove({owner: this.userId})
    console.log("Creator Left Game Room, Closing")

  })