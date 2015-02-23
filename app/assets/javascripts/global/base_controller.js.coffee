class @BaseController extends Base

  constructor: (args) ->
    @params = _.last args
    @initialize?.apply(@, args)
