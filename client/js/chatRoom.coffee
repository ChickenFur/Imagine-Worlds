SCROLL_BOTTOM_POSITION = 800
NUM_MESSAGES_TO_DISPLAY = 50

Template.chatRoom.rendered = () ->
  $(this.find('.messagesText')).scrollTop(SCROLL_BOTTOM_POSITION)
Template.chatRoom.roomName = () ->
  if(Session.get("GameStatus"))
    return Session.get("GameStatus").name
  else
    return "Main Lobby"
Template.chatRoom.gameList = () ->
  return GameRooms.find(
    {state:'chatRoom'}, 
    {title: 1}).fetch()

Template.chatRoom.gameRoom = () ->
  if(Session.get("GameStatus"))
    if Session.get("GameStatus").gameId
      if GameRooms.findOne( Session.get("GameStatus").gameId )
        return true
      else
        Session.set("GameStatus", "")
  else
    return false

Template.userList.users = () ->
  if(Session.get("GameStatus"))
    return OnlineUsers.find({gameId: Session.get("GameStatus").gameId})
  else
    return OnlineUsers.find({gameId:"MainLobby"}).fetch()

Template.chatRoom.messages = () ->
  if(Session.get("GameStatus"))
    Messages.find({messageRoom:Session.get("GameStatus").gameId}, 
      {messageUserName: 1,messageText: 1,messageTime: 1}).fetch()
  else
    totalMessages = Messages.find({roomName:"MainLobby"}).count()
    numberToNotDisplay = totalMessages - NUM_MESSAGES_TO_DISPLAY
    Messages.find( {roomName:"MainLobby"},
    messageUserName: 1
    messageText: 1
    messageTime: 1
    skip: numberToNotDisplay ).fetch()

Template.chatRoom.events({
  'click #createGame' : (event, template) ->
    title = template.find(".newGameName").value
    if(title.length)
      gameId = GameRooms.insert
                owner: this.userId
                title: title
                state: "chatRoom"
                players: [this.userId]
                playerCount : 1
      template.find(".newGameName").value = "" 
      Session.set("GameStatus", {inGame: true, status: "chatRoom", name: title, gameId: gameId})
    else
      console.log("Needs a title")

  'click #joinGame' : (event, template) ->
    if(Session.get("selectedGame"))
      Session.set("GameStatus", 
        {inGame: true
        status: "chatRoom"
        name: GameRooms.findOne(Session.get("selectedGame")).title 
        gameId: Session.get("selectedGame") } )  
      currentGame = GameRooms.findOne(Session.get("selectedGame"))
      currentGame.players.push(this.userId)
      GameRooms.update(Session.get("selectedGame"), 
        $set:
          playerCount : currentGame.playerCount + 1
          players : currentGame.players
      )  

  'dblclick .gameTitle' : (event, template) ->
    $(template.find('#joinGame')).click()

  'click .leaveGame' : (event, template)->    
    currentStatus = Session.get("GameStatus")
    currentGame = GameRooms.findOne(currentStatus.gameId)
    gameUserFunctions.leaveGame(this.userId, currentGame._id)
    Session.set("GameStatus", "")
    Meteor.call('closeGame')

  'click #sendChat' : (event, template ) ->
    currentStatus = Session.get("GameStatus")
    newMessageText = template.find("#chatMessage").value
    template.find("#chatMessage").value = ""
    if newMessageText
      Messages.insert({messageText: newMessageText,
      messageUserName: Meteor.user().profile.name,
      messageTime : new Date(),
      messageRoom : if currentStatus then currentStatus.gameId else "MainLobby",
      roomName : if currentStatus then currentStatus.name else "MainLobby"
      })

  'keydown #chatMessage' : (event, template) ->
    if event.which is 13 
      $(template.find('#sendChat')).click() 

  'click .launchGame' : (event, template) ->
    gameStatus = Session.get("GameStatus")
    GameRooms.update(gameStatus.gameId, 
      $set :
        state : "launched"
    )
    gameStatus.status = "launched"
    Session.set "GameStatus", gameStatus
  })
Template.gameRoom.ownersGame = ->
  if(Session.get("GameStatus"))
    if( Meteor.userId() is GameRooms.findOne( Session.get("GameStatus").gameId).owner )
      return true
    else
      return false
  else
    return false

Template.game.selected = ->
  console.log("selected")
  if( Session.equals("selectedGame", this._id) ) 
    return "selected"
  else
    return ""
Template.game.events({
  'click .gameTitle' : (event, template) ->
    title = event.target.txt
    Session.set("selectedGame", this._id)
  })