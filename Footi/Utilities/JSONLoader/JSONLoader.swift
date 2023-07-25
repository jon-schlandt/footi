//
//  JSONLoader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/27/23.
//

import Foundation

struct JSONLoader {
    
    // MARK: Public methods
    
    public static func loadJSONData<T: Decodable>(from fileName: String, decodingType: T.Type) -> T? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(decodingType, from: data)
                
                return decodedData
                
            } catch {
                print("Error reading JSON: \(error)")
            }
        }
        
        return nil
    }
}
