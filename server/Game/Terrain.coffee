INNER_SQUARE_SIZE = 5
RANDOMNESS_OF_FOOD = 18 # Greater the number the less food 
RANDOMNESS_OF_LIFE = 5 # Greater the number the less life 

TerrainTypes = ["Grass", "Plains", "Hills", "Mountain", "Desert", "Water", "Ocean"]
ResourceTypes = ["Forest", "Rock"]

makeTerrain = (xLoc, yLoc) ->
  food = false
  lifeForm = false
  owner = "none"
  if Math.floor(Math.random() * RANDOMNESS_OF_FOOD) is 1
    food = true
  if Math.floor(Math.random() * RANDOMNESS_OF_LIFE) is 1
    lifeForm = true

  TerrainObject = 
    x : xLoc
    y : yLoc
    type : TerrainTypes[ Math.floor ( Math.random() * (TerrainTypes.length-1) ) ]
    food : food 
    lifeForm : lifeForm
    playerOwner : owner
