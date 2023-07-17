//
//  HorizontalProjectView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 17/07/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct HorizontalProjectView: View {
    @State var project: ProjectWrapper
    @State var inSheet: Bool
    
    var body: some View {
        NavigationLink(
            destination: ProjectDetailView(
                viewModel: ProjectDetailViewModel(
                    project: project
                ),
                inSheet: inSheet
            )
        ) {
            ZStack {
                KFImage(URL(string: project.attributes.getBackdropUrl() ?? ""))
                    .resizable()
                    .if(project.attributes.backdropUrl != nil) { view in
                        view
                            .aspectRatio(16/9, contentMode: .fill)
                    }.if(project.attributes.backdropUrl == nil) { view in
                        view
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                    }
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    .white.withAlphaComponent(0),
                                    .black.withAlphaComponent(0.75)
                                ]
                            ),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    }
                    
                VStack {
                    Spacer()
                    
                    Text(project.attributes.title)
                        .font(.title3)
                        .bold()
                    
                    Text(project.attributes.getReleaseDateString())
                        .font(.caption)
                }.padding(.bottom, 5)
            }.foregroundColor(.white)
                .cornerRadius(10)
                .clipped()
                .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.2)), radius: 10)
        }
    }
}
