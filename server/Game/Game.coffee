makeGame = (size) ->
  Game = {
    MapGrid : new makeMapGrid(size)
    Age : 0
    tick : () ->
      @MapGrid.traverseTakeAction()
    tock : () ->
      @MapGrid.tiles = @MapGrid.traverseUpdate()
  }
