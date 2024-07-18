//
//  Models.swift
//  DragDemo
//
//  Created by 远路蒋 on 2024/7/16.
//

import Foundation

struct Food {
    let id: Int
    let name: String
    let price: Int
    let image: String
}


struct User {
    let id: Int
    let name: String
    let image: String
    var amount: Int
    var items: Int
    var isHighlighted: Bool = false
}
