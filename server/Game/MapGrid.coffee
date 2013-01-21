makeMapGrid = (size) ->
  aGrid = [[]]
  for n in [0...size]
    aGrid[n] = []
    for i in [0...size]
      aGrid[n][i] = new makeTerrain(n, i)

  MapGrid = {
    tiles : aGrid    
  }       
  return MapGrid

calculateNewOwner = (array) ->
  results = {}
  newOwner = "none"
  currentHigh = 0
  debugger
  for n in array
    if n isnt "none"
      if results[n]
        results[n]+=1
        # console.log(results[n] +  " of " + n)
      else
        results[n] = 1
  # console.log("The Results are: " + Object.keys(results) )
  # console.log(results)
  for own key, value of results
    # console.log("This is never run")
    if (currentHigh < value)
      newOwner = key
  return newOwner

checkForNeighbors = (tiles, x, y) ->
  playerOwners = []
  size = tiles.length
  above = if y-1 < 0 then size - 1 else y-1 
  right = if x+1 is size then 0 else x+1
  below = if y+1 is size then 0 else y+1
  left  = if x-1 < 0 then size-1 else x-1
  liveNeighbors = 0
  liveNeighbors += if tiles[left][above].lifeForm then 1 else 0
  playerOwners.push(tiles[left][above].playerOwner)
  liveNeighbors += if tiles[x][above].lifeForm then 1 else 0
  playerOwners.push(tiles[x][above].playerOwner)
  liveNeighbors += if tiles[right][above].lifeForm then 1 else 0
  playerOwners.push(tiles[right][above].playerOwner)
  liveNeighbors += if tiles[left][y].lifeForm then 1 else 0
  playerOwners.push(tiles[left][y].playerOwner)
  liveNeighbors += if tiles[right][y].lifeForm then 1 else 0
  playerOwners.push(tiles[right][y].playerOwner)
  liveNeighbors += if tiles[left][below].lifeForm then 1 else 0
  playerOwners.push(tiles[left][below].playerOwner)
  liveNeighbors += if tiles[x][below].lifeForm then 1 else 0
  playerOwners.push(tiles[x][below].playerOwner)
  liveNeighbors += if tiles[right][below].lifeForm then 1 else 0  
  playerOwners.push(tiles[right][below].playerOwner)

  return {liveNeighbors: liveNeighbors, newOwner :  calculateNewOwner(playerOwners)}


MapMethods = {
  newGeneration : (tiles) ->
    console.log("Creating New Generation")
    nextGen = []
    size = tiles.length
    for n, x in tiles
      nextGen[x] = []
      for n, y in tiles[x] 
        lifeForm = tiles[x][y].lifeForm

        neighborResults = checkForNeighbors(tiles, x, y)
        liveNeighbors = neighborResults.liveNeighbors
        newOwner = neighborResults.newOwner
        # console.log("New Owner is: "+ newOwner)
        newLifeForm = false

        if lifeForm
          newLifeForm = if (liveNeighbors is 2) or (liveNeighbors is 3) then true else false
        else
          newLifeForm = if liveNeighbors is 3 then true else false        
        nextGen[x][y] = {
          x : tiles[x][y].x
          y : tiles[x][y].y
          lifeForm : newLifeForm
          type : tiles[x][y].type
          playerOwner : if newLifeForm then newOwner else "none"
          }  
    return nextGen
}