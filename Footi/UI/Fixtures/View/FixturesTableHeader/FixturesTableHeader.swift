//
//  FixturesTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/8/23.
//

import UIKit

class FixturesTableHeader: BaseTableHeader {
    
    static let identifier = String(describing: FixturesTableHeader.self)
    
    // MARK: View
    
    private let matchdayView = MatchdayView()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.container.addArrangedSubview(matchdayView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    
    public func configure(with matchday: Int) {
        matchdayView.configure(with: matchday)
    }
}
