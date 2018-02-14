struct Post {
    let userId: Int
    let postId: Int
    let title: String
    let body: String
    
    init(userId: Int, postId: Int, title: String, body: String) {
        self.userId = userId
        self.postId = postId
        self.title = title
        self.body = body
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let userId = dictionary["userId"] as? Int,
            let postId = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let body = dictionary["title"] as? String
            else {
                return nil
        }
        
        self.init(userId: userId, postId: postId, title: title, body: body)
    }
}
