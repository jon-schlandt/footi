//
//  CoreDataContext.swift
//  Footi
//
//  Created by Jon Schlandt on 3/3/23.
//

import UIKit
import CoreData

struct CoreDataContext {
    
    var appDelegate: AppDelegate?
    var moc : NSManagedObjectContext!
    
    let userDefaultsContext = UserDefaultsContext()
    let leaguesService = LeaguesService()
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate?.persistentContainer.viewContext
    }
    
    func fetchCurrentSeason(for leagueId: Int) async -> Int? {
        let league = await fetchLeague(for: leagueId)
        guard let league = league else {
            return nil
        }

        let seasons = league.seasons as? Set<SeasonEntity>
        let season = seasons?.first { $0.isCurrent }
        let year = season?.year as? Int16
        if let year = year {
            return Int(year)
        }

        return nil
    }
    
    func fetchSeasons(for leagueId: Int) async -> [Int]? {
        let league = await fetchLeague(for: leagueId)
        guard let league = league else {
            return nil
        }
        
        let seasons = league.seasons as? Set<SeasonEntity>
        let years = seasons?.map { Int($0.year) }
        
        return years
    }
    
    func fetchSeasonStartDate(leagueId: Int, season: Int) async -> String? {
        let league = await fetchLeague(for: leagueId)
        guard let league = league else {
            return nil
        }
        
        let seasons = league.seasons as? Set<SeasonEntity>
        let season = seasons?.first { $0.year == Int16(season) }
        if let season = season {
            return season.startDate
        }
        
        return nil
    }
    
    func fetchSeasonEndDate(leagueId: Int, season: Int) async -> String? {
        let league = await fetchLeague(for: leagueId)
        guard let league = league else {
            return nil
        }
        
        let seasons = league.seasons as? Set<SeasonEntity>
        let season = seasons?.first { $0.year == Int16(season) }
        if let season = season {
            return season.endDate
        }
        
        return nil
    }
    
    func fetchLeague(for leagueId: Int) async -> LeagueEntity? {
        let leagues = try? moc.fetch(LeagueEntity.fetchRequest())
        let league = leagues?.first { $0.id == leagueId }
        guard let league = league else {
            await loadLeague(for: leagueId)
            return await fetchLeague(for: leagueId)
        }

        return league
    }

    func loadLeague(for leagueId: Int) async {
        let league = await leaguesService.getLeagueBy(leagueId: leagueId)
        guard let league = league else {
            return
        }

        return await loadLeague(using: league)
    }
    
    func loadLeague(using league: League) async {
        let leagueEntity = LeagueEntity(context: moc)
        leagueEntity.id = Int16(league.overview.id)
        leagueEntity.name = league.overview.name
        
        league.seasons.forEach { season in
            let seasonEntity = SeasonEntity(context: moc)

            seasonEntity.year = Int16(season.year)
            seasonEntity.startDate = season.startDate
            seasonEntity.endDate = season.endDate
            seasonEntity.isCurrent = season.isCurrent

            seasonEntity.league = leagueEntity
        }
        
        await appDelegate?.saveContext()
    }
}
