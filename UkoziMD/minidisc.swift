//
//  minidisc.swift
//  UkoziMD
//
//  Created by Lucas J. Chumley on 11/14/22.
//

import Foundation

struct Disc {
    var Title: String
    var trackIndex: String
    var tracks: [Track]
}

struct Track: Identifiable {
    public var id: Int
    public var title: String
    public var time: String
    
}
