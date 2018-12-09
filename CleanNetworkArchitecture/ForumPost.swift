struct ForumPost {
    let authorId: Int
    let postId: Int
    let title: String
    let body: String
    
    init(authorId: Int, postId: Int, title: String, body: String) {
        self.authorId = authorId
        self.postId = postId
        self.title = title
        self.body = body
    }
    
    init?(dictionary: [String: Any]) {
        guard
            let authorId = dictionary["userId"] as? Int,
            let postId = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let body = dictionary["title"] as? String
            else {
                return nil
        }
        
        self.init(authorId: authorId, postId: postId, title: title, body: body)
    }
}
