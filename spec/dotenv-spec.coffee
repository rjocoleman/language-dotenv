describe "dotenv file grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-dotenv")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.dotenv")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.dotenv"

  it "parses simple declarations", ->
    {tokens} = grammar.tokenizeLine("FOO=BAR")
    expect(tokens[0]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[1]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[2]).toEqual value: "BAR", scopes: ["source.dotenv", "string.dotenv"]

  it "parses quoted declarations", ->
    {tokens} = grammar.tokenizeLine("FOO='BAR'")
    expect(tokens[0]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[1]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[2]).toEqual value: "'BAR'", scopes: ["source.dotenv", "string.quoted.single.dotenv"]

    {tokens} = grammar.tokenizeLine("FOO=\"BAR\"")
    expect(tokens[0]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[1]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[2]).toEqual value: "\"BAR\"", scopes: ["source.dotenv", "string.quoted.double.dotenv"]

  it "ignores trailing whitespace after declaration", ->
    {tokens} = grammar.tokenizeLine("FOO=BAR ")
    expect(tokens[3]).toEqual value: " ", scopes: ["source.dotenv"]

    {tokens} = grammar.tokenizeLine("FOO='BAR' ")
    expect(tokens[3]).toEqual value: " ", scopes: ["source.dotenv"]

    {tokens} = grammar.tokenizeLine("FOO=\"BAR\" ")
    expect(tokens[3]).toEqual value: " ", scopes: ["source.dotenv"]

  it "parses whitespaces around the equal sign", ->
    {tokens} = grammar.tokenizeLine("FOO = BAR")
    expect(tokens[0]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[2]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[4]).toEqual value: "BAR", scopes: ["source.dotenv", "string.dotenv"]

  it "parses variable names with punctuation", ->
    {tokens} = grammar.tokenizeLine("F.OO=BAR")
    expect(tokens[0]).toEqual value: "F.OO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[1]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[2]).toEqual value: "BAR", scopes: ["source.dotenv", "string.dotenv"]

  it "parses empty declarations", ->
    {tokens} = grammar.tokenizeLine("FOO=")
    expect(tokens[0]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[1]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]

  it "parses export statements", ->
    {tokens} = grammar.tokenizeLine("export FOO=BAR")
    expect(tokens[0]).toEqual value: "export", scopes: ["source.dotenv", "storage.modifier.export.dotenv"]
    expect(tokens[2]).toEqual value: "FOO", scopes: ["source.dotenv", "constant.language.dotenv"]
    expect(tokens[3]).toEqual value: "=", scopes: ["source.dotenv", "keyword.operator.dotenv"]
    expect(tokens[4]).toEqual value: "BAR", scopes: ["source.dotenv", "string.dotenv"]

  it "parses inline comments", ->
    {tokens} = grammar.tokenizeLine("FOO=BAR # BAZ")
    expect(tokens[4]).toEqual value: "# BAZ", scopes: ["source.dotenv", "comment.dotenv"]

    {tokens} = grammar.tokenizeLine(" # BAZ")
    expect(tokens[1]).toEqual value: "# BAZ", scopes: ["source.dotenv", "comment.dotenv"]

  it "parses whole line comments", ->
    {tokens} = grammar.tokenizeLine("# FOO=BAR")
    expect(tokens[0]).toEqual value: "# FOO=BAR", scopes: ["source.dotenv", "comment.line.dotenv"]

  it "doesn't parse comments in quotes", ->
    {tokens} = grammar.tokenizeLine("FOO='#' # BAR")
    expect(tokens[4]).toEqual value: "# BAR", scopes: ["source.dotenv", "comment.dotenv"]

    {tokens} = grammar.tokenizeLine("FOO=\"#\" # BAR")
    expect(tokens[4]).toEqual value: "# BAR", scopes: ["source.dotenv", "comment.dotenv"]

    {tokens} = grammar.tokenizeLine("FOO='\'#' # BAR")
    expect(tokens[4]).toEqual value: "# BAR", scopes: ["source.dotenv", "comment.dotenv"]

describe "dotenv sets config ", ->
  it "sets an array of filenames in config", ->
    expect(atom.config.get('language-dotenv.dotenvFileNames')).toBeUndefined()

    atom.config.set('language-dotenv.dotenvFileNames', ['.env.test', '.env.dev'])

    runs ->
      expect(atom.config.get('language-dotenv.dotenvFileNames')).toEqual ['.env.test', '.env.dev']
