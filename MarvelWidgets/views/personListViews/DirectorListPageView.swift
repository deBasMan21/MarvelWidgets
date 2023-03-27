//
//  DirectorListView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 22/11/2022.
//

import Foundation
import SwiftUI

struct DirectorListPageView: View {
    @Binding var showLoader: Bool
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Menu(content: {
                ForEach(SortKeys.allCases, id: \.self){ item in
                    Button(item.rawValue, action: {
                        viewModel.sortDirectors(by: item)
                    })
                }
            }, label: {
                Text("Order by: **\(String(describing: viewModel.orderType.rawValue))**")
                Image(systemName: "arrow.up.arrow.down")
            })
            
            ScrollView {
                VStack {
                    LazyVGrid(columns: viewModel.columns, spacing: 20) {
                        ForEach(viewModel.directors) { director in
                            NavigationLink(destination: DirectorDetailView(director: director, showLoader: $showLoader)) {
                                VStack {
                                    ImageSizedView(url: director.attributes.imageURL ?? "")
                                    
                                    Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                }
                            }
                        }
                    }
                }
            }
            
            if viewModel.birthdayDirectors.count > 0 && viewModel.showBirthdays {
                HStack {
                    Text("Today's \nbirthday:")
                    
                    GeometryReader { geometry in
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.birthdayDirectors) { director in
                                    NavigationLink(destination: DirectorDetailView(director:  director, showLoader: $showLoader)) {
                                        VStack {
                                            Text("\(director.attributes.firstName) \(director.attributes.lastName) (\(director.attributes.dateOfBirth?.toDate()?.calculateAge() ?? 0))")
                                                .bold()
                                            
                                            Text("\(director.attributes.dateOfBirth?.toDate()?.toFormattedString() ?? "")")
                                                .foregroundColor(.white)
                                        }.padding()
                                            .background(Color.accentGray)
                                            .cornerRadius(10)
                                    }
                                }
                            }.frame(width: geometry.size.width)
                        }
                    }.frame(height: 75)
                    
                    Image(systemName: "xmark")
                        .onTapGesture {
                            withAnimation {
                                viewModel.showBirthdays = false
                            }
                        }
                }.padding(3)
            }
        }.onAppear {
            Task {
                await viewModel.getDirectors()
            }
        }.navigationTitle("Directors")
    }
}
