//
//  PhaseFilter.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct PhaseFilter: View {
    @Binding var selectedFilters: [Phase]
    
    var body: some View {
        HStack {
            Text("Phase: ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Phase.allCases, id: \.rawValue) { phase in
                        Text(phase.rawValue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(selectedFilters.contains(phase) ? Color.accentColor : Color.filterGray)
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedFilters.contains(phase),
                                   let index = selectedFilters.firstIndex(of: phase) {
                                    selectedFilters.remove(at: index)
                                } else {
                                    selectedFilters.append(phase)
                                }
                            }
                    }
                }
            }
        }
    }
}
