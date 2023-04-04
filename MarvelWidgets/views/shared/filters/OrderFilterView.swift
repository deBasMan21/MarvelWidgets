//
//  OrderFilterView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 04/04/2023.
//

import Foundation
import SwiftUI

struct OrderFilterView<T: RawRepresentable & CaseIterable>: View where T.RawValue == String {
    @Binding var orderType: T
    
    var body: some View {
        HStack {
            Text("Order by:")
            
            Spacer()
            
            Menu(content: {
                let allCases = T.allCases as? [T]
                if let allCases {
                    ForEach(allCases, id: \.self.rawValue){ (item: T) in
                        Button(item.rawValue, action: {
                            orderType = item
                        })
                    }
                }
            }, label: {
                HStack {
                    Text("\(String(describing: orderType.rawValue))")
                }.foregroundColor(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.filterGray)
                    .cornerRadius(8)
            })
        }
    }
}
