import Sentencepiece

extension SentencepieceTokenizer {
    public enum Error: Swift.Error {
        case failedToCreateProcessor
        case failedToLoadModel
        case failedToEncode
        case failedToDecode
    }
}

public class SentencepieceTokenizer {
    private let processor: UnsafeMutableRawPointer

    deinit {
        spm_free_sentencepiece_processor(processor)
    }

    public var unkTokenId: Int {
        Int(spm_unk_id(processor))
    }

    public var bosTokenId: Int {
        Int(spm_bos_id(processor))
    }

    public var eosTokenId: Int {
        Int(spm_eos_id(processor))
    }

    public var padTokenId: Int {
        Int(spm_pad_id(processor))
    }

    public init(modelPath: String) throws {
        guard let processor = spm_new_sentencepiece_processor() else {
            throw Error.failedToCreateProcessor
        }
        guard spm_load_model(processor, modelPath) else {
            throw Error.failedToLoadModel
        }
        self.processor = processor
    }

    public func encode(_ text: String) throws -> [Int] {
        var size: Int32 = 0
        guard let encodedPtr = spm_encode(processor, text, &size) else {
            throw Error.failedToEncode
        }
        defer { encodedPtr.deallocate() }
        let result = Array(UnsafeBufferPointer(start: encodedPtr, count: Int(size)))
        return result.map { Int($0) }
    }

    public func decode(_ ids: [Int]) throws -> String {
        let encoded = ids.map { Int32($0) }
        var size: Int32 = 0
        guard let decodedPtr = spm_decode(processor, encoded, Int32(encoded.count), &size) else {
            throw Error.failedToDecode
        }
        defer { decodedPtr.deallocate() }
        return String(cString: decodedPtr)
    }
}
