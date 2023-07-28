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

    let MIN_Y_OFFSET = 0.0
    let MAX_Y_OFFSET = -48.0 - AppConstants.baseSectionSpacing
    
    // MARK: Subviews
    
    private var refreshView: RefreshView = {
        let view = RefreshView()
        view.layer.zPosition = -1
        
        return view
    }()
    
    private var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.layer.zPosition = 999
        loadingView.alpha = 0.0
        
        return loadingView
    }()
    
    // MARK: Model
    
    internal var model: Any!
    internal weak var delegate: BaseTableViewControllerDelegate!
    
    private var refreshViewBottomAnchor: NSLayoutConstraint!
    
    public var isLoading = false {
        didSet {
            if isLoading {
                loadingView.beginAnimation()
                loadingView.alpha = 1.0
            } else {
                UIView.animate(withDuration: 0.20, animations: {
                    self.loadingView.alpha = 0.0
                }, completion: { _ in
                    self.loadingView.endAnimation()
                })
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        let rootView = UITableView()
        rootView.separatorStyle = .none
        rootView.sectionHeaderTopPadding = 0
        rootView.backgroundColor = .clear
        
        rootView.addSubview(refreshView)
        rootView.addSubview(loadingView)
        
        refreshViewBottomAnchor = refreshView.bottomAnchor.constraint(equalTo: rootView.topAnchor, constant: 0)
        refreshViewBottomAnchor.isActive = true
        refreshView.widthAnchor.constraint(equalTo: rootView.widthAnchor).isActive = true
        refreshView.heightAnchor.constraint(equalToConstant: ComponentConstants.refreshViewHeight).isActive = true
        
        NSLayoutConstraint.activate([
            loadingView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            loadingView.heightAnchor.constraint(equalTo: rootView.heightAnchor, constant: -AppConstants.baseSectionSpacing),
            loadingView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: rootView.centerYAnchor, constant: AppConstants.baseSectionSpacing)
        ])
        
//        NSLayoutConstraint.activate([
//            loadingView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: AppConstants.baseSectionSpacing),
//            loadingView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
//            loadingView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
//            loadingView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor)
//        ])
        
        rootView.dataSource = self
        rootView.delegate = self
        
        view = rootView
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else {
            return
        }

        let yOffset = scrollView.contentOffset.y

        if yOffset < MIN_Y_OFFSET && yOffset > MAX_Y_OFFSET {
            if refreshView.wheel.tintColor != UIColor.Palette.tertiarySymbol {
                refreshView.wheel.tintColor = UIColor.Palette.tertiarySymbol
                refreshView.endAnimation()
            }
        } else if yOffset <= MAX_Y_OFFSET {
            refreshViewBottomAnchor.constant = ComponentConstants.refreshViewHeight + AppConstants.baseSectionSpacing + yOffset

            if refreshView.wheel.tintColor != UIColor.Palette.emphasis {
                refreshView.wheel.tintColor = UIColor.Palette.emphasis
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
        
        scrollView.contentInset = UIEdgeInsets(top: ComponentConstants.refreshViewHeight + AppConstants.baseSectionSpacing, left: 0, bottom: 0, right: 0)
        refreshView.beginAnimation()
        
        _Concurrency.Task {
            await refreshTable(scrollView: scrollView)
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
    
    private func refreshTable(scrollView: UIScrollView) async {
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
        await delegate.refreshTable()
        
        UIView.animate(withDuration: 0.20) {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        #endif
    }
}
