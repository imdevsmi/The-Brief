//
//  FavoritesVC.swift
//  News
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import SnapKit
import UIKit

protocol FavoritesVCOutputProtocol: AnyObject {
    func reloadData()
    func showModal(title: String, message: String)
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input?.fetchFavoritesNews()
    }
    
    init(viewModel: FavoritesVM = FavoritesVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: Private Methods
private extension FavoritesVC {
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupConstraints()
        setupLayout()
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension FavoritesVC: FavoritesVCOutputProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func showModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    }
}
