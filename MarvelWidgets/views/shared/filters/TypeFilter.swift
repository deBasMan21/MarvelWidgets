//
//  TypeFilter.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct TypeFilter: View {
    @Binding var typeFilters: [ProjectType]
    @Binding var selectedTypes: [ProjectType]
    
    var body: some View {
        HStack {
            Text("Type: ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(typeFilters, id: \.rawValue) { type in
                        Text(type.toString())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(selectedTypes.contains(type) ? Color.accentColor : Color.filterGray)
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedTypes.contains(type),
                                   let index = selectedTypes.firstIndex(of: type) {
                                    selectedTypes.remove(at: index)
                                } else {
                                    selectedTypes.append(type)
                                }
                            }
                    }
                }
            }
        }
    }
}

