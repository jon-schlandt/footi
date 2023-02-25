//
//  ViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 1/4/23.
//

import UIKit

class ViewController: UIViewController {
    private let leaguesService = LeaguesService()
    private let standingsService = StandingsService()
    private let fixturesService = FixturesService()
    private let leadersService = LeadersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _Concurrency.Task {
            let leagues = await leaguesService.getLeaguesBy(leagueId: 39)
            print(leagues)
            
            let standings = await standingsService.getStandingsBy(leagueId: 39, season: 2022)
            print(standings)
            
            let upcoming = await fixturesService.getFixturesBy(leagueId: 39, season: 2022, from: "2023-02-24", to: "2023-05-28")
            print(upcoming)
            
            let inPlayToday = await fixturesService.getFixturesBy(leagueId: 39, season: 2022, from: "2023-02-24", to: "2023-02-24", status: "1H-HT-2H-ET-BT-P-INT-LIVE")
            print(inPlayToday)
            
            let topGoals = await leadersService.getTopGoals(leagueId: 39, season: 2022)
            let topAssists = await leadersService.getTopAssists(leagueId: 39, season: 2022)
            let topYellowCards = await leadersService.getTopYellowCards(leagueId: 39, season: 2022)
            let topRedCards = await leadersService.getTopRedCards(leagueId: 39, season: 2022)
            
            print(topGoals)
            print(topAssists)
            print(topYellowCards)
            print(topRedCards)
        }
    }
}
