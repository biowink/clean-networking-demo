import Foundation

protocol DataStorageDelegate: class {
    func dataStorageDidStoreForumPosts()
}

final class DataStorage {
    var forumPosts = [ForumPost]()
    weak var delegate: DataStorageDelegate?
    
    func storeForumPosts(fromDictionaries dictionaries: [[String: Any]]) {
        forumPosts.removeAll()
        
        for dict in dictionaries {
            if let post = ForumPost(dictionary: dict) {
                forumPosts.append(post)
            }
        }
        
        DispatchQueue.main.async {
            self.delegate?.dataStorageDidStoreForumPosts()
        }
    }
}
