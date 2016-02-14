{CompositeDisposable} = require 'atom'
_ = require 'lodash'
config = require './config.coffee'

debounce = 'atom-idle-autosave.debounce'

save = (editor) ->
  editor.save() if editor.getPath()

module.exports =
  activate: ->
    @subscriptions = new CompositeDisposable
    @debouncedSave = _.debounce save, atom.config.get(debounce)
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.onDidChange @debouncedSave.bind(this, editor)

    @subscriptions.add atom.config.onDidChange debounce, =>
      @deactivate()
      @activate()

  deactivate: ->
    @subscriptions.dispose()

  config: config
