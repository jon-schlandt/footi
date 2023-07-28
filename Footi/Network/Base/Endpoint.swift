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
        guard let host = ProcessInfo.processInfo.environment["APIFOOTBALL_HOST"] else {
            return nil
        }
        
        guard let key = ProcessInfo.processInfo.environment["APIFOOTBALL_KEY"] else {
            return nil
        }
        
        return [
            "x-rapidapi-host": host,
            "x-rapidapi-key": key
        ]
    }
    
    var body: [String: String]? {
        return nil
    }
}
