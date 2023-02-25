//
//  Endpoint.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
    var body: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api-football-v1.p.rapidapi.com"
    }
    
    var queryItems: [URLQueryItem] {
        return [URLQueryItem]()
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var headers: [String: String]? {
        return [
            "x-rapidapi-host": "api-football-v1.p.rapidapi.com",
            "x-rapidapi-key": "af179b11fcmsh9be968bd7f841a0p1a0924jsn01d171fbf651"
        ]
    }
    
    var body: [String: String]? {
        return nil
    }
}
