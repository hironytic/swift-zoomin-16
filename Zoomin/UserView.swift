import SwiftUI

struct UserView: View {
    let id: User.ID
    @Environment(UserStore.self) var userStore
    
    var body: some View {
        UserStateView(state: UserViewState(userStore: userStore, id: id))
    }
}

struct UserStateView: View {
    let state: UserViewState

    var body: some View {
        VStack {
            Text(state.user?.name ?? "User Name")
                .redacted(reason: state.user == nil ? .placeholder : [])
                .font(.title)
            Button("Reload") {
                state.reload()
            }
            .disabled(state.isReloadButtonDisabled)
        }
        .task {
            await state.load()
        }
    }
}

#Preview {
    UserView(id: "A")
        .environment(UserStore(userRepository: PreviewUserRepository(values: [
            "A": User(id: "A", name: "Name A")
        ])))
}

#Preview {
    UserView(id: "A")
        .environment(UserStore(userRepository: PreviewUserRepository(values: [:])))
}

private struct PreviewUserRepository: UserRepositoryProtocol {
    let values: [User.ID: User]
    
    func fetchValue(for id: User.ID) async throws -> User? {
        values[id]
    }
    
    func fetchAllValues() async throws -> [User] {
        values.values.sorted(by: { $0.id.rawValue < $1.id.rawValue })
    }
}
