//
//  ProjectWrapperExtensions.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 09/02/2023.
//

import Foundation

extension [ProjectWrapper] {
    func getClosest() -> Int {
        if let upcoming = self.filter({ $0.attributes.releaseDate?.toDate()?.differenceInDays(from: Date.now) ?? Int.max >= 0 }).sorted(by: >).first {
            return upcoming.id
        } else if let recent = self.filter({ $0.attributes.releaseDate?.toDate()?.differenceInDays(from: Date.now) ?? Int.max <= 0 }).sorted(by: <).first {
            return recent.id
        }
        return -1
    }
}
