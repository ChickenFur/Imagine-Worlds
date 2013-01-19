Template.gameWindow.events({
  'click .endGame' : (event, template) ->
    leaveGame(this.userId, Session.get("GameStatus").gameId )
    Session.set("GameStatus", "")
  })