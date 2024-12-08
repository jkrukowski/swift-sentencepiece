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

        XCTAssertEqual(tokenizer.tokenToId("▁Hello"), 35378)
        XCTAssertEqual(tokenizer.tokenToId(","), 4)
        XCTAssertEqual(tokenizer.tokenToId("▁world"), 8999)
        XCTAssertEqual(tokenizer.tokenToId("!"), 38)

        XCTAssertEqual(try tokenizer.decode([]), "")
        XCTAssertEqual(try tokenizer.encode(""), [])

        XCTAssertEqual(tokenizer.padTokenId, 0)
        XCTAssertEqual(tokenizer.unkTokenId, 1)
        XCTAssertEqual(tokenizer.bosTokenId, 2)
        XCTAssertEqual(tokenizer.eosTokenId, 3)
    }

    func testSentencepieceEncodeExtraOptions() throws {
        let modelPath = try XCTUnwrap(
            Bundle.module.path(
                forResource: "sentencepiece.bpe", ofType: "model", inDirectory: "Model"))
        let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)
        tokenizer.setEncodeExtraOptions("reverse:bos:eos")
        let output = try tokenizer.encode("Hello, world!")
        XCTAssertEqual(output, [2, 38, 8999, 4, 35378, 3])
    }

    func testSentencepieceDecodeExtraOptions() throws {
        let modelPath = try XCTUnwrap(
            Bundle.module.path(
                forResource: "sentencepiece.bpe", ofType: "model", inDirectory: "Model"))
        let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)
        tokenizer.setDecodeExtraOptions("reverse:bos:eos")
        let output = try tokenizer.decode([2, 35378, 4, 8999, 38, 3])
        XCTAssertEqual(output, "! world, Hello")
    }
}
