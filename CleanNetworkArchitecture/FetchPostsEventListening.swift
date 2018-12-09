import CleanBackend

final class FetchedForumPostsEventListenerFactory: RequestEventListenerFactory {
    private let dataStorage: DataStorage
    var eventListeners: [RequestEventListening]
    
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.eventListeners = [
            StoreFetchedForumPostsEventListener(dataStorage: dataStorage)
            // add additional listeners here
        ]
    }
}

final class StoreFetchedForumPostsEventListener: RequestEventListening {
    private let dataStorage: DataStorage
    
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }
    
    func notify(_ event: RequestEvent) {
        if let fetchedEvent = event as? FetchedForumPostsEvent {
            dataStorage.storeForumPosts(fromDictionaries: fetchedEvent.forumPosts)
        }
    }
}
