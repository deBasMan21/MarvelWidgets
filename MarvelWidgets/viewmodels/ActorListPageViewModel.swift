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
        @Published var birthdayActors: [any Person] = []
        @Published var actors: [any Person] = []
        @Published var filteredActors: [any Person] = []
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
            actors = await ProjectService.getDirectors().compactMap { DirectorPerson($0) }
//            actors = await ProjectService.getActors().compactMap { ActorPerson($0) }
            orderActors()
            updateBirthdayActors()
            filter()
        }
        
        func orderActors() {
            switch orderType {
            case .nameASC:
                filteredActors = filteredActors.sorted(by: {
                    "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)"
                })
            case .nameDESC:
                filteredActors = filteredActors.sorted(by: {
                    "\($0.firstName) \($0.lastName)" > "\($1.firstName) \($1.lastName)"
                })
            }
        }
        
        func updateBirthdayActors() {
            birthdayActors = actors.filter {
                if let components = $0.dateOfBirth?.toDate()?.get(.day, .month) {
                    let nowComponents = Date.now.get(.day, .month)
                    return nowComponents.day == components.day && nowComponents.month == components.month
                }
                return false
            }
        }
        
        func filter() {
            var filteredActors = self.actors
            if !filterSearchQuery.isEmpty {
                filteredActors = filteredActors.filter { $0.getSearchString().contains(filterSearchQuery) }
            }
            
            self.filteredActors = filteredActors
            orderActors()
        }
    }
}

protocol Person: Identifiable {
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
    var dateOfBirth: String? { get }
    var projects: [ProjectWrapper] { get }
    var imageUrl: URL? { get }
    
    func getSubtitle() -> String
    func getSearchString() -> String
    func getDestinationView(showLoader: Binding<Bool>) -> AnyView
}

class DirectorPerson: Person {
    var id: Int
    var firstName: String
    var lastName: String
    var dateOfBirth: String?
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    private var director: DirectorsWrapper
    
    init(_ director: DirectorsWrapper) {
        self.id = director.id
        self.firstName = director.attributes.firstName
        self.lastName = director.attributes.lastName
        self.dateOfBirth = director.attributes.dateOfBirth
        self.projects = director.attributes.mcuProjects?.data ?? []
        self.projects += director.attributes.relatedProjects?.data ?? []
        self.imageUrl = URL(string: director.attributes.imageURL ?? "")
        
        self.director = director
    }
    
    func getSubtitle() -> String {
        dateOfBirth ?? "No Date Of Birth"
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName
    }
    
    func getDestinationView(showLoader: Binding<Bool>) -> AnyView {
        AnyView(DirectorDetailView(director: director, showLoader: showLoader))
    }
}

class ActorPerson: Person {
    var id: Int
    var firstName: String
    var lastName: String
    var role: String
    var dateOfBirth: String?
    var projects: [ProjectWrapper]
    var imageUrl: URL?
    
    private var actor: ActorsWrapper
    
    init(_ actor: ActorsWrapper) {
        self.id = actor.id
        self.firstName = actor.attributes.firstName
        self.lastName = actor.attributes.lastName
        self.role = actor.attributes.character
        self.dateOfBirth = actor.attributes.dateOfBirth
        self.projects = actor.attributes.mcuProjects?.data ?? []
        self.projects += actor.attributes.relatedProjects?.data ?? []
        self.imageUrl = URL(string: actor.attributes.imageURL ?? "")
        self.actor = actor
    }
    
    func getSubtitle() -> String {
        role
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName + " " + role
    }
    
    func getDestinationView(showLoader: Binding<Bool>) -> AnyView {
        AnyView(ActorDetailView(actor: actor, showLoader: showLoader))
    }
}
