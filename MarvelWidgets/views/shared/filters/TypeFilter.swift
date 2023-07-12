//
//  TypeFilter.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct TypeFilter<T: RawRepresentable<String> & Equatable>: View {
    @State var title: String
    @State var values: [T]
    @Binding var selectedTypes: [T]
    
    var body: some View {
        HStack {
            Text("\(title): ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(values, id: \.rawValue) { type in
                        Text(type.rawValue)
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

