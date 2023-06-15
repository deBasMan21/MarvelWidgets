//
//  OnboardingView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 03/03/2023.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Namespace var animation
    @Binding var showOnboarding: Bool
    @State var activePage: Int = 1
    @State var pages: [(Int, any View, any View, SpacerPosition)]
    
    init(showOnboarding: Binding<Bool>) {
        self._showOnboarding = showOnboarding
        
        var pages: [(Int, any View, any View, SpacerPosition)] = [
            (1, OnboardingPageOneView(), OnboardingPageOneHeader(), .middle),
            (2, OnboardingPageTwoView(), OnboardingPageTwoHeader(), .middle),
            (3, OnboardingPageThreeView(), OnboardingPageThreeHeader(), .middle)
        ]
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            pages.append(
                (4, OnboardingPageFiveView(), OnboardingPageFiveHeader(), .middle)
            )
        }
        
        pages.append(
            (pages.count + 1, OnboardingPageFourView(), OnboardingPageFourHeader(), .none)
        )
        
        self.pages = pages
    }
    
    var body: some View {
        VStack {
            TabView(selection: $activePage.animation()) {
                ForEach(pages, id: \.0) { page in
                    OnboardingPageContainer(spacerPosition: page.3) {
                        AnyView(page.1)
                    } header: {
                        AnyView(page.2)
                    }.tabItem {
                        EmptyView()
                    }.tag(page.0)
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
        }.overlay(
            OnboardingOverlayView(
                activePage: $activePage,
                showOnboarding: $showOnboarding,
                animation: animation,
                pageCount: pages.count
            )
        ).background(Color.accentGray)
    }
}
