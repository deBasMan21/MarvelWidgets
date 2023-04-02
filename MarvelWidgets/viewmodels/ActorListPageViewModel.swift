//
//  ActorListPageViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import Foundation
import SwiftUI

extension ActorListPageView {
    class ViewModel: ObservableObject {
        @Published var orderType: SortKeys = .nameASC {
            didSet {
                orderActors()
            }
        }
        @Published var birthdayActors: [ActorsWrapper] = []
        @Published var actors: [ActorsWrapper] = []
        @Published var filteredActors: [ActorsWrapper] = []
        @Published var filterSearchQuery: String = "" {
            didSet {
                filter()
            }
        }
        @Published var showBirthdays: Bool = true
        
        let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        func getActors() async {
            actors = await ProjectService.getActors()
            orderActors()
            updateBirthdayActors()
            filter()
        }
        
        func orderActors() {
            switch orderType {
            case .nameASC:
                filteredActors = filteredActors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" < "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            case .nameDESC:
                filteredActors = filteredActors.sorted(by: {
                    "\($0.attributes.firstName) \($0.attributes.lastName)" > "\($1.attributes.firstName) \($1.attributes.lastName)"
                })
            }
        }
        
        func updateBirthdayActors() {
            birthdayActors = actors.filter {
                if let components = $0.attributes.dateOfBirth?.toDate()?.get(.day, .month) {
                    let nowComponents = Date.now.get(.day, .month)
                    return nowComponents.day == components.day && nowComponents.month == components.month
                }
                return false
            }
        }
        
        func filter() {
            var filteredActors = self.actors
            if !filterSearchQuery.isEmpty {
                filteredActors = filteredActors.filter {
                    let name = "\($0.attributes.firstName) \($0.attributes.lastName)"
                    return $0.attributes.character.contains(filterSearchQuery) || name.contains(filterSearchQuery)
                }
            }
            
            self.filteredActors = filteredActors
            orderActors()
        }
    }
}

protocol Person {
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
    var dateOfBirth: String { get }
    var projects: [ProjectWrapper] { get }
    var imageUrl: URL? { get }
    
    func getSubtitle() -> String
    func getSearchString() -> String
}

class DirectorPerson: Person {
    var id: Int
    var firstName: String
    var lastName: String
    var dateOfBirth: String
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    init(id: Int, firstName: String, lastName: String, dateOfBirth: String, projects: [ProjectWrapper]?, imageUrl: URL?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.projects = projects ?? []
        self.imageUrl = imageUrl
    }
    
    func getSubtitle() -> String {
        dateOfBirth
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName
    }
}

class ActorPerson: Person {
    var id: Int
    var firstName: String
    var lastName: String
    var role: String
    var dateOfBirth: String
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    init(id: Int, firstName: String, lastName: String, role: String, dateOfBirth: String, projects: [ProjectWrapper]?, imageUrl: URL?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.dateOfBirth = dateOfBirth
        self.projects = projects ?? []
        self.imageUrl = imageUrl
    }
    
    func getSubtitle() -> String {
        role
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName + " " + role
    }
}
