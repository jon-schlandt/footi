//
//  BaseViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

// MARK: Implementation

class BaseViewContoller: UIViewController {
    
    internal let coreDataContext = CoreDataContext()
    internal let userDefaultsContext = UserDefaultsContext()
    
    internal let fixturesService = FixturesService()
    internal let leadersService = LeadersService()
    internal let leaguesService = LeaguesService()
    internal let standingsService = StandingsService()
    
    // MARK: Controllers
    
    internal var menuNav: BaseNavigationController!
    internal var leagueDataFilterNav: LeagueDataFilterNavigationController!
    internal var baseTableVC: BaseTableViewController!
    
    // MARK: Subviews
    
    internal var baseStackView = BaseStackView()
    internal var leagueHeader = LeagueHeaderView()
    
    // MARK: Model
    
    internal var selectedLeague: LeagueSelection!
    internal var leagueHeaderDetails: LeagueHeaderDetails!
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UIView()
        
        baseStackView.addArrangedSubview(leagueHeader)
        rootView.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseTableVC.delegate = self
        leagueHeader.delegate = self
        
        setupNavigation()
        setupMenu()
        styleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.hasLeagueChanged()) {
            _Concurrency.Task {
                self.setBaseTableToOrigin()
                
                await self.reloadSelectedLeague()
                await loadLeagueHeaderDetails()
                await reloadModel()
            }
        }
    }
    
    // MARK: Base methods
    
    internal func loadLeagueHeaderDetails() async {
        selectedLeague = userDefaultsContext.getSelectedLeague()
        
        leagueHeaderDetails = LeagueHeaderDetails(
            leagueId: selectedLeague.id,
            leagueTitle: selectedLeague.title
        )
    }
    
    internal func reloadLeagueHeaderDetails() async {}
    internal func loadModel() async {}
    
    internal func reloadModel() async {
        baseTableVC.model = Any.self
        await loadModel()
    }
    
    // MARK: Base helpers
    
    final internal func setTitle(as title: String) {
        let label = UILabel()
        label.font = UIFont(name: FontConstants.title, size: 17.0)
        label.textColor = UIColor.Palette.barText
        label.text = title
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        self.navigationItem.titleView = UIView()
    }
    
    final internal func getEnabledFilterOption() -> DataFilterOption? {
        let filterOption = self.leagueHeaderDetails.filter.options.first { $0.isEnabled }
        guard let filterOption = filterOption else {
            return nil
        }
        
        return filterOption
    }
}

// MARK: Delegates

extension BaseViewContoller: MenuViewControllerDelegate {
    
    internal func selectLeague() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            _Concurrency.Task {
                await self.reloadSelectedLeague()
                await self.loadLeagueHeaderDetails()
                await self.reloadModel()
            }
            
            self.closeMenu()
            self.setBaseTableToOrigin()
        }
    }
    
    internal func displaySettings() {
        closeMenu()
        
        let settingsVC = SettingsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    internal func closeMenu() {
        menuNav.dismiss(animated: true)
    }
}

extension BaseViewContoller: LeagueDataFilterDelegate {
    
    internal func setFilter(to filter: LeagueDataFilter) {
        leagueHeaderDetails.filter = filter
        leagueHeader.configure(with: leagueHeaderDetails)
        
        _Concurrency.Task {
            await reloadLeagueHeaderDetails()
            await reloadModel()
        }
        
        setBaseTableToOrigin()
        dismissFilter()
    }
    
    internal func dismissFilter() {
        leagueHeader.resetDropdown()
        leagueDataFilterNav.dismiss(animated: true)
    }
}

extension BaseViewContoller: LeagueDataFilterDismissDelegate {
    
    internal func resetDropdown() {
        leagueHeader.resetDropdown()
    }
}

extension BaseViewContoller: LeagueHeaderViewDelegate {
    
    internal func presentFilter() {
        let vc = LeagueDataFilterViewController(filter: leagueHeaderDetails.filter)
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        
        leagueDataFilterNav = LeagueDataFilterNavigationController(rootViewController: vc)
        leagueDataFilterNav.dismissDelegate = self
        
        if let sheet = leagueDataFilterNav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        self.present(leagueDataFilterNav, animated: true)
    }
}

extension BaseViewContoller: BaseTableViewControllerDelegate {
    
    internal func refreshTable() async {
        await reloadModel()
    }
}

// MARK: Private helpers

extension BaseViewContoller {
    
    private func setupNavigation() {
        self.navigationItem.backButtonTitle = ""

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18.0, weight: .light, scale: .medium)),
            style: .plain,
            target: self,
            action: #selector(displayMenu)
        )
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self

        menuNav = BaseNavigationController(rootViewController: menuVC)
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.primaryBackground
    }
    
    private func hasLeagueChanged() -> Bool {
        guard self.selectedLeague != nil else {
            return false
        }
        
        let selectedLeague = userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return false
        }
        
        return self.selectedLeague != selectedLeague
    }
    
    private func reloadSelectedLeague() async {
        let selectedLeague = userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        self.selectedLeague = selectedLeague
    }
    
    private func setBaseTableToOrigin() {
        self.baseTableVC.setTableToOrigin()
    }
    
    @objc private func displayMenu() {
        if let sheet = menuNav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(menuNav, animated: true)
    }
}
