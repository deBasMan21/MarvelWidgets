//
//  SwipingView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 03/06/2023.
//

import Foundation
import SwiftUI
import Kingfisher

struct SwipingParentView: View {
    @Binding var activeTab: Int
    @State var projects: [any SwipingContent]? = nil
    
    var body: some View {
        VStack {
            if let projects = projects {
                SwipingView(projects: projects)
            } else {
                ProgressView()
            }
        }.task {
            self.projects = await RecommendationService.getRecommendations(page: 1)
        }
    }
}

struct SwipingView: View {
    @State var currentProjects: [any SwipingContent]
    @State var index: Int
    @State var pageIndex: Int = 1
    
    init(projects: [any SwipingContent]) {
        self._currentProjects = State(wrappedValue: projects)
        self._index = State(wrappedValue: projects.count - 1)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach($currentProjects, id: \.uuid) { project in
                        SwipingPageView(project: project, index: $index, size: proxy.size)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                }.scrollTargetLayout()
            }.scrollTargetBehavior(.viewAligned(limitBehavior: .always))
                .defaultScrollAnchor(.topLeading)
                .refreshable {
                    self.currentProjects = await RecommendationService.getRecommendations(page: 1)
                }
        }.ignoresSafeArea(edges: [.top])
            .showTabBar()
            .scrollIndicators(.hidden)
    }
}

struct SwipingPageView: View {
    @Binding var project: any SwipingContent
    @Binding var index: Int
    @State var size: CGSize
    
    var body: some View {
        ZStack {
            if let url = URL(string: project.imageUrl) {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [
                                    Color(uiColor: .white.withAlphaComponent(0)),
                                    .black
                                ]
                            ),
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    }
                    
            }
            
            VStack(spacing: 10) {
                Spacer()
                
                VStack(alignment: .leading) {
                    NavigationLink(destination: project.getDetailView()) {
                        HStack {
                            Text(project.title)
                                .font(.title)
                                .bold()
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("Details")
                                .bold()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background {
                                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                                        .fill(Color.clear)
                                        .border(Color.white, width: 2)
                                    
                                }.cornerRadius(5)
                        }.foregroundColor(.white)
                    }
                    
                    ExpandableText(text: project.description)
                }
                
                VStack {
                    Text("More")
                        .font(.system(size: 12))
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10)
                }.onTapGesture {
                    index += 1
                }
            }.padding(10)
                .frame(width: size.width, height: size.height)
        }.frame(width: size.width, height: size.height)
    }
}

protocol SwipingContent: Identifiable {
    var uuid: UUID { get set }
    var title: String { get set }
    var description: String { get set }
    var imageUrl: String { get set }
    
    func getDetailView() -> AnyView
}

class ProjectSwipingContent: SwipingContent {
    var uuid: UUID
    var title: String
    var description: String
    var imageUrl: String
    
    private let project: ProjectWrapper
    
    init(project: ProjectWrapper) {
        self.uuid = UUID()
        self.title = project.attributes.title
        self.description = project.attributes.overview ?? ""
        self.imageUrl = project.attributes.getPosterUrls().first ?? ""
        self.project = project
    }
    
    func getDetailView() -> AnyView {
        return AnyView(
            ProjectDetailView(
                viewModel: ProjectDetailViewModel(
                    project: self.project
                ),
                inSheet: false
            )
        )
    }
}

class PersonSwipingContent: SwipingContent {
    var uuid: UUID
    var title: String
    var description: String
    var imageUrl: String
    
    private let person: any Person
    
    init(person: any Person) {
        self.uuid = UUID()
        self.title = "\(person.firstName) \(person.lastName)"
        self.description = "This actor plays the role of \(person.getSubtitle())"
        self.imageUrl = person.imageUrl?.absoluteString ?? ""
        self.person = person
    }
    
    func getDetailView() -> AnyView {
        return AnyView(
            PersonDetailView(person: person)
        )
    }
}


struct ExpandableText: View {
    @State var text: String
    @State var lineLimit: Int = 2
    @State var expanded = false
    
    var body: some View {
        Text(text)
            .lineLimit(expanded ? nil : lineLimit)
            .onTapGesture {
                withAnimation {
                    expanded.toggle()
                }
            }.foregroundColor(Color.gray)
            .onDisappear {
                expanded = false
            }
    }
}
