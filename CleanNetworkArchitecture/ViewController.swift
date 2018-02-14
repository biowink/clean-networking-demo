import UIKit
import CleanBackend

class ViewController: UIViewController, DataStorageDelegate {
    private var dataStorage = DataStorage()
    private var postsRequest: ForumPostsRequest?
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var userIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateResults()
        dataStorage.delegate = self
    }
    
    @IBAction func fetchPosts() {
        let config = RequestConfiguration(baseUrl: URL(string: "https://jsonplaceholder.typicode.com")!)
        let client = HTTPClient(configuration: config)
        postsRequest = ForumPostsRequest(client: client,
                                    eventListenerFactory: FetchedPostsEventListenerFactory(dataStorage: dataStorage))
        
        let userId = Int(userIdTextField.text ?? "")
        postsRequest?.fetchPosts(userId: userId)
    }
    
    func dataStorageDidStorePosts() {
        updateResults()
    }
    
    private func updateResults() {
        resultLabel.text = "\(dataStorage.posts.count) posts"
    }
}
