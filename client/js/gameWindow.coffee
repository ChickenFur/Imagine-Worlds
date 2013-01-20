cellWidth = 10
cellHeight = 10
delay = 100
toSingleArray = (twoDArray) ->
  newArray = []
  for n, x in twoDArray
    for k, y in n
      newArray.push({x: x, y: y, lifeForm: twoDArray[x][y].lifeForm})
  newArray

Template.gameWindow.rendered = (template) ->
  currentGame = GameRooms.findOne(Session.get("GameStatus").gameId)
  grid = currentGame.gameData.MapGrid.tiles
  singleArray = toSingleArray(grid)
  width = 500
  height = 500

  xs = d3.scale.linear().domain([0, width]).range([0, width * cellWidth])
  ys = d3.scale.linear().domain([0, height]).range([0, height * cellHeight])
  vis = d3.select('#map_container')
    .append("svg:svg")
    .attr("class", "vis")
    .attr("width", 500)
    .attr("heigth", 500)
  vis.selectAll("rect")
    .data(singleArray)
    .enter().append("svg:rect")
    .attr("stroke", "none")
    .attr("fill", (d) -> 
      if d.lifeForm
        return "green" 
      else
        return "white")
    .attr("x", (d) -> xs(d.x))
    .attr("y", (d) -> ys(d.y))
    .attr("width", cellWidth)
    .attr("height", cellHeight)
  return
Template.gameWindow.events({
  'click .endGame' : (event, template) ->
    gameUserFunctions.leaveGame(this.userId, Session.get("GameStatus").gameId )
    Session.set("GameStatus", "")
  })