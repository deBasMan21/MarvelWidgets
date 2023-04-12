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
