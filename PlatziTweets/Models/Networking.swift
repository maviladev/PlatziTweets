//
//  Networking.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-08-26.
//  Copyright © 2020 avilamisc. All rights reserved.
//

struct Endpoints {
    static let domain = "https://platzi-tweets-backend.herokuapp.com/api/v1"
    static let login = Endpoints.domain + "/auth"
    static let register = Endpoints.domain + "/register"
    static let posts = Endpoints.domain + "/posts"
    static let delete = posts + "/{ID_DEL_POST}"
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let user: User
    let token: String
}

struct ErrorResponse: Codable {
    let error: String
}

struct User: Codable {
    let email: String
    let names: String
    let nickname: String
}

struct RegistryRequest: Codable {
    let email: String
    let password: String
    let names: String
}

struct RegistryResponse: Codable {
    let email: String
    let names: String
    let nickname: String
    let token: String
}

struct PostItem: Codable {
    let id: String
    let author: User
    let imageUrl: String?
    let text: String
    let videoUrl: String?
    let location: Location?
    let hasVideo: Bool
    let hasImage: Bool
    let hasLocation: Bool
    let createdAt: String
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

struct PostListResponse: Codable {
    let posts = [PostItem]()
}

struct DeleteResponse: Codable {
    let isDone: Bool
    let message: String
}
