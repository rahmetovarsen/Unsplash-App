import UIKit

//MARK: - Network for Home controller
struct Response: Codable {
    let results: [Result]
}

struct Result: Codable {
    let id: String
    let urls: Urls
}

struct Urls: Codable {
    let small: String
}

//MARK: - Network for Details controller

struct Photo: Codable {
    let created_at: String
    let downloads: Int
    let location: Location
    let urls: Url
    let user: User
}

struct Location: Codable {
    let city: String?
}

struct Url: Codable {
    let small: String
}

struct User: Codable {
    let name: String
}

