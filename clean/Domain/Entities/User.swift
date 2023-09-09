import Foundation

struct Users: Decodable {
    let data: [User]
}

struct UserDetail: Decodable {
    let data: User
}

struct User: Decodable {
    let id: Int
    let email: String
    let first_name: String
    let last_name: String
    let avatar: String
    
    var description: String {
        String(format: "%@ %@\nEmail: %@",
               first_name, last_name, email)
    }
}
