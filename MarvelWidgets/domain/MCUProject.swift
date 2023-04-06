//
//  MCUProject.swift
//  MarvelWidgets
//
//  Created by Bas Buijsen on 13/11/2022.
//

import Foundation

struct MCUProject: Codable, Comparable {
    static func < (lhs: MCUProject, rhs: MCUProject) -> Bool {
        guard let lhsDate = lhs.releaseDate?.toDate() else { return false }
        guard let rhsDate = rhs.releaseDate?.toDate() else { return true }
        return lhsDate < rhsDate
    }
    
    static func == (lhs: MCUProject, rhs: MCUProject) -> Bool {
        guard let lhsDate = lhs.releaseDate?.toDate() else { return false }
        guard let rhsDate = rhs.releaseDate?.toDate() else { return true }
        return lhsDate == rhsDate
    }
    
    let title: String
    let releaseDate: String?
    let releaseDateStringOverride: String?
    let postCreditScenes, duration, voteCount, awardsNominated, awardsWon, productionBudget: Int?
    let phase: Phase?
    let saga: Saga?
    let overview: String?
    let type: ProjectType
    let boxOffice, createdAt, updatedAt, disneyPlusUrl, categories, quote, quoteCaption: String?
    let directors: Directors?
    let actors: Actors?
    let relatedProjects: RelatedProjects?
    let trailers: [Trailer]?
    let posters: [Poster]?
    let seasons: [Season]?
    let rating: Double?
    let reviewTitle, reviewSummary, reviewCopyright: String?
 
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case releaseDate = "ReleaseDate"
        case releaseDateStringOverride = "ReleaseDateNameOverride"
        case postCreditScenes = "PostCreditScenes"
        case duration = "Duration"
        case phase = "Phase"
        case saga = "Saga"
        case overview = "Overview"
        case type = "Type"
        case boxOffice = "BoxOffice"
        case createdAt, updatedAt, directors, actors
        case relatedProjects = "related_projects"
        case trailers = "Trailers"
        case posters = "Posters"
        case seasons = "Seasons"
        case disneyPlusUrl = "DisneyPlusUrl"
        case rating = "Rating"
        case voteCount = "VoteCount"
        case categories = "Categories"
        case awardsNominated = "AwardsNominated"
        case awardsWon = "Awardswon"
        case quote = "Quote"
        case quoteCaption = "QuoteCaption"
        case productionBudget = "ProductionBudget"
        case reviewTitle, reviewSummary, reviewCopyright
    }
    
    func getReleaseDateString(withDayCount: Bool = false) -> String {
        var releaseDateString: String
        if let releaseDateStringOverride = releaseDateStringOverride {
            releaseDateString = releaseDateStringOverride
        } else if let releaseDate = releaseDate, let dateObj = releaseDate.toDate() {
            releaseDateString = dateObj.toFormattedString()
        } else {
            releaseDateString = "Unkown release date"
        }
        
        if withDayCount,
            releaseDateStringOverride == nil,
            let difference = getDaysUntilRelease(withDaysString: true) {
            releaseDateString += " m(\(difference))"
        }
        
        return releaseDateString
    }
    
    func getDaysUntilRelease(withDaysString: Bool) -> String? {
        if let difference = releaseDate?.toDate()?.differenceInDays(from: Date.now), difference > 0 {
            if withDaysString {
                return "\(difference) days"
            } else {
                return "\(difference)"
            }
        }
        return nil
    }
}
