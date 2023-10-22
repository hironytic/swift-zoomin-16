import Observation

@MainActor @Observable
final class UserListViewState {
    private let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    var users: [User] {
        userStore.values.values.sorted(by: { $0.id.rawValue < $1.id.rawValue })
    }
    
    func load() async {
        do {
            try await userStore.loadAllValues()
        } catch {
            // Error handling
            print(error)
        }
    }
}
