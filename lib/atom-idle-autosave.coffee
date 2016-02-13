_ = require 'lodash'

debounce = 700

withActiveEditor = (action) ->
  action atom.workspace.getActiveTextEditor()

timed = (marker, action) ->
  console.time marker
  result = do action
  console.timeEnd marker
  result

notTemp = (action) -> (editor) ->
  action editor if editor.getPath()?

onlyModified = (action) -> (editor) ->
  action editor if editor.isModified()

save = (editor) ->
  editor.save()

debouncedSave = _.debounce (-> withActiveEditor notTemp onlyModified save), debounce

module.exports =
  disposables: []

  activate: ->
    @disposables.push atom.workspace.observeTextEditors (editor) => @disposables.push editor.onDidChange debouncedSave

  deactivate: ->
    @disposables.forEach (disposable) -> disposable.dispose()
