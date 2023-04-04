//
//  ProjectListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import Foundation
import SwiftUI

struct AutoSizingSheet<Content: View>: View {
    @State var spacing: Int
    @State var padding: Bool
    var content: () -> Content
    
    @State var size: CGSize = .zero
    
    init(spacing: Int = 0, padding: Bool = false, @ViewBuilder _ content: @escaping () -> Content) {
        self.padding = padding
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometryProxy in
            VStack {
                content()
            }.background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .onAppear {
                            size = CGSize(width: 0, height: geometryProxy.size.height)
                        }
                }
            ).if(padding) { view in
                view.padding()
            }
        }.presentationDragIndicator(.visible)
            .presentationDetents([.height(size.height + 50)])
    }
}

struct ProjectListView: View {
    @State var pageType: ListPageType
    @StateObject var viewModel = ProjectListViewModel()
    @Binding var showLoader: Bool
    
    var body: some View {
        VStack{
            Text("**\(viewModel.projects.count)** \(viewModel.navigationTitle)")
                .sheet(isPresented: $viewModel.showFilters) {
                    AutoSizingSheet(spacing: 20, padding: true) {
                        Text("Filters and Sorting")
                            .font(.largeTitle)
                            .bold()
                            .padding()
                        
                        TypeFilter(typeFilters: $viewModel.typeFilters, selectedTypes: $viewModel.selectedTypes)
                        
                        if viewModel.pageType == .mcu {
                            PhaseFilter(selectedFilters: $viewModel.selectedFilters)
                        }
                        
                        // Date filters
                        DateFilter(date: $viewModel.afterDate, title: "After:")
                        
                        DateFilter(date: $viewModel.beforeDate, title: "Before:")
                        
                        OrderFilterView(orderType: $viewModel.orderType)
                        
                        Button(action: {
                            viewModel.resetFilters()
                        }, label: {
                            Text("Reset")
                        })
                    }
                }
            
            ScrollViewReader { reader in
                ZStack {
                    ScrollView {
                        LazyVGrid(columns: viewModel.columns, spacing: 20)  {
                            ForEach(viewModel.projects, id: \.id) { item in
                                NavigationLink {
                                    ProjectDetailView(
                                        viewModel: ProjectDetailViewModel(
                                            project: item
                                        ),
                                        showLoader: $showLoader
                                    )
                                } label: {
                                    PosterListViewItem(
                                        posterUrl: item.attributes.posters?.first?.posterURL ?? "",
                                        title: item.attributes.title,
                                        subTitle: item.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate",
                                        showGradient: true)
                                }.id(item.id)
                            }
                        }
                    }.searchable(text: $viewModel.searchQuery)
                        .refreshable {
                            await viewModel.refresh(force: true)
                        }.simultaneousGesture(
                            DragGesture().onChanged({ _ in
                                withAnimation {
                                    viewModel.showScroll = true
                                    viewModel.scrollCallback(true, 0)
                                }
                            })
                        )
                    
                    FloatingActionButtonOverlay(
                        buttons: [
                            OptionCircleButton(imageName: "calendar.badge.clock", clickEvent: {
                                withAnimation {
                                    reader.scrollTo(viewModel.closestDateId, anchor: .top)
                                    viewModel.scrollCallback(false, 0)
                                }
                            }, getFunction: { function in
                                viewModel.scrollCallback = function
                            }),
                            OptionCircleButton(imageName: "line.3.horizontal.decrease", clickEvent: {
                                withAnimation {
                                    viewModel.showFilters.toggle()
                                }
                            }, getFunction: { function in
                                viewModel.filterCallback = function
                            })
                        ]
                        
                    )
                }
            }
        }.navigationBarState(.compact, displayMode: .automatic)
            .onAppear{
                showLoader = true
                Task{
                    viewModel.pageType = pageType
                    await viewModel.fetchProjects()
                    showLoader = false
                }
            }.navigationTitle(viewModel.navigationTitle)
    }
}

struct FloatingActionButtonOverlay: View {
    @State var buttons: [OptionCircleButton]
    
    @State var showAll: Bool = false
    @State var spacing: CGFloat = 20.0
    
    func getTransition(_ leadingIndex: Int, _ trailingIndex: Int) -> AnyTransition {
        .asymmetric(
            insertion: .opacity.animation(.spring().delay(0.1 * Double(leadingIndex))),
            removal: .opacity.animation(.spring().delay(0.1 * Double(trailingIndex)))
        )
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                VStack(spacing: spacing) {
                    Spacer()
                    
                    if showAll {
                        ForEach(Array(buttons.enumerated()), id: \.offset) { button in
                            button.1
                                .transition(getTransition(buttons.count - 1 - button.0, button.0))
                        }
                    }
                    
                    Image(systemName: showAll ? "xmark" : "ellipsis")
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                showAll.toggle()
                            }
                        }
                }
                .padding(20)
            }
        }
    }
}

struct OptionCircleButton: View {
    @State var visible: Bool = true
    @State var count: Int = 0
    @State var imageName: String
    var clickEvent: () -> Void
    var getFunction: (@escaping (Bool, Int) -> Void) -> Void
    
    var body: some View {
        Image(systemName: imageName)
            .multilineTextAlignment(.center)
            .frame(width: 50, height: 50)
            .background(Color.accentColor)
            .clipShape(Circle())
            .if(count > 0) { view in
                view.overlay {
                    Text("\(count)")
                        .bold()
                        .padding(10)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .offset(x: 20, y: 20)
                }
            }
            .if(!visible) { view in
                view.hidden()
            }.onTapGesture {
                clickEvent()
            }.onAppear {
                getFunction(update)
            }
    }
    
    func update(visible: Bool, count: Int) {
        self.visible = visible
        self.count = count
    }
}

struct PosterListViewItem: View {
    @State var posterUrl: String
    @State var title: String
    @State var subTitle: String
    @State var showGradient: Bool = true
    
    var body: some View {
        ZStack {
            ImageSizedView(url: posterUrl, showGradient: showGradient)
            
            VStack {
                Spacer()
                
                VStack {
                    Text(title)
                        .font(Font.headline.bold())
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(subTitle)
                        .font(Font.body.italic())
                    
                }
            }.padding(.horizontal, 20)
                .padding(.bottom)
        }.foregroundColor(.white)
            .shadow(color: Color(uiColor: UIColor.white.withAlphaComponent(0.3)), radius: 5)
    }
}

struct OrderFilterView<T: RawRepresentable & CaseIterable>: View where T.RawValue == String {
    @Binding var orderType: T
    
    var body: some View {
        HStack {
            Text("Order by:")
            
            Spacer()
            
            Menu(content: {
                let allCases = T.allCases as? [T]
                if let allCases {
                    ForEach(allCases, id: \.self.rawValue){ (item: T) in
                        Button(item.rawValue, action: {
                            orderType = item
                        })
                    }
                }
            }, label: {
                HStack {
                    Text("\(String(describing: orderType.rawValue))")
                }.foregroundColor(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.filterGray)
                    .cornerRadius(8)
            })
        }
    }
}

struct FilterToolbarButton: View {
    @Binding var showFilters: Bool
    
    var body: some View {
        Button {
            withAnimation {
                showFilters.toggle()
            }
        } label: {
            HStack {
                Text("Filters")
                Image(systemName: showFilters ? "xmark" : "line.3.horizontal.decrease")
                    .frame(width: 24, height: 24)
            }
        }.tint(.accentColor)
            .foregroundColor(.accentColor)
            .navigationBarState(.compact, displayMode: .automatic)
    }
}



struct TypeFilter: View {
    @Binding var typeFilters: [ProjectType]
    @Binding var selectedTypes: [ProjectType]
    
    var body: some View {
        HStack {
            Text("Type: ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(typeFilters, id: \.rawValue) { type in
                        Text(type.toString())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(selectedTypes.contains(type) ? Color.accentColor : Color.filterGray)
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedTypes.contains(type),
                                   let index = selectedTypes.firstIndex(of: type) {
                                    selectedTypes.remove(at: index)
                                } else {
                                    selectedTypes.append(type)
                                }
                            }
                    }
                }
            }
        }
    }
}

struct PhaseFilter: View {
    @Binding var selectedFilters: [Phase]
    
    var body: some View {
        HStack {
            Text("Phase: ")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Phase.allCases, id: \.rawValue) { phase in
                        Text(phase.rawValue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 7)
                            .background(selectedFilters.contains(phase) ? Color.accentColor : Color.filterGray)
                            .cornerRadius(8)
                            .onTapGesture {
                                if selectedFilters.contains(phase),
                                   let index = selectedFilters.firstIndex(of: phase) {
                                    selectedFilters.remove(at: index)
                                } else {
                                    selectedFilters.append(phase)
                                }
                            }
                    }
                }
            }
        }
    }
}

struct DateFilter: View {
    @Binding var date: Date
    @State var title: String
    
    var body: some View {
        DatePicker(selection: $date, displayedComponents: .date, label: {
            Text(title)
        })
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}
