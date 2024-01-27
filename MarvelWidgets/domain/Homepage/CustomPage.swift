//
//  CustomPage.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation

struct CustomPagesWrapper: Codable {
    let data: CustomPageWrapper
}

struct CustomPagesListWrapper: Codable {
    let data: [CustomPageWrapper]
}

struct CustomPageWrapper: Codable {
    let id: Int
    let attributes: CustomPage
}

struct CustomPage: Codable {
    let components: [HomepageComponent]?
    let title: String
    let parallaxConfig: CustomPageParallaxConfig?
    let imageUrl: String
}

struct CustomPageParallaxConfig: Codable {
    let imageUrl: String
    let height: Int
}
