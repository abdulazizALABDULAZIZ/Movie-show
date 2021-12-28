//
//  PeopleCredits.swift
//  Movie show
//
//  Created by MACBOOK on 20/05/1443 AH.
//

import Foundation

struct CastData:Codable {
    var poster_path:String?
    var id:Int?
}

struct CrewData:Codable {
    var poster_path:String?
    var id:Int?
}

struct PeopleCredits:Codable {
    var id: Int?
    var cast:[CastData]?
    var crew:[CrewData]?
}
