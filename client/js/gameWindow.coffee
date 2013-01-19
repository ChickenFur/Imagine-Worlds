Template.gameWindow.events({
  'click .endGame' : (event, template) ->
    gameUserFunctions.leaveGame(this.userId, Session.get("GameStatus").gameId )
    Session.set("GameStatus", "")
  })