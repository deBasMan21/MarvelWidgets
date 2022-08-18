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
        UpcomingProjectEntry(date: Date(), configuration: WidgetTypeConfigurationIntent(), upcomingProject: Movie(projectId: 0, title: "temp", boxOffice: "", releaseDate: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil), image: Image("secret wars"))
    }

    func getSnapshot(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (UpcomingProjectEntry) -> ()) {
        let entry = UpcomingProjectEntry(date: Date(), configuration: configuration, upcomingProject: Movie(projectId: 0, title: "temp", boxOffice: "", releaseDate: "", duration: 0, overview: nil, coverURL: "", trailerURL: "", directedBy: "", phase: 0, saga: .infinitySaga, chronology: 0, postCreditScenes: 0, imdbID: "", relatedMovies: nil), image: Image("secret wars"))
        completion(entry)
    }

    func getTimeline(for configuration: WidgetTypeConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            var entries: [UpcomingProjectEntry] = []
            var upcomingProjects : [Project] = []
            
            let widgetType: WidgetType = WidgetType.getFromIndex(configuration.WidgetType.rawValue)
            
            switch widgetType {
            case .movies:
                upcomingProjects.append(contentsOf: await MovieService.getMoviesChronologically())
            case .series:
                upcomingProjects.append(contentsOf: await SeriesService.getSeriesChronologically())
            case .all:
                upcomingProjects.append(contentsOf: await MovieService.getMoviesChronologically())
                upcomingProjects.append(contentsOf: await SeriesService.getSeriesChronologically())
            case .saved:
                upcomingProjects.append(contentsOf: SaveService.getProjectsFromUserDefaults())
            }
            
            switch configuration.RandomOrNext.rawValue {
            case 2:
                entries.append(randomProject(from: upcomingProjects, with: configuration))
            default:
                entries.append(upcomingProject(from: upcomingProjects, with: configuration))
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
    
    func upcomingProject(from allProjects: [Project], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        var smallestDateProject : Project? = nil
        for item in allProjects {
            let date = formatter.date(from: item.releaseDate ?? "2000-01-01")
            let temp = formatter.date(from: smallestDateProject?.releaseDate ?? "3000-01-01")
            
            if let date = date, let temp = temp, date > Date.now && date < temp {
                smallestDateProject = item
            }
        }
        
        if let smallestDateProject = smallestDateProject {
            let image = ImageHelper.downloadImage(from: smallestDateProject.coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: smallestDateProject, image: image)
        } else {
            let image = ImageHelper.downloadImage(from: allProjects[0].coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: allProjects[0], image: image)
        }
    }
    
    func randomProject(from allProjects: [Project], with configuration: WidgetTypeConfigurationIntent) -> UpcomingProjectEntry{
        let project = allProjects.randomElement()
        
        if let project = project {
            let image = ImageHelper.downloadImage(from: project.coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: project, image: image)
        } else {
            let image = ImageHelper.downloadImage(from: allProjects[0].coverURL)
            return UpcomingProjectEntry(date: Date.now, configuration: configuration, upcomingProject: allProjects[0], image: image)
        }
        
    }
}

struct UpcomingProjectEntry: TimelineEntry {
    let date: Date
    let configuration: WidgetTypeConfigurationIntent
    let upcomingProject: Project
    let image: Image
}

struct SmallWidgetUpcoming : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family{
        case .systemMedium:
            HStack(spacing: 20) {
                entry.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.upcomingProject.title)
                        .foregroundColor(Color("AccentColor"))
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading) {
                        Text("Releasedate")
                            .font(Font.body.italic())
                        
                        Text(getReleaseDateString())
                            .fontWeight(.bold)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Director")
                            .font(Font.body.italic())
                        
                        Text(getDirectorString())
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
            }.widgetURL(URL(string: "marvelwidgets://project/\(entry.upcomingProject.getUniqueProjectId())")!)
        case .systemSmall:
            ZStack {
                entry.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                HStack {
                    VStack {
                        Spacer()
                        
                        if let showTitle = UserDefaults(suiteName: UserDefaultValues.suiteName)!.bool(forKey: UserDefaultValues.smallWidgetShowText), showTitle {
                            Text(entry.upcomingProject.title)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black, radius: 5)
                                .font(Font.headline.weight(.bold))
                            
                            Spacer()
                            
                            if let difference = entry.upcomingProject.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
                                Text("\(difference) dagen")
                                    .padding(.bottom, 30)
                            }
                        }
                    }.padding()
                }
            }.widgetURL(URL(string: "marvelwidgets://project/\(entry.upcomingProject.getUniqueProjectId())")!)
        default:
            Text("Not implemented")
        }
        
    }
    
    func getReleaseDateString() -> String {
        if let difference = entry.upcomingProject.releaseDate?.toDate()?.differenceInDays(from: Date.now), difference >= 0 {
            return "\(entry.upcomingProject.releaseDate!) (\(difference) days)"
        } else {
            return entry.upcomingProject.releaseDate ?? "No releasedate"
        }
    }
    
    func getDirectorString() -> String {
        if let director = entry.upcomingProject.directedBy, !director.isEmpty {
            return director
        } else {
            return "No director yet"
        }
    }
}

struct SmallWidget: Widget {
    let kind: String = "SmallWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: WidgetTypeConfigurationIntent.self, provider: Provider()) { entry in
            SmallWidgetUpcoming(entry: entry)
        }
        .configurationDisplayName("Upcoming marvel")
        .description("This widget shows the first upcoming marvel project with a countdown.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
