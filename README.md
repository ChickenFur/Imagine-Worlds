#Competitive Multiplayer Conway's Game Of Life
---
 Built using Meteor and D3.js.

#How to run:

  ###install meteor:

  $ curl https://install.meteor.com | /bin/sh

  $ git clone git@github.com:ChickenFur/Imagine-Worlds.git

  $ cd imagine-worlds

  $ meteor

  By default meteor runs on port 3000. Open your browser and point to http://localhost:3000 and let the pixel fights begin.

  ###The Rules the life forms follow are:

    Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    Any live cell with two or three live neighbours lives on to the next generation.
    Any live cell with more than three live neighbours dies, as if by overcrowding.
    Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

  Check out the wikipedia page for more indepth information.
  http://en.wikipedia.org/wiki/Conway's_Game_of_Life

###See live:
  http://imagine-worlds.meteor.com
