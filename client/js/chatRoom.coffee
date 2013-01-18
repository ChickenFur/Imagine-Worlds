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
    return false
  else
    return true
Template.chatRoom.users = () ->
  if(Session.get("GameStatus"))
    return OnlineUsers.find({gameId: Session.get("GameStatus").gameId})
  else
    return OnlineUsers.find({gameId:"MainLobby"}).fetch()

Template.chatRoom.messages = () ->
  if(Session.get("GameStatus"))
    Messages.find({messageRoom:Session.get("GameStatus").gameId}, 
      {messageUserName: 1,messageText: 1,messageTime: 1}).fetch()
  else
    Messages.find({roomName:"MainLobby"}, 
      {messageUserName: 1,messageText: 1,messageTime: 1}).fetch()

Template.chatRoom.events({
  'click #createGame' : (event, template) ->
    title = template.find(".newGameName").value
    if(title.length)
      gameId = GameRooms.insert
                owner: this.userId
                title: title
                state: "chatRoom"
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

  'click .leaveGame' : (event, template)->
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
    console.log ("Enter key clicked")
    if event.which is 13 
      $(template.find('#sendChat')).click() 
  })

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
    console.log("selected" + this._id)
  })