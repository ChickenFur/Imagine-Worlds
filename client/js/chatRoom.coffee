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

Template.chatRoom.events({
  'click #createGame' : (event, template) ->
    title = template.find(".newGameName").value
    if(title.length)
      gameId = Meteor.call('createGame', {title:title})
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