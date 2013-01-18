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
      Meteor.call('createGame', {title:title})
      template.find(".newGameName").value = "" 
      Session.set("GameStatus", {inGame: true, status: "chatRoom", name: title})
    else
      console.log("Needs a title")

  'click .leaveGame' : (event, template)->
    Session.set("GameStatus", "")
    Meteor.call('closeGame')
  })