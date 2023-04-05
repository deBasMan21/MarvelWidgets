//
//  ActorListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct PersonListPageView: View {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
    init(type: PersonType) {
        self._viewModel = StateObject(wrappedValue: ViewModel(personType: type))
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
                                NavigationLink(destination: PersonDetailView(person: actorObj)) {
                                    PosterListViewItem(
                                        posterUrl: actorObj.imageUrl?.absoluteString ?? "",
                                        title: "\(actorObj.firstName) \(actorObj.lastName)",
                                        subTitle: actorObj.getSubtitle()
                                    )
                                }
                            }
                        }
                    }.modifier(ScrollReadVStackModifier(scrollViewHeight: $viewModel.scrollViewHeight, proportion: $viewModel.proportion, proportionName: viewModel.proportionName)
                    )
                }.searchable(text: $viewModel.filterSearchQuery)
                
                FloatingActionButtonOverlay(
                    buttons: [
                        OptionCircleButton(imageName: "birthday.cake", clickEvent: {
                            withAnimation {
                                viewModel.sheetHeight = .medium
                                viewModel.showSheet = true
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
            }.modifier(ScrollReadScrollViewModifier(scrollViewHeight: $viewModel.scrollViewHeight, proportionName: viewModel.proportionName))
            
            ProgressView(value: viewModel.proportion, total: 1)
        }.onAppear {
            Task {
                await viewModel.getPersons()
            }
        }.navigationTitle(viewModel.personType.rawValue)
            .sheet(isPresented: $viewModel.showSheet, content: {
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
                                                    onDisappearCallback: {
                                                        withAnimation {
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                                self.viewModel.detents.remove(.large)
                                                            })
                                                        }
                                                    },
                                                    inSheet: true
                                                ), isActive: binding(for: "\(actorObj.id)")) {
                                                    EmptyView()
                                                }.onAppear {
                                                    withAnimation {
                                                        viewModel.detents.insert(.medium)
                                                        viewModel.sheetHeight = .medium
                                                    }
                                                }.onDisappear {
                                                    withAnimation {
                                                        viewModel.detents.insert(.large)
                                                        viewModel.sheetHeight = .large
                                                        
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                            self.viewModel.detents.remove(.medium)
                                                        })
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    viewModel.detents.insert(.large)
                                                    viewModel.sheetHeight = .large
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                                        self.viewModel.detents.remove(.medium)
                                                    })
                                                    
                                                    Task {
                                                        viewModel.personDetailId["\(actorObj.id)"] = true
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
                }.presentationDetents(viewModel.detents, selection: $viewModel.sheetHeight)
                    .presentationDragIndicator(.visible)
            }).showTabBar(featureFlag: remoteConfig.hideTabbar)
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.viewModel.personDetailId[key, default: false] },
            set: { self.viewModel.personDetailId[key] = $0 })
    }
}
