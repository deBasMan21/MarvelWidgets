//
//  DateExtension.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 10/08/2022.
//

import Foundation

extension Date {
    func differenceInDays(from date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: date)
        let toDate = calendar.startOfDay(for: self)
        let numberOfDays = calendar.dateComponents([.day], from: fromDate, to: toDate)
                
        return numberOfDays.day!
    }
    
    func differenceInHours(from date: Date) -> Int {
        let calendar = Calendar.current
        let fromDate = calendar.startOfDay(for: date)
        let toDate = calendar.startOfDay(for: self)
        let numberOfDays = calendar.dateComponents([.day, .hour], from: fromDate, to: toDate)
        return numberOfDays.hour!
    }
    
    func differenceForWidget(from date: Date) -> String {
        let diffDays = differenceInDays(from: date)
        if diffDays < 2 {
            let diffHours = differenceInHours(from: date)
            return "\(diffHours) uur"
        }
        return "\(diffDays) dagen"
    }
    
    func toFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY"
        return formatter.string(from: self)
    }
    
    func toOriginalFormattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
    
    func calculateAge() -> Int {
        let now = Date()
        let calendar = Calendar.current

        let ageComponents = calendar.dateComponents([.year], from: self, to: now)
        return ageComponents.year!
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
