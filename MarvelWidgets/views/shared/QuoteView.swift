//
//  QuoteView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 18/03/2023.
//

import Foundation
import SwiftUI

struct QuoteView: View {
    @State var quote: String
    @State var quoteCaption: String
    
    var body: some View {
        HStack {
            Image(systemName: "quote.bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(.accentColor)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(quote)
                    .frame(maxHeight: 40)
                    .font(.system(size: 50))
                    .minimumScaleFactor(0.01)
                    .lineLimit(2)
                    .bold()
                
                Text(quoteCaption)
                    .font(.caption)
                    .italic()
            }
            
            Spacer()
        }.padding()
    }
}
