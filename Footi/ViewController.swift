//
//  ViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // Services
    private let leaguesService = LeaguesService()
    private let standingsService = StandingsService()
    private let fixturesService = FixturesService()
    private let leadersService = LeadersService()
    
    // Models
    private var league : League? = nil
    private var standings : LeagueStandings? = nil
    private var upcoming : [Fixture]? = nil
    private var inPlayToday : [Fixture]? = nil
    private var topGoals : [Leader]? = nil
    private var topAssists : [Leader]? = nil
    private var topYellowCards : [Leader]? = nil
    private var topRedCards : [Leader]? = nil
    
    // Helpers
    private let coreDataContext = CoreDataContext()
    private let userDefaultsContext = UserDefaultsContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserDefaults()
        
        _Concurrency.Task {
//            await getTestData()
//            printTestData()
            
//            leagues?.forEach { league in
//                let leagueEntity = LeagueEntity(context: moc)
//
//                leagueEntity.id = Int16(league.overview.id)
//                leagueEntity.name = league.overview.name
//            }
        }
    }
    
    private func setUserDefaults() {
        userDefaultsContext.setUserSetting(for: "theme", as: "light")
        userDefaultsContext.setUserSetting(for: "defaultLeague", as: "laLiga")
        print(userDefaultsContext.getUserSetting(for: "theme"))
        
//        userDefaultsContext.setSelectedLeague(as: "premierLeague")
        print(userDefaultsContext.getSelectedLeague())
    }
    
    private func getTestData() async {
//        let selectedLeagueId = userDefaultsContext.getSelectedLeague()?["id"] as? Int
//        guard let selectedLeagueId = selectedLeagueId else {
//            return
//        }
//
//        let seasons = await coreDataContext.fetchSeasons(for: selectedLeagueId)
//        guard let seasons = seasons else {
//            return
//        }
//
//        let currentSeason = await coreDataContext.fetchCurrentSeason(for: selectedLeagueId)
//        guard let currentSeason = currentSeason else {
//            return
//        }
        
        await coreDataContext.loadLeagues()
        
//        league = await leaguesService.getLeagueBy(leagueId: selectedLeagueId)
//        standings = await standingsService.getLeagueStandingsBy(leagueId: selectedLeagueId, season: seasons[0])

//        inPlayToday = await fixturesService.getFixturesInPlay(for: selectedLeagueId)
//        upcoming = await fixturesService.getUpcomingFixtures(for: selectedLeagueId)
        
//        topGoals = await leadersService.getTopGoals(leagueId: selectedLeagueId, season: currentSeason)
//        topAssists = await leadersService.getTopAssists(leagueId: selectedLeagueId, season: currentSeason)
//        topYellowCards = await leadersService.getTopYellowCards(leagueId: selectedLeagueId, season: currentSeason)
//        topRedCards = await leadersService.getTopRedCards(leagueId: selectedLeagueId, season: currentSeason)
    }
    
    private func printTestData() {
//        if let league = league {
//            print(league)
//        }
//
//        if let standings = standings {
//            print(standings)
//        }
        
//        if let inPlayToday = inPlayToday {
//            print(inPlayToday)
//        }
        
//        if let upcoming = upcoming {
//            print(upcoming)
//        }

//        if let topGoals = topGoals {
//            print(topGoals)
//        }
//
//        if let topAssists = topAssists {
//            print(topAssists)
//        }
//
//        if let topYellowCards = topYellowCards {
//            print(topYellowCards)
//        }
//
//        if let topRedCards = topRedCards {
//            print(topRedCards)
//        }
    }
}
