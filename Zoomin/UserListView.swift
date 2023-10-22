import SwiftUI

struct UserListView: View {
    @Environment(UserStore.self) var userStore
    
    var body: some View {
        UserListStateView(state: UserListViewState(userStore: userStore))
    }
}

struct UserListStateView: View {
    let state: UserListViewState
    
    var body: some View {
        List(state.users) { user in
            NavigationLink {
                UserView(id: user.id)
            } label: {
                Text(user.name)
            }
        }
        .listStyle(.plain)
        .task {
            await state.load()
        }
    }
}

#Preview {
    NavigationStack {
        UserListView()
    }
    .environment(UserStore(userRepository: UserRepository.shared))
}
