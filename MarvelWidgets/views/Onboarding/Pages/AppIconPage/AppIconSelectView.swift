//
//  AppIconSelectView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI
import UIKit

struct AppIconSelectView: View {
    @State var selectedImage: String? = UIApplication.shared.alternateIconName
    @State var icons = [
        AppIcon(
            imageName: "AppIconLargeLight",
            appIconName: nil,
            visibleName: "Light"
        ),
        AppIcon(
            imageName: "AppIconLargeDark",
            appIconName: "AppIcon1",
            visibleName: "Dark"
        )
    ]
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            
            ForEach(icons) { icon in
                VStack {
                    Text(icon.visibleName)
                        .bold()
                    
                    Image(icon.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75)
                        .cornerRadius(20)
                        .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
                        .if(selectedImage == icon.appIconName, transform: { view in
                            view.overlay (
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.green)
                                    .frame(width: 40, height: 40)
                                    .background(Color.backgroundColor)
                                    .clipShape(Circle())
                            )
                        })
                }.onTapGesture {
                    if selectedImage != icon.appIconName {
                        selectedImage = icon.appIconName
                        icon.setIconActive()
                    }
                }
                
                Spacer()
            }
        }
    }
}
