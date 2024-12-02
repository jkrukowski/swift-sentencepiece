import Foundation
import XCTest

@testable import SentencepieceTokenizer

final class SentencepieceTokenizerTests: XCTestCase {
    func testSentencepieceTokenizer() throws {
        let modelPath = try XCTUnwrap(
            Bundle.module.path(
                forResource: "sentencepiece.bpe", ofType: "model", inDirectory: "Model"))
        let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)

        let inputText = "Hello, world!"
        let output1 = try tokenizer.decode(tokenizer.encode(inputText))
        XCTAssertEqual(output1, inputText)

        let inputTokens = [35378, 4, 8999, 38]
        let output2 = try tokenizer.encode(tokenizer.decode(inputTokens))
        XCTAssertEqual(output2, inputTokens)

        let normalized = try tokenizer.normalize("Hello, world!")
        XCTAssertEqual(normalized, "▁Hello,▁world!")

        XCTAssertEqual(try tokenizer.idToToken(35378), "▁Hello")
        XCTAssertEqual(try tokenizer.idToToken(4), ",")
        XCTAssertEqual(try tokenizer.idToToken(8999), "▁world")
        XCTAssertEqual(try tokenizer.idToToken(38), "!")

        XCTAssertEqual(try tokenizer.decode([]), "")
        XCTAssertEqual(try tokenizer.encode(""), [])

        XCTAssertEqual(tokenizer.padTokenId, 0)
        XCTAssertEqual(tokenizer.unkTokenId, 1)
        XCTAssertEqual(tokenizer.bosTokenId, 2)
        XCTAssertEqual(tokenizer.eosTokenId, 3)
    }
}
