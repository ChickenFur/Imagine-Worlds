TerrainTypes = ["Grass", "Plains", "Hills", "Mountain", "Desert", "Water", "Ocean"]
ResourceTypes = ["Forest", "Rock"]

makeTerrain = (xLoc, yLoc) ->
  TerrainObject = {
    X : xLoc
    Y : yLoc
    type : TerrainTypes[ Math.floor ( Math.random() * (TerrainTypes.length-1) ) ]
  }
