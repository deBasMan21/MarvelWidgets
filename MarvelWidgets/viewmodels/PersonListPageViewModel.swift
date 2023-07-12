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
                Task {
                    await filter()
                }
            }
        }
        @Published var orderType: SortKeys = .nameASC {
            didSet {
                Task {
                    await orderPersons()
                }
            }
        }
        @Published var filterBeforeDate: Date = Date.now {
            didSet {
                Task {
                    await filter()
                }
            }
        }
        @Published var filterAfterDate: Date = Date.now {
            didSet {
                Task {
                    await filter()
                }
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
            let persons = await personType.getPersons()
            await MainActor.run {
                self.persons = persons
            }
            
            await updateBirthdayPersons()
            await setBirthdates(save: true)
            await filter()
        }
        
        @MainActor
        func resetFilters() async {
            setBirthdates()
            orderType = .nameASC
        }
        
        @MainActor
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
        
        func orderPersons() async {
            let orderedPersons = orderPersons(persons: filteredPersons)
            await setPersons(persons: orderedPersons)
        }
        
        func orderPersons(persons: [any Person]) -> [any Person] {
            let filteredPersons: [any Person]
            switch orderType {
            case .nameASC:
                filteredPersons = persons.sorted(by: {
                    "\($0.firstName) \($0.lastName)" < "\($1.firstName) \($1.lastName)"
                })
            case .nameDESC:
                filteredPersons = persons.sorted(by: {
                    "\($0.firstName) \($0.lastName)" > "\($1.firstName) \($1.lastName)"
                })
            case .dateOfBirthASC:
                filteredPersons = persons.sorted(by: {
                    $0.dateOfBirth ?? "" > $1.dateOfBirth ?? ""
                })
            case .dateOfBirthDESC:
                filteredPersons = persons.sorted(by: {
                    $0.dateOfBirth ?? "" < $1.dateOfBirth ?? ""
                })
            }
            
            return filteredPersons
        }
        
        func updateBirthdayPersons() async {
            let bdayPersons = persons.filter {
                if let components = $0.dateOfBirth?.toDate()?.get(.day, .month) {
                    let nowComponents = Date.now.get(.day, .month)
                    return nowComponents.day == components.day && nowComponents.month == components.month
                }
                return false
            }
            
            await MainActor.run {
                self.birthdayPersons = bdayPersons
            }
        }
        
        func filter() async {
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
            
            filteredPersons = orderPersons(persons: filteredPersons)
            
            await setPersons(persons: filteredPersons)

            filterCallback(true, getFilterCount())
        }
        
        @MainActor
        func setPersons(persons: [any Person]) {
            withAnimation {
                self.filteredPersons = persons
            }
        }
        
        func getFilterCount() -> Int {
            var count = 0
            count += maximumAfterDate == filterAfterDate ? 0 : 1
            count += minimumBeforeDate == filterBeforeDate ? 0 : 1
            return count
        }
    }
}
