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
}
