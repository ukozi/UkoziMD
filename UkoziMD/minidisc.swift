//
//  minidisc.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 11/14/22.
//

import Foundation

struct Disc {
    var Title: String
    var tracks: [Track]
}

struct Track: Identifiable {
    var id: Int
    var title: String
    var time: String?
    
}
