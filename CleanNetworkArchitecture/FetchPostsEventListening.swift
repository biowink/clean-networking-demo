import CleanBackend

class FetchedPostsEventListenerFactory: RequestEventListenerFactory {
    private let dataStorage: DataStorage
    var eventListeners: [RequestEventListening]
    
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
        self.eventListeners = [
            StoreFetchedPostsEventListener(dataStorage: dataStorage)
            // add additional listeners here
        ]
    }
}

class StoreFetchedPostsEventListener: RequestEventListening {
    private let dataStorage: DataStorage
    
    init(dataStorage: DataStorage) {
        self.dataStorage = dataStorage
    }
    
    func notify(_ event: RequestEvent) {
        if let fetchedEvent = event as? FetchedPostsEvent {
            dataStorage.storePosts(fromDictionaries: fetchedEvent.posts)
        }
    }
}
