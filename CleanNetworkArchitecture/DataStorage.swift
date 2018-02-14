import Foundation

protocol DataStorageDelegate: class {
    func dataStorageDidStorePosts()
}

class DataStorage {
    var posts = [Post]()
    weak var delegate: DataStorageDelegate?
    
    func storePosts(fromDictionaries dictionaries: [[String: Any]]) {
        posts.removeAll()
        
        for dict in dictionaries {
            if let post = Post(dictionary: dict) {
                posts.append(post)
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.dataStorageDidStorePosts()
        }
    }
}
