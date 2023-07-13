//
//  BaseTableViewController.swift
//  Footi
//
//  Created by Jon Schlandt on 7/4/23.
//

import UIKit

protocol BaseTableViewControllerDelegate: AnyObject {
    func refreshTable() async
}

class BaseTableViewController: UITableViewController {

    let LOADING_VIEW_HEIGHT = 48.0
    let MIN_Y_OFFSET = 0.0
    let MAX_Y_OFFSET = -48.0 - AppConstants.baseSectionSpacing
    
    // MARK: Subviews
    
    public var loadingView: LoadingView = {
        let view = LoadingView()
        view.layer.zPosition = -1
        
        return view
    }()
    
    // MARK: Model
    
    public var model: Any!
    public var hasLoaded = false
    public var loadingViewBottomAnchor: NSLayoutConstraint!
    public weak var delegate: BaseTableViewControllerDelegate!
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UITableView()
        rootView.separatorStyle = .none
        rootView.sectionHeaderTopPadding = 0
        rootView.backgroundColor = .clear
        rootView.addSubview(loadingView)
        
        loadingViewBottomAnchor = loadingView.bottomAnchor.constraint(equalTo: rootView.topAnchor, constant: 0)
        loadingViewBottomAnchor.isActive = true
        loadingView.widthAnchor.constraint(equalTo: rootView.widthAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: LOADING_VIEW_HEIGHT).isActive = true
        
        rootView.dataSource = self
        rootView.delegate = self
        
        view = rootView
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }

        guard hasLoaded else {
            return
        }

        let yOffset = scrollView.contentOffset.y

        if yOffset < MIN_Y_OFFSET && yOffset > MAX_Y_OFFSET {
            if loadingView.wheel.tintColor != UIColor.Palette.tertiaryIcon {
                loadingView.wheel.tintColor = UIColor.Palette.tertiaryIcon
                loadingView.endAnimation()
            }
        } else if yOffset <= MAX_Y_OFFSET {
            loadingViewBottomAnchor.constant = LOADING_VIEW_HEIGHT + AppConstants.baseSectionSpacing + yOffset

            if loadingView.wheel.tintColor != UIColor.Palette.emphasisIcon {
                loadingView.wheel.tintColor = UIColor.Palette.emphasisIcon
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {        
        guard scrollView == self.tableView else {
            return
        }
        
        let yOffset = scrollView.contentOffset.y
        guard yOffset < MAX_Y_OFFSET else {
            return
        }
        
        scrollView.contentInset = UIEdgeInsets(top: LOADING_VIEW_HEIGHT + AppConstants.baseSectionSpacing, left: 0, bottom: 0, right: 0)
        self.loadingView.beginAnimation()
        
        _Concurrency.Task {
            await test(scrollView: scrollView)
        }
    }
    
    // MARK: Base methods
    
    internal func setTableToOrigin() {
        if tableView.contentOffset != CGPoint(x: 0.0, y: 0.0) {
            tableView.contentOffset = CGPoint()
        }
    }
}

// MARK: Private helpers
extension BaseTableViewController {
    
    private func test(scrollView: UIScrollView) async {
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            _Concurrency.Task {
                await self.delegate.refreshTable()

                UIView.animate(withDuration: 0.20) {
                    scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
            }
        }
        #else
        await self.delegate.refreshTable()
        
        UIView.animate(withDuration: 0.20) {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        #endif
    }
}
