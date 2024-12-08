import Sentencepiece

extension SentencepieceTokenizer {
    public enum Error: Swift.Error {
        case failedToCreateProcessor
        case failedToLoadModel
        case failedToProcess
    }
}

public final class SentencepieceTokenizer {
    private let processor: UnsafeMutableRawPointer
    private let tokenOffset: Int

    deinit {
        spm_free_sentencepiece_processor(processor)
    }

    public var unkTokenId: Int {
        Int(spm_unk_id(processor)) + tokenOffset
    }

    public var bosTokenId: Int {
        Int(spm_bos_id(processor)) + tokenOffset
    }

    public var eosTokenId: Int {
        Int(spm_eos_id(processor)) + tokenOffset
    }

    public var padTokenId: Int {
        Int(spm_pad_id(processor)) + tokenOffset
    }

    /// Initialize SentencepieceTokenizer with a model file.
    ///
    /// NOTE: `tokenOffset` is used to adjust the token ids
    /// to be compatible with Hugging Face tokenizers.
    public init(modelPath: String, tokenOffset: Int = 1) throws {
        guard let processor = spm_new_sentencepiece_processor() else {
            throw Error.failedToCreateProcessor
        }
        guard spm_load_model(processor, modelPath) else {
            throw Error.failedToLoadModel
        }
        self.processor = processor
        self.tokenOffset = tokenOffset
    }

    public func normalize(_ text: String) throws -> String {
        guard let normalizedPtr = spm_normalize(processor, text) else {
            throw Error.failedToProcess
        }
        defer { normalizedPtr.deallocate() }
        return String(cString: normalizedPtr)
    }

    public func idToToken(_ id: Int) throws -> String {
        precondition(id - tokenOffset >= 0)
        guard let tokenPtr = spm_id_to_piece(processor, Int32(id - tokenOffset)) else {
            throw Error.failedToProcess
        }
        defer { tokenPtr.deallocate() }
        return String(cString: tokenPtr)
    }

    public func tokenToId(_ token: String) -> Int {
        Int(spm_piece_to_id(processor, token)) + tokenOffset
    }

    public func encode(_ text: String) throws -> [Int] {
        var size: Int32 = 0
        guard let encodedPtr = spm_encode(processor, text, &size) else {
            throw Error.failedToProcess
        }
        defer { encodedPtr.deallocate() }
        let result = Array(UnsafeBufferPointer(start: encodedPtr, count: Int(size)))
        return result.map { Int($0) + tokenOffset }
    }

    public func setEncodeExtraOptions(_ options: String) {
        spm_set_encode_extra_options(processor, options)
    }

    public func decode(_ ids: [Int]) throws -> String {
        let encoded = ids.map { Int32($0 - tokenOffset) }
        guard let decodedPtr = spm_decode(processor, encoded, Int32(encoded.count)) else {
            throw Error.failedToProcess
        }
        defer { decodedPtr.deallocate() }
        return String(cString: decodedPtr)
    }

    public func setDecodeExtraOptions(_ options: String) {
        spm_set_decode_extra_options(processor, options)
    }
}
