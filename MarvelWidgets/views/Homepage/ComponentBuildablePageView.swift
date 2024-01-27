//
//  ComponentBuildablePageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/01/2024.
//

import Foundation
import SwiftUI

struct ComponentBuildablePageView: View {
    @State var components: [HomepageComponent]
    
    var body: some View {
        VStack(spacing: 40) {
            ForEach(components) { component in
                switch component {
                case .highlight(let component):
                    HighlightComponentView(highlightComponent: component)
                    
                case .text(let component):
                    TextComponentView(textComponent: component, style: TextStyle(font: nil, color: nil))
                    
                case .youtube(let component):
                    YoutubeComponentView(title: component.title, url: component.embedUrl)
                    
                case .title(let component):
                    TitleComponentView(component: component)
                    
                case .horizontalList(let component):
                    HorizontalListComponentView(component: component)
                    
                case .verticalList(let component):
                    VerticalListComponentView(component: component)
                    
                case .spotify(let component):
                    SpotifyComponentView(component: component)
                
                case .nytReview(let component):
                    NytReviewComponentView(component: component)
                    
                case .divider(let component):
                    DividerComponentView(component: component)
                    
                case .headerWidget(let component):
                    HeaderWidgetComponentView(component: component)
                    
                case .notificationDialog(let component):
                    NotificationsDialogComponentView(component: component)
                    
                case .pageLink(let component):
                    PageLinkComponentView(component: component)
                    
                case .none:
                    EmptyView()
                }
            }
        }.padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width)
    }
}
