keywords = ['extended', 'included']

class @Base
  @extend: (obj) ->
    for key, value of obj when key not in keywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in keywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this
