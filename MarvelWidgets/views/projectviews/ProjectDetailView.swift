//
//  ProjectDetailView.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 11/08/2022.
//

import SwiftUI
import Kingfisher
import SwiftUINavigationHeader
import FirebaseRemoteConfig

struct ProjectDetailView: View {
    @StateObject var viewModel: ProjectDetailViewModel
    @State var inSheet: Bool
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
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
            VStack(spacing: 30) {
                    ProjectInformationView(
                        project: $viewModel.project,
                        posterIndex: $viewModel.posterIndex,
                        showCalendarAppointment: $viewModel.showCalendarAppointment
                    )
                    
                    if let overview = viewModel.project.attributes.overview {
                        Text(overview)
                            .multilineTextAlignment(.center)
                    }
                    
                    if let episodes = viewModel.project.attributes.episodes, episodes.count > 0 {
                        SeasonEpisodeView(episodes: episodes)
                    }
                    
                    if let seasons = viewModel.project.attributes.seasons, seasons.count > 0 {
                        SeasonView(seasons: seasons, seriesTitle: viewModel.project.attributes.title)
                    }
                    
                    if let quote = viewModel.project.attributes.quote, let quoteCaption = viewModel.project.attributes.quoteCaption {
                        VStack(alignment: .leading) {
                            QuoteView(quote: quote, quoteCaption: quoteCaption)
                        }
                    }
                    
                    if let actors = viewModel.project.attributes.actors, actors.data.count > 0 {
                        ActorListView(
                            actors: actors.data
                        )
                    }
                    
                    VStack(spacing: 30) {
                        if let rating = viewModel.project.attributes.rating {
                            RatingView(
                                rating: rating,
                                voteCount: viewModel.project.attributes.voteCount ?? 0
                            )
                        }
                        
                        if let reviewTitle = viewModel.project.attributes.reviewTitle,
                           let reviewSummary = viewModel.project.attributes.reviewSummary,
                           let reviewCopyright = viewModel.project.attributes.reviewCopyright,
                           remoteConfig.showReview {
                            ReviewView(
                                reviewTitle: reviewTitle,
                                reviewSummary: reviewSummary,
                                reviewCopyright: reviewCopyright
                            ).padding(.horizontal)
                                .padding(.bottom)
                        }
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
                        }.padding()
                            .background(Color.accentGray)
                            .cornerRadius(10)
                    }
                    
                    if let relatedProjects = viewModel.project.attributes.relatedProjects, relatedProjects.data.count > 0 {
                        RelatedProjectsView(relatedProjects: relatedProjects)
                    }
                }.padding(.top, -60)
                .padding(.bottom, -30)
                .padding(.horizontal, 20)
        }, toolbar: { state in
            HeaderToolbarItem(barState: state, content: {
                VStack {
                    if viewModel.project.attributes.disneyPlusUrl != nil {
                        Image(systemName: "play.fill")
                    } else {
                        EmptyView()
                    }
                }.onTapGesture {
                    if let dpUrl = viewModel.project.attributes.disneyPlusUrl, let dpUrl = URL(string: dpUrl) {
                        UIApplication.shared.open(dpUrl)
                    }
                }
            })
            
            if remoteConfig.showShare {
                HeaderToolbarItem(barState: state, content: {
                    ShareLink(
                        item: viewModel.project.getUrl()!,
                        subject: Text(viewModel.project.attributes.title),
                        message: Text("\(viewModel.project.attributes.title) is shared with you! Open with MCUWidgets via: \(viewModel.project.getUrl()?.absoluteString ?? "Link is unavailable")"),
                        preview: SharePreview(
                            viewModel.project.attributes.title,
                            image: Image(UIApplication.shared.alternateIconName ?? "AppIcon")
                        )
                    )
                })
            }
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
            }).hiddenTabBar(featureFlag: remoteConfig.hideTabbar, inSheet: inSheet)
    }
}
