//
//  BaseViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 3/18/23.
//

import UIKit

class BaseViewContoller: UIViewController {

    // MARK: Data stores
    
    let coreDataContext = CoreDataContext()
    let userDefaultsContext = UserDefaultsContext()
    
    // MARK: Networking
    
    let fixturesService = FixturesService()
    let leadersService = LeadersService()
    let leaguesService = LeaguesService()
    let standingsService = StandingsService()
    
    // MARK: Controllers and Views
    
    var menuNav: BaseNavigationController!
    var leagueDataFilterNav: BaseNavigationController!
    var baseStackView: UIStackView!
    var leagueHeader = LeagueHeaderView()
    
    // MARK: Model
    
    var selectedLeague: LeagueSelection!
    var leagueHeaderDetails: LeagueHeaderDetails!
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UIView()
        
        baseStackView = UIStackView()
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        baseStackView.axis = .vertical
        baseStackView.distribution = .fill
        baseStackView.alignment = .center
        baseStackView.spacing = AppConstants.baseSectionSpacing
        
        baseStackView.addArrangedSubview(self.leagueHeader)
        rootView.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            leagueHeader.trailingAnchor.constraint(equalTo: baseStackView.trailingAnchor),
            leagueHeader.leadingAnchor.constraint(equalTo: baseStackView.leadingAnchor),
            leagueHeader.heightAnchor.constraint(equalToConstant: ComponentConstants.leagueHeaderHeight)
        ])
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leagueHeader.delegate = self
        selectedLeague = userDefaultsContext.getSelectedLeague()
        
        setupNavigation()
        setupMenu()
        styleView()
    }
    
    // MARK: Internal
    
    internal func loadLeagueHeaderDetails() async {
        let leagueId = selectedLeague.id
        let leagueTitle = selectedLeague.title
        
        leagueHeaderDetails = LeagueHeaderDetails(
            leagueId: leagueId,
            leagueTitle: leagueTitle,
            filter: LeagueDataFilter(title: leagueTitle, options: [DataFilterOption]())
        )
    }
    
    internal func loadModel() async {
        fatalError("loadModel() has not been implemented")
    }
    
    final internal func hasLeagueChanged() -> Bool {
        let selectedLeague = userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return false
        }
        
        return self.selectedLeague != selectedLeague
    }
    
    final internal func reloadSelectedLeague() async {
        let selectedLeague = userDefaultsContext.getSelectedLeague()
        guard let selectedLeague = selectedLeague else {
            return
        }
        
        self.selectedLeague = selectedLeague
    }
    
    final internal func getEnabledFilterOption() -> DataFilterOption? {
        let filterOption = self.leagueHeaderDetails.filter.options.first { $0.isEnabled }
        guard let filterOption = filterOption else {
            return nil
        }
        
        return filterOption
    }
}

extension BaseViewContoller: MenuViewControllerDelegate {
    
    internal func selectLeague() {
        closeMenu()
        
        _Concurrency.Task {
            await reloadSelectedLeague()
            
            await loadLeagueHeaderDetails()
            await loadModel()
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

extension BaseViewContoller: LeagueHeaderViewDelegate {
    
    internal func presentFilter() {
        let vc = LeagueDataFilterViewController(filter: leagueHeaderDetails.filter)
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet
        
        leagueDataFilterNav = BaseNavigationController(rootViewController: vc)
        
        if let sheet = leagueDataFilterNav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        self.present(leagueDataFilterNav, animated: true)
    }
}

extension BaseViewContoller: LeagueDataFilterDelegate {
    
    internal func setFilter(to filter: LeagueDataFilter) {
        leagueHeaderDetails.filter = filter
        leagueHeader.configure(with: leagueHeaderDetails)
        
        dismissFilter()
        
        _Concurrency.Task {
            await loadModel()
        }
    }
    
    internal func dismissFilter() {
        leagueDataFilterNav.dismiss(animated: true)
    }
}

/// Private methods
extension BaseViewContoller {
    
    private func setupNavigation() {
        self.navigationItem.backButtonTitle = ""
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(weight: .light)),
            style: .plain,
            target: self,
            action: #selector(displayMenu)
        )
    }
    
    @objc private func displayMenu() {
        if let sheet = menuNav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(menuNav, animated: true)
    }
    
    private func setupMenu() {
        let menuVC = MenuViewController()
        menuVC.delegate = self

        menuNav = BaseNavigationController(rootViewController: menuVC)
    }
    
    private func styleView() {
        self.view.backgroundColor = UIColor.Palette.primaryBackground
    }
}
