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
    @State var showTabBar = false
    
    var body: some View {
        VStack {
            if let projects = projects {
                SwipingView(projects: projects, navigateBackCallback: backToHome)
                    .if(showTabBar) { view in
                        view.showTabBar()
                    }.if(!showTabBar) { view in
                        view.hiddenTabBar()
                    }.onAppear {
                        showTabBar = false
                    }
            } else {
                ProgressView()
            }
        }.task {
            self.projects = await RecommendationService.getRecommendations(page: 1)
        }
    }
    
    func backToHome() {
        showTabBar = true
        
        Task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    activeTab = 0
                }
            }
        }
    }
}

struct SwipingView: View {
    @State var currentProjects: [any SwipingContent]
    @State var index: Int
    @State var pageIndex: Int = 1
    
    var navigateBackCallback: () -> Void
    
    init(projects: [any SwipingContent], navigateBackCallback: @escaping () -> Void) {
        self.navigateBackCallback = navigateBackCallback
        self._currentProjects = State(wrappedValue: projects)
        self._index = State(wrappedValue: projects.count - 1)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                ForEach($currentProjects, id: \.uuid) { project in
                    ZStack {
                        if let url = URL(string: project.imageUrl.wrappedValue) {
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
                        
                        VStack(spacing: 20) {
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                NavigationLink(destination: project.wrappedValue.getDetailView()) {
                                    HStack {
                                        Text(project.title.wrappedValue)
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
                                
                                ExpandableText(text: project.wrappedValue.description)
                            }
                            
                            VStack(spacing: 0) {
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
                            .padding(.bottom, 20)
                            .frame(width: UIScreen.main.bounds.width)
                    }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                }
                
                Spacer()
            }.snappingScrollView(amount: currentProjects.count, height: UIScreen.main.bounds.height, activeIndex: $index, refreshCallback: {
                return 0
            }, fetchNextCallback: {
                pageIndex += 1
                let result = await RecommendationService.getRecommendations(page: pageIndex)
                currentProjects.append(contentsOf: result)
                return result.count
            })
            
            VStack {
                HStack {
                    Button(action: {
                        navigateBackCallback()
                    }) {
                        HStack {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                            
                            Text("Close")
                        }.foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }.padding(EdgeInsets(top: 80, leading: 25, bottom: 0, trailing: 25))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
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
        self.imageUrl = project.attributes.posters?.first?.posterURL ?? ""
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
            }.foregroundColor(expanded ? Color.white : Color.gray)
    }
}