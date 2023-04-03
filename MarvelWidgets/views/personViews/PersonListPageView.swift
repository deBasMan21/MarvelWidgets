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
    @State var showSheet: Bool = false
    @State var sheetHeight: PresentationDetent = .medium
    @State var personDetailId: [String: Bool] = [:]
    
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
                    }
                }.searchable(text: $viewModel.filterSearchQuery)
                
                FloatingActionButtonOverlay(
                    buttons: [
                        ("birthday.cake", {
                            withAnimation {
                                sheetHeight = .medium
                                showSheet = true
                            }
                        }),
                        ("line.3.horizontal.decrease", {
                            withAnimation {
                                viewModel.showFilters = true
                            }
                        })
                    ]
                )
            }
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
                                                    showLoader: $showLoader
                                                ), isActive: binding(for: "\(actorObj.id)")) {
                                                    EmptyView()
                                                }.onAppear {
                                                    withAnimation {
                                                        sheetHeight = .medium
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    sheetHeight = .large
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
                }.presentationDetents([.medium, .large], selection: $sheetHeight)
                    .presentationDragIndicator(.visible)
            })
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        return .init(
            get: { self.personDetailId[key, default: false] },
            set: { self.personDetailId[key] = $0 })
    }
}
