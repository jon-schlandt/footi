//
//  FixturesTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/8/23.
//

import UIKit

class FixturesTableHeader: BaseTableHeader {
    
    static let identifier = String(describing: FixturesTableHeader.self)
    
    // MARK: Subviews
    
    private let matchdayView = MatchdayView()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.content.addSubview(matchdayView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            matchdayView.topAnchor.constraint(equalTo: self.content.topAnchor),
            matchdayView.trailingAnchor.constraint(equalTo: self.content.trailingAnchor),
            matchdayView.bottomAnchor.constraint(equalTo: self.content.bottomAnchor),
            matchdayView.leadingAnchor.constraint(equalTo: self.content.leadingAnchor)
        ])
    }
    
    // MARK: Public methods
    
    public func configure(with matchday: Int) {
        matchdayView.configure(with: matchday)
    }
}
