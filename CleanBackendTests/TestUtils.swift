import Foundation

class TestUtils {
    static func data(fromFile filename: String, withExtension fileExtension: String) -> Data? {
        let bundle = Bundle(for: TestUtils.self)
        guard let url = bundle.url(forResource: filename, withExtension: fileExtension) else {
            return nil
        }
        
        return try? Data(contentsOf: url)
    }
}
