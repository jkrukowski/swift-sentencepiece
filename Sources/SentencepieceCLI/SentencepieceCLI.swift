import ArgumentParser
import Foundation
import SentencepieceTokenizer

@main
struct SentencepieceCLI: ParsableCommand {
    @Option var modelPath: String
    @Option var text: String = "Hello, world!"

    mutating func run() throws {
        let tokenizer = try SentencepieceTokenizer(modelPath: modelPath)
        let encoded = try tokenizer.encode(text)
        print(encoded)
        let decoded = try tokenizer.decode(encoded)
        print(decoded)
    }
}
