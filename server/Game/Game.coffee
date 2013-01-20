makeGame = (size) ->
  Game = {
    MapGrid : new makeMapGrid(size)
    Age : 0
    Tick : () ->
      @MapGrid.traverseTakeAction()
    Tock : () ->
      @MapGrid.traverseUpdate()
  }
