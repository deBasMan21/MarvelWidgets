//
//  NotificationView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct NotificationView: View {
    @State var bodyText: String
    @State var image: Image
    
    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
                .cornerRadius(5)
            
            VStack(alignment: .leading) {
                Text("MCUWidgets")
                    .bold()
                
                Text(bodyText)
            }
            
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .cornerRadius(5)
        }.padding()
            .background(Color.backgroundColor)
            .cornerRadius(20)
            .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
    }
}
