
func binarytotype <T> (_ value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBufferPointer {
        UnsafeRawPointer($0.baseAddress!).load(as: T.self)
    }
}

func typetobinary<T>(_ value: T) -> [UInt8] {
    var data = [UInt8](repeating: 0, count: MemoryLayout<T>.size)
    data.withUnsafeMutableBufferPointer {
        UnsafeMutableRawPointer($0.baseAddress!).storeBytes(of: value, as: T.self)
    }
    return data
}
