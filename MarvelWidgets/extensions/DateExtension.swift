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
}
