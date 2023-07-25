//
//  StandingsViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/12/23.
//

import UIKit

protocol StandingsScrollViewDelegate: AnyObject {
    func setStatsOffset(originatingView: UIScrollView, offset: CGPoint)
}

class StandingsViewController: BaseViewContoller, UIScrollViewDelegate {
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        self.baseTableVC = StandingsTableViewController()
        self.baseStackView.addArrangedSubview(self.baseTableVC.tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleView(title: "Standings", icon: "trophy.fill")
    }
    
    // MARK: Base overrides
    
    override func loadLeagueHeaderDetails() async {
        await super.loadLeagueHeaderDetails()
        
        self.leagueHeaderDetails.isLive = await setLiveStatus()
        self.leagueHeaderDetails.filter = await setDataFilter()
        self.leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func reloadLeagueHeaderDetails() async {
        await super.reloadLeagueHeaderDetails()
        
        guard let filterOption = self.getEnabledFilterOption() else {
            return
        }

        let isCurrentSeason = filterOption.value == self.leagueHeaderDetails.filter?.options.first?.value
        if isCurrentSeason {
            leagueHeaderDetails.isLive = await setLiveStatus()
        } else {
            leagueHeaderDetails.isLive = false
        }
        
        leagueHeader.configure(with: self.leagueHeaderDetails)
    }
    
    override func loadModel() async {
        await super.loadModel()
        
        guard let filterOption = self.getEnabledFilterOption(),
              let filterValue = Int(filterOption.value) else {
            return
        }
        
        #if DEBUG
        self.baseTableVC.model = standingsService.getMockStandings(for: self.leagueHeaderDetails.leagueId, season: filterValue)
        #else
        self.baseTableVC.model = await standingsService.getStandingsBy(leagueId: self.leagueHeaderDetails.leagueId, season: filterValue)
        #endif
        
        if self.leagueHeaderDetails.isLive == true {
            await livifyTable()
        }

        self.baseTableVC.tableView.reloadData()
    }
}

// MARK: Private helpers

extension StandingsViewController {
    
    private func setLiveStatus() async -> Bool {
        #if DEBUG
        return !fixturesService.getMockFixturesInPlay(for: self.leagueHeaderDetails.leagueId).isEmpty
        #else
        return await !fixturesService.getFixtures(leagueId: self.leagueHeaderDetails.leagueId, filterType: .inPlay).isEmpty
        #endif
    }
    
    private func setDataFilter() async -> LeagueDataFilter? {
        let seasons = await coreDataContext.fetchSeasons(for: self.leagueHeaderDetails.leagueId)
        guard let seasons = seasons else {
            return nil
        }

        var filterOptions = [DataFilterOption]()
        seasons.sorted { $0 > $1 }.enumerated().forEach { index, season in
            let startYear = String(season)
            let endYear = String(season + 1)

            let displayName = "\(startYear)/\(endYear.suffix(2))"
            let value = season
            let isEnabled = index == 0 ? true : false

            filterOptions.append(DataFilterOption(displayName: displayName, value: String(value), isEnabled: isEnabled))
        }
        
        return LeagueDataFilter(title: "By season", options: filterOptions)
    }
    
    private func livifyTable() async {
        var standings = self.baseTableVC.model as! [Standing]
        guard !standings.isEmpty else {
            return
        }
        
        var fixturesInPlay = [FixtureResponse]()
        var liveStandings = [Standing]()
        
        #if DEBUG
        fixturesInPlay = fixturesService.getMockFixturesInPlay(for: self.leagueHeaderDetails.leagueId)
        #else
        fixturesInPlay = await fixturesService.getFixtures(leagueId: self.leagueHeaderDetails.leagueId, filterType: .inPlay)
        #endif
        
        fixturesInPlay.forEach { fixture in
            var homePointMod: Int
            var homeWinMod: Int
            var homeDrawMod: Int
            var homeLossMod: Int
            
            var awayPointMod: Int
            var awayWinMod: Int
            var awayDrawMod: Int
            var awayLossMod: Int
            
            if fixture.score.home ?? 0 > fixture.score.away ?? 0 {
                homePointMod = 3
                homeWinMod = 1
                homeDrawMod = 0
                homeLossMod = 0
                
                awayPointMod = 0
                awayWinMod = 0
                awayDrawMod = 0
                awayLossMod = 1
            } else if fixture.score.home ?? 0 < fixture.score.away ?? 0 {
                homePointMod = 0
                homeWinMod = 0
                homeDrawMod = 0
                homeLossMod = 1
                
                awayPointMod = 3
                awayWinMod = 1
                awayDrawMod = 0
                awayLossMod = 0
            } else {
                homePointMod = 1
                homeWinMod = 0
                homeDrawMod = 1
                homeLossMod = 0
                
                awayPointMod = 1
                awayWinMod = 0
                awayDrawMod = 1
                awayLossMod = 0
            }

            var homeStanding = standings.first { $0.clubTitle == fixture.matchup.home.name }!
            homeStanding.inPlay = true
            homeStanding.matchesPlayed.modifier = 1
            homeStanding.points.modifier = homePointMod
            homeStanding.goalDifference.modifier = (fixture.score.home ?? 0) - (fixture.score.away ?? 0)
            homeStanding.matchesWon.modifier = homeWinMod
            homeStanding.matchesDrawn.modifier = homeDrawMod
            homeStanding.matchesLost.modifier = homeLossMod
            homeStanding.goalsScored.modifier = fixture.score.home ?? 0
            homeStanding.goalsConceded.modifier = fixture.score.away ?? 0
            liveStandings.append(homeStanding)
            
            var awayStanding = standings.first { $0.clubTitle == fixture.matchup.away.name }!
            awayStanding.inPlay = true
            awayStanding.matchesPlayed.modifier = 1
            awayStanding.points.modifier = awayPointMod
            awayStanding.goalDifference.modifier = (fixture.score.away ?? 0) - (fixture.score.home ?? 0)
            awayStanding.matchesWon.modifier = awayWinMod
            awayStanding.matchesDrawn.modifier = awayDrawMod
            awayStanding.matchesLost.modifier = awayLossMod
            awayStanding.goalsScored.modifier = fixture.score.away ?? 0
            awayStanding.goalsConceded.modifier = fixture.score.home ?? 0
            liveStandings.append(awayStanding)
        }
        
        standings = standings.map { standing in
            let matching = liveStandings.first { $0.position == standing.position }
            guard let matching = matching else {
                return standing
            }
            
            return matching
        }
        
        standings.sort { first, second in
            if first.points != second.points {
                return first.points > second.points
            }
            
            if first.goalDifference != second.goalDifference {
                return first.goalDifference > second.goalDifference
            }
            
            if first.goalsScored != second.goalsScored {
                return first.goalsScored > second.goalsScored
            }
            
            return first.clubTitle < second.clubTitle
        }
        
        standings = standings.enumerated().map { index, standing in
            var standing = standing
            let currentPosition = standing.position.value
            let livePosition = index + 1
            
            standing.position.modifier = -(currentPosition - livePosition)
            return standing
        }
        
        self.baseTableVC.model = standings
    }
}
