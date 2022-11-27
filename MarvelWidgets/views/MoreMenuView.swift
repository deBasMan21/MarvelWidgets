//
//  MoreMenuView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 27/11/2022.
//

import SwiftUI

struct MoreMenuView: View {
    @Binding var showLoader: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProjectListView(otherType: .fox, showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Fox", systemImage: "film")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProjectListView(otherType: .defenders, showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Defenders", systemImage: "film")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProjectListView(otherType: .sony, showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Sony films", systemImage: "film")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProjectListView(otherType: .marvelTelevision, showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Marvel television", systemImage: "film")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ProjectListView(otherType: .marvelOther, showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Marvel other", systemImage: "film")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            DirectorListPageView(showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Directors", systemImage: "person.fill")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            ActorListPageView(showLoader: $showLoader)
                        } label: {
                            HStack {
                                Label("Actors", systemImage: "person.fill")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            InstagramView()
                        } label: {
                            HStack {
                                Label("Latest news (twitter @themcutimes)", systemImage: "newspaper.fill")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        Divider()
                    }
                    
                    VStack(alignment: .leading) {
                        NavigationLink {
                            WidgetSettingsView()
                        } label: {
                            HStack {
                                Label("Settings", systemImage: "gearshape")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    
                    Spacer()
                }.padding()
            }.navigationTitle("More")
        }
    }
}
