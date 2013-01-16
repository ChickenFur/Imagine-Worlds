Template.map.rendered = () ->
  drawMap()

drawMap = () ->
  xy = d3
    .geo
    .equirectangular()
    .scale($('#map_container').width())
    .translate([$('#map_container').width() / 2, $('#map_container').height() / 2])
  path = d3
    .geo
    .path()
    .projection(xy)
  svg = d3
    .select('#map_container')
    .append('svg:svg')
  countries = svg
    .append("svg:g")
    .attr("id", 'countries')
  countries.selectAll('path')
    .data(countries_data.features)
    .enter()
    .append('svg:path')
    .attr('d', path)
    .attr('fill', 'rgba(29,91,85,1)')
    .attr('stroke', 'rgba(29,91,85,1)')
    .attr('stroke-width', 1);