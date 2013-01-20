makeGame = (size) ->
  Game = {
    MapGrid : new makeMapGrid(size)
    Age : 0
  }

assignColors = (playerArray) ->
  for player in playerArray
    player.color = generateRandomColor()
  playerArray


generateRandomColor = () ->
  return "red"
