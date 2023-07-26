//
//  BaseStackView.swift
//  Footi
//
//  Created by Jon Schlandt on 7/4/23.
//

import UIKit

class BaseStackView: UIStackView {
    
    // MARK: Subviews
    
    private var loadingHeader: LeagueHeaderView = {
        let loadingHeader = LeagueHeaderView()
        loadingHeader.layer.zPosition = 999
        
        return loadingHeader
    }()
    
    private var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.layer.zPosition = 999
        loadingView.alpha = 0.0
        
        return loadingView
    }()
    
    // MARK: Model
    
    public var isLoading = false {
        didSet {
            if isLoading {
                loadingView.beginAnimation()
                
                loadingHeader.alpha = 1.0
                loadingView.alpha = 1.0
            } else {
                UIView.animate(withDuration: 0.20, animations: {
                    self.loadingHeader.alpha = 0.0
                    self.loadingView.alpha = 0.0
                }, completion: { _ in
                    self.loadingView.endAnimation()
                })
            }
        }
    }

    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        
        self.addSubview(loadingView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: self.topAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
