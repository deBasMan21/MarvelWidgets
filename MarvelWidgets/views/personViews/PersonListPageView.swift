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
    @StateObject var viewModel: ViewModel
    
    @State var navigationPath = NavigationPath()
    
    init(type: PersonType) {
        self._viewModel = StateObject(wrappedValue: ViewModel(personType: type))
    }
    
    var body: some View {
        VStack {
            Text("**\(viewModel.filteredPersons.count)** \(viewModel.personType.rawValue)")
                .sheet(isPresented: $viewModel.showFilters) {
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
            }.modifier(ScrollReadScrollViewModifier(scrollViewHeight: $viewModel.scrollViewHeight, proportionName: viewModel.proportionName))
            
            ProgressView(value: viewModel.proportion, total: 1)
        }.onAppear {
            Task {
                await viewModel.getPersons()
            }
        }.navigationTitle(viewModel.personType.rawValue)
            .sheet(isPresented: $viewModel.showSheet, content: {
                getSheetView()
            }).showTabBar()
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
}
