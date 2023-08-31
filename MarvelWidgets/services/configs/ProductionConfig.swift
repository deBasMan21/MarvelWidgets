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
    let apiKey: String = "Bearer e0ebecdac3b7ec3182068205540a3a164447adf75eab40ff4cbd3b00ae1a5802060f447e19f4fd5905d86161f597b8128d7425f88d26ee523ed30fc9d75ebb39407ad36e54e3dfaa81107d532eee8b19ba63163a1847187a762d398d069d8c71f3703b06f99fd04cf3af9fb7e1d47fb3628c9595390bdb99f00c638a5ac5eb33"
    
    let trackingUrl: String = "https://mcuwidgets-recommendations.buijsenserver.nl/api"
    
    init() { }
}
