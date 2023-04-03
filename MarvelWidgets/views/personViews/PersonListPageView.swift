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
            if viewModel.showFilters {
                VStack(spacing: 20) {
                    SearchFilterView(searchQuery: $viewModel.filterSearchQuery)
                    
                    OrderFilterView(orderType: $viewModel.orderType)
                }.padding()
            }
            
            Text("**\(viewModel.filteredPersons.count)** \(viewModel.personType.rawValue)")
            
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
                }
                
                if viewModel.birthdayPersons.count > 0 && viewModel.showBirthdays {
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
                                    viewModel.showFilters.toggle()
                                }
                            }),
                            ("magnifyingglass", {
                                withAnimation {
                                    viewModel.showFilters.toggle()
                                }
                            })
                        ]
                    )
                }
            }
        }.onAppear {
            Task {
                await viewModel.getPersons()
            }
        }.navigationTitle(viewModel.personType.rawValue)
            .sheet(isPresented: $showSheet, content: {
                NavigationView {
                    VStack {
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
                        }.navigationTitle("Today's birthday")
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
