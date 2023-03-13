//
//  OnboardingPageFiveView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI
import UIKit

struct OnboardingPageFiveView: View {
    @State var selectedImage: String? = UIApplication.shared.alternateIconName
    @State var icons = [
        AppIcon(
            imageName: "AppIconLargeLight",
            appIconName: nil
        ),
        AppIcon(
            imageName: "AppIconLargeDark",
            appIconName: "AppIcon1"
        )
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("App Icon")
                .font(.largeTitle)
                .bold()
            
            Text("You can choose your app icon. By default the light mode is selected.")
            
            HStack(alignment: .top) {
                Spacer()
                
                ForEach(icons) { icon in
                    VStack {
                        Image(icon.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75)
                            .cornerRadius(20)
                            .shadow(color: Color.foregroundColor.withAlphaComponent(0.25), radius: 3)
                        
                        if selectedImage == icon.appIconName {
                            Text("Selected")
                        }
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
}
