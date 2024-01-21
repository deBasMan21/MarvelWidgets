//
//  UrlBuildertype.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/04/2023.
//

import Foundation

protocol UrlBuilderType {
    func getString() -> String
    
    func addFirstUpcomingFilter() -> UrlBuilderType
    func addTypeFilter(type: WidgetType) -> UrlBuilderType
    
    func addSortByPublishDate() -> UrlBuilderType
    func addPagination(pageSize: Int, page: Int) -> UrlBuilderType
    
    func addMcuOrRelatedFilter(type: ListPageType) -> UrlBuilderType
    func addMcuProjectFilter() -> UrlBuilderType
    func addRelatedProjectFilter() -> UrlBuilderType
    func addSourceProjectFilter(type: ProjectSource?) -> UrlBuilderType
    
    func addPopulate(type: UrlPopulateComponents) -> UrlBuilderType
}
