//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher
import SwiftUIPager
import SwiftUINavigationHeader

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    @Binding var showLoader: Bool
    
    var body: some View {
        NavigationHeaderContainer(bottomFadeout: true, headerAlignment: .center, header: {
            if let posterUrl = viewModel.posterURL, !posterUrl.isEmpty {
                NavigationLink(destination: FullscreenImageView(url: posterUrl)) {
                    KFImage(URL(string: posterUrl)!)
                        .resizable()
                        .scaledToFill()
                        .gesture(DragGesture().onEnded { value in
                            viewModel.swipeImage(direction: viewModel.detectDirection(value: value))
                        })
                }
            }
        }, content: {
                VStack {
                    ProjectInformationView(project: $viewModel.project, posterIndex: $viewModel.posterIndex, showCalendarAppointment: $viewModel.showCalendarAppointment, showLoader: $showLoader)
                    
                    
                    VStack {
                        if let rating = viewModel.project.attributes.rating {
                            VStack {
                                FiveStarView(rating: (rating / 2), color: .accentColor, backgroundColor: .accentGray)
                                    .frame(width: 100, height: 30)
                                
                                Text("\(rating.roundToString(places: 1))/10 (\(viewModel.project.attributes.voteCount ?? 0) votes)")
                                    .font(.caption)
                                    .italic()
                            }
                        }
                        
                        if let overview = viewModel.project.attributes.overview {
                            Text(overview)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }.padding()
                    
                    if let seasons = viewModel.project.attributes.seasons, seasons.count > 0 {
                        SeasonView(seasons: seasons, seriesTitle: viewModel.project.attributes.title)
                            .padding()
                    }
                    
                    if let actors = viewModel.project.attributes.actors, actors.data.count > 0 {
                        ActorListView(
                            actors: actors.data,
                            showLoader: $showLoader
                        ).padding()
                    }
                    
                    if let quote = viewModel.project.attributes.quote, let quoteCaption = viewModel.project.attributes.quoteCaption {
                        QuoteView(quote: quote, quoteCaption: quoteCaption)
                    }
                    
                    if let trailers = viewModel.project.attributes.trailers, trailers.count > 0 {
                        TrailersView(trailers: trailers)
                    }
                    
                    if viewModel.tableViewContent.count > 0 {
                        VStack {
                            ForEach(viewModel.tableViewContent, id: \.0) { tuple in
                                VStack {
                                    AnyView(tuple.1)
                                    
                                    if tuple.0 < viewModel.tableViewContent.count - 1 {
                                        Divider()
                                    }
                                }
                            }
                        }.padding(10)
                            .background(Color.accentGray)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    if let relatedProjects = viewModel.project.attributes.relatedProjects, relatedProjects.data.count > 0 {
                        RelatedProjectsView(relatedProjects: relatedProjects, showLoader: $showLoader)
                    }
                    
                    if viewModel.showBottomLoader {
                        ProgressView()
                            .padding()
                    }
                }.offset(x: 0, y: -60)
        }, toolbar: { state in
            HeaderToolbarItem(barState: state, content: {
                VStack {
                    if viewModel.project.attributes.disneyPlusUrl != nil {
                        Image(systemName: "play.fill")
                    } else {
                        EmptyView()
                    }
                }.onTapGesture {
                    if let dpUrl = viewModel.project.attributes.disneyPlusUrl {
                        UIApplication.shared.open(URL(string: dpUrl)!)
                    }
                }
            })
        }).baseTintColor(Color("AccentColor"))
            .headerHeight({ _ in 500 })
            .alert(isPresented: $viewModel.showCalendarAppointment, content: {
                Alert(title: Text("Calendar"),
                      message: Text("Do you want to add this project to your calendar?"),
                      primaryButton: .default(Text("Yes")) {
                            viewModel.createEventinTheCalendar()
                      },
                      secondaryButton: .cancel()
                )
            })
    }
}

struct RelatedProjectsView: View {
    @State var relatedProjects: RelatedProjects
    @Binding var showLoader: Bool
    
    var body: some View {
        VStack {
            Text("Related projects")
                .font(Font.largeTitle)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15){
                    ForEach(relatedProjects.data.sorted(by: {
                        $0.attributes.releaseDate ?? "" < $1.attributes.releaseDate ?? ""
                    }), id: \.uuid) { project in
                        NavigationLink {
                            ProjectDetailView(
                                viewModel: ProjectDetailViewModel(
                                    project: project
                                ),
                                showLoader: $showLoader
                            )
                        } label: {
                            VStack{
                                ImageSizedView(url: project.attributes.posters?.first?.posterURL ?? "")
                                
                                Text(project.attributes.title)
                                    .font(Font.headline.bold())
                                
                                Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "Unknown releasedate")
                                    .font(Font.body.italic())
                                    .foregroundColor(Color(uiColor: UIColor.label))
                            }.frame(width: 150)
                        }
                    }
                }
            }
        }.padding(.horizontal)
    }
}

struct ProjectInformationView: View {
    @Binding var project: ProjectWrapper
    @Binding var posterIndex: Int
    @Binding var showCalendarAppointment: Bool
    @Binding var showLoader: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Poster \(posterIndex + 1) of \(project.attributes.posters?.count ?? 0)")
                    .font(Font.footnote)
                    .italic()
                
                Text(project.attributes.title)
                    .font(Font.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            
            if let categoriesString = project.attributes.categories {
                HScrollView(showsIndicators: false) {
                    HStack {
                        ForEach(categoriesString.split(separator: ", ").compactMap { String($0) }, id: \.hashValue) { category in
                            Text(category)
                                .textStyle(RedChipText())
                        }
                    }
                }.padding(.bottom, 20)
            }
            
            LazyVGrid(columns: columns, alignment: .leading)  {
                HStack {
                    Image(systemName: project.attributes.type.imageString())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Type project")
                            .bold()
                            .foregroundColor(Color.accentColor)
                        
                        Text(project.attributes.type.rawValue)
                    }
                }
            
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Release date")
                            .bold()
                            .foregroundColor(Color.accentColor)
                        
                        Text(project.attributes.releaseDate?.toDate()?.toFormattedString() ?? "No release date set")
                    }
                }.onTapGesture {
                    showCalendarAppointment = true
                }
                
                if let duration = project.attributes.duration {
                    HStack {
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading)  {
                            Text("Duration")
                                .bold()
                                .foregroundColor(Color.accentColor)
                            
                            Text("\(duration) minutes")
                        }
                    }
                }
                
                if let directors = project.attributes.directors, directors.data.count > 0 {
                    ForEach(directors.data) { director in
                        NavigationLink(destination: DirectorDetailView(director: director, showLoader: $showLoader)) {
                            HStack {
                                KFImage(URL(string: director.attributes.imageURL ?? "")!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading)  {
                                    Text("Director")
                                        .bold()
                                    
                                    Text("\(director.attributes.firstName) \(director.attributes.lastName)")
                                        .lineLimit(1)
                                        .foregroundColor(Color.foregroundColor)
                                }
                            }
                        }
                    }
                }
            }
        }.padding(.horizontal, 20)
    }
}

struct QuoteView: View {
    @State var quote: String
    @State var quoteCaption: String
    
    var body: some View {
        HStack {
            Image(systemName: "quote.bubble")
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
                .foregroundColor(.accentColor)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text(quote)
                    .font(.title)
                    .bold()
                    .lineLimit(2)
                
                Text(quoteCaption)
                    .font(.caption)
                    .italic()
            }
        }
    }
}

struct TableRowView: View {
    @State var title: String
    @State var value: String
    
    var body: some View {
        HStack {
            Text(title)
            
            Spacer()
            
            Text(value)
                .bold()
                .foregroundColor(.accentColor)
        }
    }
}
