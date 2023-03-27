//
//  OnboardingOverlayView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 12/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingOverlayView: View {
    @Binding var activePage: Int
    @Binding var showOnboarding: Bool
    @State var animation: Namespace.ID
    @State var pageCount: Int
    
    var body: some View {
        VStack {
            if activePage < pageCount {
                HStack {
                    Spacer()
                    
                    Text("Skip")
                        .onTapGesture {
                            withAnimation {
                                showOnboarding = false
                            }
                        }
                }
                
                Spacer()
                
                HStack {
                    ProgressView(value: Float(activePage), total: Float(pageCount))
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(width: 150)
                    
                    Spacer()

                    HStack {
                        Button(action: {
                            withAnimation {
                                activePage += 1
                            }
                        }) {
                            Image(systemName: "arrow.right")
                        }.buttonStyle(CircularRedButtonStyle())
                            .matchedGeometryEffect(id: "Button", in: animation)
                    }.padding()
                }
            } else {
                VStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showOnboarding = false
                        }
                    }) {
                        Text("Get started!")
                            .frame(width: 250, height: 50)
                    }
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(50)
                    .matchedGeometryEffect(id: "Button", in: animation)
                }.padding()
            }
        }.padding(20)
    }
}
