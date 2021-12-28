//
//  MovieResults.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import Foundation


struct MovieResults: Codable {
    
    var region: String?
    var results: [Movie]?
    //var known_for: [Movie]?
    var total_pages: Int?
    var total_results: Int?
    
    static func decode(jsonData: Data) -> MovieResults? {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(MovieResults.self, from: jsonData)
            return result
        } catch let error {
            print("Failed decoding with error: \(error)")
            return nil
        }
    }
}
