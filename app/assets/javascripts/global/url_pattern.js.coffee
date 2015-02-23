class @URLPattern

  _parser:    Backbone.Router::_routeToRegExp
  _extractor: Backbone.Router::_extractParameters

  constructor: (pattern) ->
    @regexp = @_parser(pattern)

  match: (path) ->
    @regexp.test path

  params: (path) ->
    params = @_extractor @regexp, path
    last = params.length - 1
    if params[last]
      params[last] = $.deparam(params[last])
    params
