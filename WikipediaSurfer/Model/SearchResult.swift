//
//  SearchResult.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 10/1/19.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    let search: String
    let title: [String]
    let description: [String]
    let url: [String]
    
    init(from decoder: Decoder) throws {
        var unkeyedContainer = try decoder.unkeyedContainer()
        search = try unkeyedContainer.decode(String.self)
        title = try unkeyedContainer.decode([String].self)
        description = try unkeyedContainer.decode([String].self)
        url = try unkeyedContainer.decode([String].self)
    }
}
