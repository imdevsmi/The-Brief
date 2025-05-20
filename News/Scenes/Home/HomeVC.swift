//
//  HomeVC.swift
//  News
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import SnapKit
import UIKit

final class HomeVC: UIViewController {

    // MARK: - UI Elements
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupViews()
        setupLayout()
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
    }
    
    private func setupLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
}
