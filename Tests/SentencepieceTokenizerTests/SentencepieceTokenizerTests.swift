import Foundation
import Testing

@testable import SentencepieceTokenizer

@Test func sentencepieceTokenizer() throws {
    let modelPath = try #require(
        Bundle.module.path(forResource: "sentencepiece.bpe", ofType: "model", inDirectory: "Model"))
    let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)

    let inputText = "Hello, world!"
    let ouput1 = try tokenizer.decode(tokenizer.encode(inputText))
    #expect(ouput1 == inputText)

    let inputTokens = [35378, 4, 8999, 38]
    let ouput2 = try tokenizer.encode(tokenizer.decode(inputTokens))
    #expect(ouput2 == inputTokens)

    let normalized = try tokenizer.normalize("Hello, world!")
    #expect(normalized == "▁Hello,▁world!")

    try #expect(tokenizer.idToToken(35378) == "▁Hello")
    try #expect(tokenizer.idToToken(4) == ",")
    try #expect(tokenizer.idToToken(8999) == "▁world")
    try #expect(tokenizer.idToToken(38) == "!")

    try #expect(tokenizer.decode([]) == "")
    try #expect(tokenizer.encode("") == [])

    #expect(tokenizer.padTokenId == 0)
    #expect(tokenizer.unkTokenId == 1)
    #expect(tokenizer.bosTokenId == 2)
    #expect(tokenizer.eosTokenId == 3)
}
