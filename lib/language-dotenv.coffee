{Subscriber} = require 'emissary'

module.exports =
  class LanguageDotenv
    Subscriber.includeInto this

    constructor: (@editorView) ->
      @subscribe @editorView, 'editor:path-changed', =>
        @subscribeToBuffer()

      @subscribe atom.config.observe 'language-dotenv.dotenvFileNames', =>
        @subscribeToBuffer()

      @subscribeToBuffer()

    subscribeToBuffer: ->
      filename = @editorView.getEditor().getBuffer().getBaseName()
      if filename in atom.config.get('language-dotenv.dotenvFileNames')
        path = @editorView.getEditor().getPath()
        atom.grammars.setGrammarOverrideForPath(path, 'source.dotenv')
        @editorView.editor.reloadGrammar()
