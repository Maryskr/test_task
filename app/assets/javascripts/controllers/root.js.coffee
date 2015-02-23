class MainView extends Backbone.View
  el: '#TestTaskView'

  initialize: ->
    console.log 'works'




class Root extends BaseController
  @path: '(/)'

  initialize:->
    console.log gon.current_resource
    # new MainView(gon.current_resource)

Route.map Root