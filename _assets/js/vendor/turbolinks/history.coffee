pageLoaded = false

addEventListener "load", ->
  Turbolinks.defer ->
    pageLoaded = true
, false

class Turbolinks.History
  constructor: (@delegate) ->

  start: ->
    unless @started
      addEventListener("popstate", @onPopState, false)
      @started = true

  stop: ->
    if @started
      removeEventListener("popstate", @onPopState, false)
      @started = false

  push: (location, restorationIdentifier) ->
    location = Turbolinks.Location.wrap(location)
    @update("push", location, restorationIdentifier)

  replace: (location, restorationIdentifier) ->
    location = Turbolinks.Location.wrap(location)
    @update("replace", location, restorationIdentifier)

  # Event handlers

  onPopState: (event) =>
    if @shouldHandlePopState()
      if turbolinks = event.state?.turbolinks
        location = Turbolinks.Location.wrap(window.location)
        restorationIdentifier = turbolinks.restorationIdentifier
        @delegate.historyPoppedToLocationWithRestorationIdentifier(location, restorationIdentifier)

  # Private

  shouldHandlePopState: ->
    # Safari dispatches a popstate event after window's load event, ignore it
    pageLoaded is true

  update: (method, location, restorationIdentifier) ->
    state = turbolinks: {restorationIdentifier}
    history[method + "State"](state, null, location)
