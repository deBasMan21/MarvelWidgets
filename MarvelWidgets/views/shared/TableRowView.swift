//
//  TableRowView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI

struct TableRowView: View {
    @State var title: String
    @State var value: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(value)
                .bold()
                .foregroundColor(.accentColor)
        }
    }
}
