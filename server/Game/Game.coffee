makeGame = (size) ->
  Game = {
    MapGrid : new makeMapGrid(size)
    Age : 0
  }

assignColors = (playerArray) ->
  randomColorOptions = ["red", "blue", "orange", "gray", "pink", "tan" ]
  colorArray = [];
  for player in playerArray
    color = Math.floor(Math.random() * (randomColorOptions.length-1) )
    colorArray.push(randomColorOptions[color])
    randomColorOptions.splice(color, 1)
  return colorArray



  
  
