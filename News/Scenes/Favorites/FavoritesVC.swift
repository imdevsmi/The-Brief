//
//  FavoritesVC.swift
//  News
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import Foundation
import UIKit

protocol FavoritesVCInputProtocol: AnyObject {
    
}

final class FavoritesVC: UIViewController {
    private let viewModel: FavoritesVM
    
    // MARK: Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        tableView.rowHeight = 152
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    init(viewModel: FavoritesVM) {
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
