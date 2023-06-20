//
//  LeadersTableHeader.swift
//  Footi
//
//  Created by Jon Schlandt on 5/29/23.
//

import UIKit

class LeadersTableHeader: BaseTableHeader {
    
    static let identifier = String(describing: LeadersTableHeader.self)
    
    // MARK: View
    
    private let leaderTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontConstants.title, size: FontConstants.standardSize)
        label.textColor = UIColor.Palette.tertiaryText
        label.text = "Leader"
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.baseMargin)
        ])
        
        return view
    }()
    
    // MARK: Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.container.addArrangedSubview(leaderTitleView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
