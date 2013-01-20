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
    traverseUpdate : () ->
      nextGen = []
      for n, x in @tiles
        nextGen[x] = []
        for n, y in @tiles[x] 
          above = y - 1 < 0 ? @tiles.length -1 : y - 1
          right = x + 1 is @tiles.length ? 0 : x - 1
          below = y + 1 is @tiles.length ? 0 : y + 1
          left  = x - 1 < 0 ? @tiles.length ? @tiles.length - 1 : x - 1

          lifeForm = @tiles[x][y].lifeForm
          liveNeighbors = 0
          liveNeighbors += @tiles[left][above] ? 1 : 0
          liveNeighbors += @tiles[x][above] ? 1 : 0
          liveNeighbors += @tiles[right][above] ? 1 : 0
          liveNeighbors += @tiles[left][y] ? 1 : 0
          liveNeighbors += @tiles[right][y] ? 1 : 0
          liveNeighbors += @tiles[left][below] ? 1 : 0
          liveNeighbors += @tiles[x][below] ? 1 : 0
          liveNeighbors += @tiles[right][below] ? 1 : 0
          newLifeForm = false
          if lifeForm
            newLifeForm = (liveNeighbours is 2) or (liveNeighbours is 3) ? true : false
          else
            newLifeForm = liveNeighbours is 3 ? true : false          
          nextGen[x][y] = newLifeForm  
  }       
  return MapGrid
