//
//  DateFilter.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct DateFilter: View {
    @Binding var date: Date
    @State var title: String
    
    var body: some View {
        DatePicker(selection: $date, displayedComponents: .date, label: {
            Text(title)
        })
    }
}
