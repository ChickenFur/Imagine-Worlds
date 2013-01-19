leaveGame = (userId, gameId) ->
  currentGame = GameRooms.findOne(gameId)
  location = currentGame.players.indexOf(this.userId)
  if currentGame.playerCount is 1
    GameRooms.remove({})
  else
    currentGame.players.splice(location, 1) 
    currentGame.playerCount--
    GameRooms.update(gameId,
      $set:
        playerCount : currentGame.playerCount
        players : currentGame.players
    )