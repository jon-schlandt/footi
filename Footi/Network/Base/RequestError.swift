//
//  RequestError.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidUrl
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var message: String {
        switch self {
        case .decode:
            return "An error occured while decoding."
        case .invalidUrl:
            return "An invalid URL was provided in the request."
        case .noResponse:
            return "No response was returned."
        case .unauthorized:
            return "An authorization error occured."
        case .unexpectedStatusCode:
            return "A unexpected status code was returned in the response."
        default:
            return "An unknown error occured."
        }
    }
}
