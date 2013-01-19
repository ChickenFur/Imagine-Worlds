makeGame = (size) ->
  Game = {
    MapGrid : new makeMapGrid(size)
    Age : 0
    Tick : () ->
      @MapGrid.traverseTakeAction()
    Tock : () ->
      @MapGrid.traverseUpdate()
  }

makeMapGrid = (size) ->
  aGrid = [[]]
  for n in size
    for i in size
      aGrid[n][i] = new makeTerrain(n, i)

  MapGrid = {
    tiles : aGrid    
    traverseTakeAction : () ->
      console.log("traverse Of Game Done") 
    traversUpdate : () ->
      console.log("traverse Update Done")
  }
  return MapGrid

TerrainTypes = ["Grass", "Plains", "Hills", "Mountain", "Desert", "Water", "Ocean"]
ResourceTypes = ["Forest", "Rock"]

makeTerrain = (xLoc, yLoc) ->
  TerrainObject = {
    X : xLoc
    Y : yLoc
    type : TerrainTypes[ Math.floor ( Math.random * (TerrainTypes.length -1) ) ]
  }
