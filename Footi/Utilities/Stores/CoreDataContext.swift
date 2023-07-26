//
//  CoreDataContext.swift
//  Footi
//
//  Created by Jon Schlandt on 3/3/23.
//

import UIKit
import CoreData

class CoreDataContext {
    
    var appDelegate: AppDelegate?
    var moc : NSManagedObjectContext!
    
    let userDefaultsContext = UserDefaultsContext()
    let leaguesService = LeaguesService()
    
    // MARK: Model
    
    var leagues: [LeagueEntity]?
    
    // MARK: Lifecycle
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate?.persistentContainer.viewContext
        
        leagues = try? moc.fetch(LeagueEntity.fetchRequest())
    }
    
    // MARK: Public methods
    
    public func fetchCurrentSeason(for leagueId: Int) async -> Int? {
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
    
    public func fetchSeasons(for leagueId: Int) async -> [Int]? {
        let league = await fetchLeague(for: leagueId)
        guard let league = league else {
            return nil
        }
        
        let seasons = league.seasons as? Set<SeasonEntity>
        let years = seasons?.map { Int($0.year) }
        
        return years
    }
    
    public func fetchSeasonStartDate(leagueId: Int, season: Int) async -> String? {
        let league = await fetchLeague(for: leagueId)
        guard let seasons = league?.seasons as? Set<SeasonEntity> else {
            return nil
        }
        
        let season = seasons.first { $0.year == Int16(season) }
        if let season = season {
            return season.startDate
        }
        
        return nil
    }
    
    public func fetchSeasonEndDate(leagueId: Int, season: Int) async -> String? {
        let league = await fetchLeague(for: leagueId)
        guard let seasons = league?.seasons as? Set<SeasonEntity> else {
            return nil
        }
        
        let season = seasons.first { $0.year == Int16(season) }
        if let season = season {
            return season.endDate
        }
        
        return nil
    }
    
    // MARK: Private methods
    
    private func fetchLeague(for leagueId: Int) async -> LeagueEntity? {
        let league = leagues?.first { $0.id == leagueId }
        guard let league = league else {
            await loadLeague(for: leagueId)
            return await fetchLeague(for: leagueId)
        }
        
        return league
    }

    private func loadLeague(for leagueId: Int) async {
        var league: League?
        
        #if DEBUG
        league = leaguesService.getMockLeague(leagueId: leagueId)
        if league == nil {
            league = await leaguesService.getLeagueBy(leagueId: leagueId)
        }
        #else
        league = await leaguesService.getLeagueBy(leagueId: leagueId)
        #endif
        
        if let league = league {
            return await loadLeague(using: league)
        }

        return
    }
    
    private func loadLeague(using league: League) async {
        let leagueEntity = LeagueEntity(context: moc)
        leagueEntity.id = Int16(league.id)
        leagueEntity.name = league.name
        
        league.seasons.forEach { season in
            let seasonEntity = SeasonEntity(context: moc)

            seasonEntity.year = Int16(season.year)
            seasonEntity.startDate = season.startDate
            seasonEntity.endDate = season.endDate
            seasonEntity.isCurrent = season.isCurrent

            seasonEntity.league = leagueEntity
        }
        
        await appDelegate?.saveContext()
        leagues = try? moc.fetch(LeagueEntity.fetchRequest())
    }
}
