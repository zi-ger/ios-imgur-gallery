//
//  Image.swift
//  ios-imgur-gallery
//
//  Created by Gustavo Ziger on 01/10/22.
//

import Foundation

struct Image: Codable {
    let id: String
    let link: String
    let type: String?
}

struct ImageData: Codable {
    let data: [Image]
}
