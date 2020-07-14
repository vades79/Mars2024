//
//  LaunchListView.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 13.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol LaunchListView: BaseView {
    var presenter: LaunchListPresenter? { get set }
    
    func launchesCount() -> Int
    func reload(launches: [Launch])
    func append(launches: [Launch])
}

class LaunchListViewController: BaseNodeViewController {
    var presenter: LaunchListPresenter?
    
    private let tableNode: ASTableNode
    private var launches = [Launch]()
    private var context: ASBatchContext?
    
    private var refreshControl: UIRefreshControl!
    
    override init() {
        tableNode = ASTableNode(style: .plain)
        super.init()
        
        tableNode.dataSource = self
        tableNode.delegate = self
        
        self.node.automaticallyManagesSubnodes = true
        self.node.layoutSpecBlock = { (node, size) in
            let wrapper = ASWrapperLayoutSpec(layoutElement: self.tableNode)
            return wrapper
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: R.string.localizable.launchListLogOutTitle(), style: .plain, target: self, action: #selector(onLeftBarButton))
        
        tableNode.view.separatorStyle = .singleLine
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableNode.view.refreshControl = refreshControl
        
        presenter?.didLoad()
    }
    
    func loadPage(withContext context: ASBatchContext) {
        if Thread.isMainThread == false {
            DispatchQueue.main.async {
                self.loadPage(withContext: context)
            }
            return
        }
        self.context = context
        presenter?.loadPage(completion: {
            context.completeBatchFetching(true)
        })
    }
    
    
    // MARK: - Actions
    
    @objc private func onLeftBarButton() {
        showLogOutAlert()
    }
    
    @objc private func onRefresh() {
        if let context = self.context {
            if context.isFetching() {
                context.cancelBatchFetching()
            }
        }
        presenter?.reload(completion: { [weak self] in
            self?.refreshControl.endRefreshing()
        })
    }
    
    func showLogOutAlert() {
        let title = R.string.localizable.launchListLogOutTitle()
        let message = R.string.localizable.launchListLogOutSubtitle()
        let acceptTitle = R.string.localizable.launchListLogOutAccept()
        let declineTitle = R.string.localizable.launchListLogOutDecline()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: acceptTitle, style: .destructive, handler: { (_) in
            self.presenter?.logOut()
        }))
        alert.addAction(UIAlertAction(title: declineTitle, style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true)
    }
}

// MARK: - LaunchListView

extension LaunchListViewController: LaunchListView {
    
    func launchesCount() -> Int {
        return launches.count
    }
    
    func reload(launches: [Launch]) {
        self.launches = launches
        tableNode.reloadData()
    }
    
    func append(launches: [Launch]) {
        let from = self.launches.count
        self.launches.append(contentsOf: launches)
        let to = self.launches.count
        
        var paths = [IndexPath]()
        
        for i in from..<to {
            paths.append(IndexPath(row: i, section: 0))
        }
        
        tableNode.performBatchUpdates({
            tableNode.insertRows(at: paths, with: .automatic)
        }) { (_) in }
    }
}

// MARK: - ASTableDataSource & ASTableDelegate

extension LaunchListViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return launches.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.launches.count > indexPath.row else {
                return ASCellNode()
            }
            let launch = self.launches[indexPath.row]
            return LaunchCellNode(launch: launch)
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let launch = launches[indexPath.row]
        presenter?.openLaunchDetails(launch: launch)
    }
    
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        loadPage(withContext: context)
    }
}
