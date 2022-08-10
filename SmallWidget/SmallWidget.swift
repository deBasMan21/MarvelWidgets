//
//  SmallWidget.swift
//  SmallWidget
//
//  Created by Bas Buijsen on 10/08/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> UpcomingProjectEntry {
        UpcomingProjectEntry(date: Date(), configuration: ConfigurationIntent(), upcomingProject: Movie(id: 0, title: "temp", releaseDate: "", boxOffice: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: ""))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        let entry = UpcomingProjectEntry(date: Date(), configuration: configuration, upcomingProject: Movie(id: 0, title: "temp", releaseDate: "", boxOffice: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: ""))
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [UpcomingProjectEntry] = []
            let upcomingProjects = await MovieService.getMoviesChronologically()
            
            LogService.log("here", in: self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            var smallestDateProject : Movie? = nil
            for item in upcomingProjects {
                let date = formatter.date(from: item.releaseDate)
                let temp = formatter.date(from: smallestDateProject?.releaseDate ?? "3000-01-01")
                
                if let date = date, let temp = temp, date > Date.now && date < temp {
                    smallestDateProject = item
                }
            }
            
            if let smallestDateProject = smallestDateProject {
                entries.append(UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: smallestDateProject))
            } else {
                entries.append(UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: upcomingProjects[0]))
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct UpcomingProjectEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let upcomingProject: Movie
}

struct SmallWidgetUpcoming : View {
    var entry: Provider.Entry
    @State var image: Image = Image("secret wars")

    var body: some View {
        ZStack{
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
            HStack{
                VStack{
                    Spacer()
                    
                    Text(entry.upcomingProject.title)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black, radius: 5)
                        .font(Font.headline.weight(.bold))
                    
                    Spacer()
                    
                    Text("\(entry.upcomingProject.releaseDate.toDate()?.differenceInDays(from: Date.now) ?? -1) dagen")
                        .padding(.bottom, 50)
                }
            }
        }
        .onAppear{
            downloadImage()
        }
        
    }
    
    func downloadImage() {
        guard entry.upcomingProject.coverURL != "" else { return }
        image = ImageHelper.downloadImage(from: entry.upcomingProject.coverURL)
    }
}

@main
struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SmallWidgetUpcoming(entry: entry)
        }
        .configurationDisplayName("Upcoming marvel")
        .description("This widget shows the first upcoming marvel project with a countdown.")
        .supportedFamilies([.systemSmall])
    }
}
