//
//  ActorListPageViewModel.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import Foundation
import SwiftUI

extension PersonListPageView {
    class ViewModel: ObservableObject {
        @Published var showSheet: Bool = false
        @Published var sheetHeight: PresentationDetent = .medium
        @Published var detents: Set<PresentationDetent> = [.medium]
        
        @Published var scrollViewHeight: CGFloat = 0
        @Published var proportion: CGFloat = 0
        @Published var proportionName: String = "scroll"
        
        @Published var personType: PersonType
        @Published var birthdayPersons: [any Person] = []
        @Published var persons: [any Person] = []
        @Published var filteredPersons: [any Person] = []
        @Published var showFilters: Bool = false
        @Published var showBirthdays: Bool = true
        @Published var filterSearchQuery: String = "" {
            didSet {
                filter()
            }
        }
        @Published var orderType: SortKeys = .nameASC {
            didSet {
                orderPersons()
            }
        }
        @Published var filterBeforeDate: Date = Date.now {
            didSet {
                filter()
            }
        }
        @Published var filterAfterDate: Date = Date.now {
            didSet {
                filter()
            }
        }
        
        var filterCallback: (Bool, Int) -> Void = { _, _ in }
        private var minimumBeforeDate: Date = Date.now
        private var maximumAfterDate: Date = Date.now
        
        init(personType: PersonType) {
            self.personType = personType
        }
        
        let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        
        func getPersons() async {
            persons = await personType.getPersons()
            orderPersons()
            updateBirthdayPersons()
            setBirthdates(save: true)
            filter()
        }
        
        func resetFilters() {
            setBirthdates()
            orderType = .nameASC
        }
        
        func setBirthdates(save: Bool = false) {
            filterBeforeDate = persons.sorted(by: {
                $0.dateOfBirth ?? "" >= $1.dateOfBirth ?? ""
            }).first?.dateOfBirth?.toDate()?.addingTimeInterval(60 * 60 * 24) ?? Date.now
            
            filterAfterDate = persons.sorted(by: {
                $0.dateOfBirth ?? "" <= $1.dateOfBirth ?? ""
            }).first?.dateOfBirth?.toDate()?.addingTimeInterval(-60 * 60 * 24) ?? Date.now
            
            if save {
                minimumBeforeDate = filterBeforeDate
                maximumAfterDate = filterAfterDate
            }
        }
        
        func orderPersons() {
            switch orderType {
            case .nameASC:
                filteredPersons = filteredPersons.sorted(by: {
                    "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)"
                })
            case .nameDESC:
                filteredPersons = filteredPersons.sorted(by: {
                    "\($0.firstName) \($0.lastName)" > "\($1.firstName) \($1.lastName)"
                })
            case .dateOfBirthASC:
                filteredPersons = filteredPersons.sorted(by: {
                    $0.dateOfBirth ?? "" > $1.dateOfBirth ?? ""
                })
            case .dateOfBirthDESC:
                filteredPersons = filteredPersons.sorted(by: {
                    $0.dateOfBirth ?? "" < $1.dateOfBirth ?? ""
                })
            }
        }
        
        func updateBirthdayPersons() {
            birthdayPersons = persons.filter {
                if let components = $0.dateOfBirth?.toDate()?.get(.day, .month) {
                    let nowComponents = Date.now.get(.day, .month)
                    return nowComponents.day == components.day && nowComponents.month == components.month
                }
                return false
            }
        }
        
        func filter() {
            var filteredPersons = self.persons
            if !filterSearchQuery.isEmpty {
                filteredPersons = filteredPersons.filter { $0.getSearchString().contains(filterSearchQuery) }
            }
            
            filteredPersons = filteredPersons.filter {
                $0.dateOfBirth ?? "" > filterAfterDate.toOriginalFormattedString()
            }
            
            filteredPersons = filteredPersons.filter {
                $0.dateOfBirth ?? "" < filterBeforeDate.toOriginalFormattedString()
            }
            
            self.filteredPersons = filteredPersons
            orderPersons()
            filterCallback(true, getFilterCount())
        }
        
        func getFilterCount() -> Int {
            var count = 0
            count += maximumAfterDate == filterAfterDate ? 0 : 1
            count += minimumBeforeDate == filterBeforeDate ? 0 : 1
            return count
        }
    }
}

protocol Person: Hashable {
    var id: Int { get }
    var firstName: String { get }
    var lastName: String { get }
    var dateOfBirth: String? { get }
    var projects: [ProjectWrapper] { get }
    var imageUrl: URL? { get }
    
    func getSubtitle() -> String
    func getSearchString() -> String
    func getProjectsTitle() -> String
    func getPopulated() async -> (any Person)?
}

class DirectorPerson: Person, Hashable {
    static func == (lhs: DirectorPerson, rhs: DirectorPerson) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(dateOfBirth)
    }
    
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
        dateOfBirth?.toDate()?.toFormattedString() ?? "No Date Of Birth"
    }
    
    func getSearchString() -> String {
        firstName + " " + lastName
    }
    
    func getProjectsTitle() -> String {
        "Directed"
    }
    
    func getPopulated() async -> (any Person)? {
        await ProjectService.getDirectorById(id: self.id)?.person
    }
}

class ActorPerson: Person, Hashable {
    static func == (lhs: ActorPerson, rhs: ActorPerson) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(dateOfBirth)
    }
    
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
    
    func getProjectsTitle() -> String {
        "Played in"
    }
    
    func getPopulated() async -> (any Person)? {
        await ProjectService.getActorById(id: self.id)?.person
    }
}

enum PersonType: String {
    case actor = "Actors"
    case director = "Directors"
    
    func getPersons() async -> [any Person] {
        switch self {
        case .actor:
            return await ProjectService.getActors().compactMap { $0.person }
        case .director:
            return await ProjectService.getDirectors().compactMap { $0.person }
        }
    }
}

extension ActorsWrapper {
    var person: any Person {
        get {
            ActorPerson(self)
        }
    }
}

extension DirectorsWrapper {
    var person: any Person {
        get {
            DirectorPerson(self)
        }
    }
}
