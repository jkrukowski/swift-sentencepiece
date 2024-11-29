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

    let inputTokens = [35377, 3, 8998, 37]
    let ouput2 = try tokenizer.encode(tokenizer.decode(inputTokens))
    #expect(ouput2 == inputTokens)

    try #expect(tokenizer.decode([]) == "")
    try #expect(tokenizer.encode("") == [])

    #expect(tokenizer.padTokenId == -1)
    #expect(tokenizer.unkTokenId == 0)
    #expect(tokenizer.bosTokenId == 1)
    #expect(tokenizer.eosTokenId == 2)
}
