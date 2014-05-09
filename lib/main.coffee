LanguageDotenv = require './language-dotenv'

module.exports =
  configDefaults:
    dotenvFileNames: [
      '.env.production'
      '.env.development'
      '.env.test'
    ]

  activate: ->
    atom.workspaceView.eachEditorView (editor) ->
      @languageDotenv = new LanguageDotenv(editor)
