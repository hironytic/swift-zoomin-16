import Observation

@MainActor @Observable
final class UserViewState {
    private let userStore: UserStore
    private let id: User.ID
    
    var user: User? { userStore.values[id] }
    private(set) var isReloadButtonDisabled: Bool = false
    
    init(userStore: UserStore, id: User.ID) {
        self.userStore = userStore
        self.id = id
    }

    func load() async {
        isReloadButtonDisabled = true
        defer { isReloadButtonDisabled = false}
        
        do {
            try await userStore.loadValue(for: id)
        } catch {
            // Error handling
            print(error)
        }
    }
    
    func reload() {
        isReloadButtonDisabled = true
        Task {
            await load()
        }
    }
}
