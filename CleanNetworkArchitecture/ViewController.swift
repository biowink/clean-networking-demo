import UIKit
import CleanBackend

final class ViewController: UIViewController, DataStorageDelegate {

    private var dataStorage = DataStorage()
    // A.
    private var fetchPostsRequest: FetchForumPostsRequest?
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var userIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResults()
        dataStorage.delegate = self
    }
    
    // B.
    @IBAction func fetchPosts() {
        let config = RequestConfiguration(baseUrl: URL(string: "https://jsonplaceholder.typicode.com")!)
        let client = HTTPClient(configuration: config)
        let eventListenerFactory = FetchedForumPostsEventListenerFactory(dataStorage: dataStorage)
        fetchPostsRequest = FetchForumPostsRequest(client: client, eventListenerFactory: eventListenerFactory)
        
        let userId = Int(userIdTextField.text ?? "")
        fetchPostsRequest?.fetchForumPosts(userId: userId)
    }
    
    
    // MARK: DataStorageDelegate methods
    func dataStorageDidStoreForumPosts() {
        updateResults()
    }
    
    private func updateResults() {
        resultLabel.text = "\(dataStorage.forumPosts.count) forum posts"
    }
}


