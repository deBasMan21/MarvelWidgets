//
//  ProductionConfig.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 05/04/2023.
//

import Foundation

class ProductionConfig: Config {
    static let standard: Config = ProductionConfig()
    
    let baseUrl: String = "https://mcuwidgets.buijsenserver.nl/api"
    let apiKey: String = "Bearer e0235424cceeafb84f5bef832e2501a63942138847f11a56c033c24147946d7b5fbfb786eadd0b83d890aabaf48aebb79b57a0d70dc9295f1622cb2ab5898ddbd790c4758cdcd5e41d9d1f70971deb803de0ba7386072feeaf25e0b2b13f70ed2409c8651067b586436f605a21ceb84ac65c487a7b4f0f9814ad42a32cf92208"
    
    init() { }
}
