makeMapGrid = (size) ->
  aGrid = [[]]
  for n in [0...size]
    aGrid[n] = []
    for i in [0...size]
      aGrid[n][i] = new makeTerrain(n, i)

  MapGrid = {
    tiles : aGrid    
    traverseTakeAction : () ->
      console.log("traverse Of Game Done") 
    traversUpdate : () ->
      console.log("traverse Update Done")
  }
  return MapGrid
