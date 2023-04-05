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
    @Binding var showLoader: Bool
    @EnvironmentObject var remoteConfig: RemoteConfigWrapper
    
    @State private var scrollViewHeight: CGFloat = 0
    @State private var proportion: CGFloat = 0
    @State private var proportionName: String = "scroll"
    
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
                    ProjectInformationView(
                        project: $viewModel.project,
                        posterIndex: $viewModel.posterIndex,
                        showCalendarAppointment: $viewModel.showCalendarAppointment,
                        showLoader: $showLoader
                    )
                    
                    if let overview = viewModel.project.attributes.overview {
                        Text(overview)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
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
                        VStack(alignment: .leading) {
                            QuoteView(quote: quote, quoteCaption: quoteCaption)
                        }
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
                    .modifier(ScrollReadVStackModifier(scrollViewHeight: $scrollViewHeight, proportion: $proportion, proportionName: proportionName))
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
            
            if remoteConfig.showShare {
                HeaderToolbarItem(barState: state, content: {
                    ShareLink(
                        item: URL(string: "https://mcuwidgets.page.link/\(viewModel.project.id)")!,
                        subject: Text(viewModel.project.attributes.title),
                        message: Text("\(viewModel.project.attributes.title) is shared with you! Open with MCUWidgets via: https://mcuwidgets.page.link/\(viewModel.project.id)"),
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
            }).hiddenTabBar(featureFlag: remoteConfig.hideTabbar)
            .modifier(ScrollReadScrollViewModifier(scrollViewHeight: $scrollViewHeight, proportionName: proportionName))
            .overlay(
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()

                        CircularProgressView(progress: $proportion)
                            .frame(width: 50, height: 50)
                            .background(Color.backgroundColor)
                            .overlay(
                                Text("\(Int(proportion * 100))%")
                            )
                            .clipShape(Circle())
                            .offset(y: 75)
                            .padding()
                    }
                }
            )
    }
}

struct CircularProgressView: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.accentColor.opacity(0.5),
                    lineWidth: 5
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)

        }
    }
}
