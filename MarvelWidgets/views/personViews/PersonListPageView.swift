//
//  ActorListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct PersonListPageView: View {
    @Binding var showLoader: Bool
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    @State var showSheet: Bool = false
    @State var sheetHeight: PresentationDetent = .medium
    @State var personDetailId: [String: Bool] = [:]
    @State var detents: Set<PresentationDetent> = [.medium]
    
    @State private var scrollViewHeight: CGFloat = 0
    @State private var proportion: CGFloat = 0
    @State private var proportionName: String = "scroll"
    
    init(type: PersonType, showLoader: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: ViewModel(personType: type))
        self._showLoader = showLoader
    }
    
    var body: some View {
        VStack {
            Text("**\(viewModel.filteredPersons.count)** \(viewModel.personType.rawValue)")
                .sheet(isPresented: $viewModel.showFilters) {
                    AutoSizingSheet(spacing: 20, padding: true) {
                        Text("Filters and Sorting")
                            .font(.largeTitle)
                            .bold()
                        
                        DateFilter(date: $viewModel.filterAfterDate, title: "Born after:")
                        
                        DateFilter(date: $viewModel.filterBeforeDate, title: "Born before:")
                        
                        OrderFilterView(orderType: $viewModel.orderType)
                        
                        Button(action: {
                            viewModel.resetFilters()
                        }, label: {
                            Text("Reset")
                        })
                    }
                }
            
            ZStack {
                ScrollView {
                    VStack {
                        LazyVGrid(columns: viewModel.columns, spacing: 20) {
                            ForEach(viewModel.filteredPersons, id: \.id) { actorObj in
                                NavigationLink(destination: PersonDetailView(person: actorObj, showLoader: $showLoader)) {
                                    PosterListViewItem(
                                        posterUrl: actorObj.imageUrl?.absoluteString ?? "",
                                        title: "\(actorObj.firstName) \(actorObj.lastName)",
                                        subTitle: actorObj.getSubtitle()
                                    )
                                }
                            }
                        }
                    }.modifier(ScrollReadVStackModifier(scrollViewHeight: $scrollViewHeight, proportion: $proportion, proportionName: proportionName)
                    )
                }.searchable(text: $viewModel.filterSearchQuery)
                
                FloatingActionButtonOverlay(
                    buttons: [
                        OptionCircleButton(imageName: "birthday.cake", clickEvent: {
                            withAnimation {
                                sheetHeight = .medium
                                showSheet = true
                            }
                        }, getFunction: { function in
                            function(viewModel.birthdayPersons.count > 0, viewModel.birthdayPersons.count)
                        }),
                        OptionCircleButton(imageName: "line.3.horizontal.decrease", clickEvent: {
                            withAnimation {
                                viewModel.showFilters = true
                            }
                        }, getFunction: { function in
                            viewModel.filterCallback = function
                        })
                    ]
                )
            }.modifier(ScrollReadScrollViewModifier(scrollViewHeight: $scrollViewHeight, proportionName: proportionName))
            
            ProgressView(value: proportion, total: 1)
        }.onAppear {
            Task {
                await viewModel.getPersons()
            }
        }.navigationTitle(viewModel.personType.rawValue)
            .sheet(isPresented: $showSheet, content: {
                NavigationView {
                    VStack {
                        Text("Today's birthday")
                            .font(.largeTitle)
                            .bold()
                        
                        if viewModel.birthdayPersons.count > 0 {
                            ScrollView {
                                VStack {
                                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                                        ForEach(viewModel.birthdayPersons, id: \.id) { actorObj in
                                            VStack {
                                                NavigationLink(destination: PersonDetailView(
                                                    person: actorObj,
                                                    showLoader: $showLoader,
                                                    onDisappearCallback: {
                                                        withAnimation {
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                                self.detents.remove(.large)
                                                            })
                                                        }
                                                    }
                                                ), isActive: binding(for: "\(actorObj.id)")) {
                                                    EmptyView()
                                                }.onAppear {
                                                    withAnimation {
                                                        detents.insert(.medium)
                                                        sheetHeight = .medium
                                                    }
                                                }.onDisappear {
                                                    withAnimation {
                                                        detents.insert(.large)
                                                        sheetHeight = .large
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                            self.detents.remove(.medium)
                                                        })
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    detents.insert(.large)
                                                    sheetHeight = .large
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                        self.detents.remove(.medium)
                                                    })
                                                    
                                                    Task {
                                                        personDetailId["\(actorObj.id)"] = true
                                                    }
                                                }, label: {
                                                    PosterListViewItem(
                                                        posterUrl: actorObj.imageUrl?.absoluteString ?? "",
                                                        title: "\(actorObj.firstName) \(actorObj.lastName)",
                                                        subTitle: "\(actorObj.dateOfBirth?.toDate()?.calculateAge() ?? 0) Years old"
                                                    )
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            Spacer()
                            
                            Text("Oh no! It's nobodies birthday today, come back tomorrow.")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }.padding()
                }.presentationDetents(detents, selection: $sheetHeight)
                    .presentationDragIndicator(.visible)
            }).showTabBar(featureFlag: remoteConfig.hideTabbar)
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.personDetailId[key, default: false] },
            set: { self.personDetailId[key] = $0 })
    }
}
