//
//  ActorListPageView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI
import ScrollViewIfNeeded

struct PersonListPageView: View {
    @StateObject var viewModel = ViewModel()
    
    @State var navigationPath = NavigationPath()
    
    var body: some View {
        VStack {
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
                    }
                }.searchable(text: $viewModel.filterSearchQuery)
                    .refreshable {
                        await viewModel.getPersons()
                    }
                
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
            }
        }.onAppear {
            Task {
                await viewModel.getPersons()
            }
        }.navigationTitle("Persons")
            .sheet(isPresented: $viewModel.showSheet, content: {
                getSheetView()
            }).showTabBar()
            .sheet(isPresented: $viewModel.showFilters) { getFilterView() }
            .toolbar(content: {
                NavigationLink(
                    destination: WidgetSettingsView()
                ) {
                    Image(systemName: "gearshape.fill")
                }
            })
    }
    
    func getView(actorObj: any Person) -> some View {
        PersonDetailView(
            person: actorObj,
            inSheet: true,
            onDisappearCallback: {
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        self.viewModel.detents.remove(.large)
                    })
                }
            }
        )
    }
    
    func getSheetView() -> some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Text("Today's birthday")
                    .font(.largeTitle)
                    .bold()
                
                ScrollView {
                    VStack {
                        LazyVGrid(columns: viewModel.columns, spacing: 20) {
                            ForEach(viewModel.birthdayPersons, id: \.id) { actorObj in
                                VStack {
                                    Button(action: {
                                        viewModel.detents.insert(.large)
                                        viewModel.sheetHeight = .large
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                                            self.viewModel.detents.remove(.medium)
                                        })
                                        
                                        Task {
                                            navigationPath.append(actorObj)
                                        }
                                    }, label: {
                                        PosterListViewItem(
                                            posterUrl: actorObj.imageUrl?.absoluteString ?? "",
                                            title: "\(actorObj.firstName) \(actorObj.lastName)",
                                            subTitle: "\(actorObj.dateOfBirth?.toDate()?.calculateAge() ?? 0) Years old"
                                        )
                                    }).onAppear {
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
                                }
                            }
                        }
                    }.navigationDestination(for: ActorPerson.self, destination: { actorObj in
                        getView(actorObj: actorObj)
                    }).navigationDestination(for: DirectorPerson.self, destination: { actorObj in
                        getView(actorObj: actorObj)
                    })
                }
                
                Spacer()
            }.padding()
        }.presentationDetents(viewModel.detents, selection: $viewModel.sheetHeight)
            .presentationDragIndicator(.visible)
    }
    
    func getFilterView() -> some View {
        ScrollViewIfNeeded {
            VStack {
                Text("Filters and Sorting")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                DateFilter(date: $viewModel.filterAfterDate, title: "Born after:")
                
                DateFilter(date: $viewModel.filterBeforeDate, title: "Born before:")
                
                OrderFilterView(orderType: $viewModel.orderType)
                
                Button(action: {
                    Task {
                        await viewModel.resetFilters()
                    }
                }, label: {
                    Text("Reset")
                })
            }.padding(.horizontal)
        }.presentationDetents([.medium])
            .presentationDragIndicator(.visible)
    }
}
