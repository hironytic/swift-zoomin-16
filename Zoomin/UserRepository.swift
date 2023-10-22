protocol UserRepositoryProtocol {
    func fetchValue(for id: User.ID) async throws -> User?
    func fetchAllValues() async throws -> [User]
}

struct UserRepository: UserRepositoryProtocol {
    private let values: [User.ID: User] = {
        let values: [User] = [
            .init(id: "A", name: "Name A"),
            .init(id: "B", name: "Name B"),
            .init(id: "C", name: "Name C"),
        ]
        return [User.ID: User](uniqueKeysWithValues: values.map { ($0.id, $0) })
    }()
    
    static let shared: UserRepository = .init()
    
    func fetchValue(for id: User.ID) async throws -> User? {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        guard var user = values[id] else { return nil }
        user.name = generateRandomUserName()
        return user
    }
    
    func fetchAllValues() async throws -> [User] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return values
            .values
            .sorted(by: { $0.id.rawValue < $1.id.rawValue })
            .map {
                var user = $0
                user.name = generateRandomUserName()
                return user
            }
    }
    
    private func generateRandomUserName() -> String {
        let adjectives = ["Happy", "Silly", "Clever", "Cool", "Funky", "Lucky", "Gentle", "Brave", "Wild", "Dizzy"]
        let nouns = ["Cat", "Dog", "Unicorn", "Penguin", "Ninja", "Pirate", "Wizard", "Dragon", "Alien", "Robot"]
        
        let randomAdjective = adjectives.randomElement() ?? "Random"
        let randomNoun = nouns.randomElement() ?? "User"
        
        return randomAdjective + randomNoun
    }
}
