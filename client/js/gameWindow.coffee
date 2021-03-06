cellWidth = 30  
cellHeight = 30
NUM_OF_CLICKS_TO_GAME_SIZE = 3
numOfClicks = 5

toSingleArray = (twoDArray) ->
  newArray = []
  for n, x in twoDArray
    for k, y in n
      newArray.push(
        x: x
        y: y 
        lifeForm: twoDArray[x][y].lifeForm
        playerOwner: twoDArray[x][y].playerOwner
      )
  newArray

getCurrentScore = (tiles, userId) ->
  score = 0
  for n in tiles
    for k in n
      if(k.playerOwner is userId)
        score+=1
  score
fillGridSquare = (self, d, currentGame, currentUserId) ->
  d3.select(self).style("fill", currentGame.playerColorArray[currentGame.players.indexOf(currentUserId)]);
  cell = currentGame.gameData.MapGrid.tiles[d.x][d.y]
  cell.lifeForm = true
  cell.playerOwner = currentUserId
  currentGame.gameData.MapGrid.tiles[d.x][d.y] = cell
  GameRooms.update(currentGame._id, 
  $set : 
    gameData  :
      Age     : currentGame.gameData.Age+1
      MapGrid : 
        tiles : currentGame.gameData.MapGrid.tiles )

Template.gameWindow.clicks = ->
  if( Session.get("clicks") >= 0)
    return Session.get("clicks")
  else
    return numOfClicks

Template.gameWindow.age = () ->
  currentGame = GameRooms.findOne(Session.get("GameStatus").gameId)
  currentGame.gameData.Age if currentGame.gameData

Template.gameWindow.names = () ->
  currentGame = GameRooms.findOne(Session.get("GameStatus").gameId)
  currentPlayers = OnlineUsers.find({gameId: Session.get("GameStatus").gameId}).fetch()
  names = []
  if currentPlayers
    if currentGame.playerColorArray
      for n in currentPlayers 
        currentColor = currentGame.playerColorArray[currentGame.players.indexOf(n.userId)];
        currentScore = getCurrentScore(currentGame.gameData.MapGrid.tiles, n.userId)
        names.push({ name : n.name, color : currentColor, score: currentScore })
  names

Template.gameWindow.playerColors = () ->
  currentGame = GameRooms.findOne(Session.get("GameStatus").gameId)
  currentGame.playerColorArray if currentGame.playerColorArray

Template.gameWindow.rendered = (template) ->
  currentGame = GameRooms.findOne(Session.get("GameStatus").gameId)
  currentUserId = Meteor.userId();
  grid = currentGame.gameData.MapGrid.tiles
  singleArray = toSingleArray(grid)
  width = grid.length * cellWidth
  height = grid.length * cellHeight
  $('#map_container').css("width", width)
  $('#map_container').css("height", height)
  xs = d3.scale.linear().domain([0, width]).range([0, width * cellWidth])
  ys = d3.scale.linear().domain([0, height]).range([0, height * cellHeight])

  vis = d3.select('#map_container')
    .append("svg:svg")
    .attr("class", "vis")
    .attr("width", width)
    .attr("height", height)

  vis.selectAll("rect")
    .data(singleArray)
    .enter().append("svg:rect")
    .attr("stroke", "none")
    .attr("fill", (d) -> 
      if d.lifeForm 
        if d.playerOwner is "none"
          return "green"
        else
          color = currentGame.playerColorArray[currentGame.players.indexOf(d.playerOwner)]
          return color 
      else 
        return "white")
    .attr("x", (d) -> xs(d.x))
    .attr("y", (d) -> ys(d.y))
    .attr("width", cellWidth)
    .attr("height", cellHeight)
    .on('click', (d, i) ->
      if(!d.lifeForm)
        clicksLeft = Session.get "clicks"
        if clicksLeft
          if clicksLeft > 0
            fillGridSquare(this, d, currentGame, currentUserId)
            Session.set("clicks", clicksLeft-1)
        else if clicksLeft is undefined
          numOfClicks = Math.floor(grid.length / NUM_OF_CLICKS_TO_GAME_SIZE
          Session.set("clicks", numOfClicks))
          fillGridSquare(this, d, currentGame, currentUserId)

      return
    )
  return

Template.gameWindow.events({
  'click .endGame' : (event, template) ->
    Session.set("GameStatus", "")
    Session.set("clicks", undefined)
  })