@Route =

  routes: []

  map: (pattern, controller) ->
    if _.isObject pattern
      controller = pattern
      pattern = pattern.path

    unless pattern?
      console.error 'No pattern of path for controller:', controller
      return

    @routes.push
      pattern:    new URLPattern(pattern)
      controller: controller

  find: (url) ->
    for route in @routes
      if route.pattern.match url
        return route
    return null

  start: (url) ->
    route = @find(url)
    if route and route.controller
      new route.controller route.pattern.params(url)

  getCurrentPath: ->
    decodeURI(window.location.pathname + window.location.search)

  startCurrent: ->
    @start @getCurrentPath()
