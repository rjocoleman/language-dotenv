describe "dotenv file grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-dotenv")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.dotenv")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.dotenv"

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine("# FOO=BAR")
    expect(tokens[0]).toEqual value: "# FOO=BAR", scopes: ["source.dotenv", "comment.line.dotenv"]
