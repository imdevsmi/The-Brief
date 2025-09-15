//
//  FavoritesVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 19.07.2025.
//

import SnapKit
import UIKit

protocol FavoritesVCOutputProtocol: AnyObject {
    func reloadData()
}

final class FavoritesVC: UIViewController {
    
    // MARK: Properties
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
        observeNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input?.fetchFavoritesNews()
    }
    
    deinit { NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FavoritesUpdated"), object: nil) }
    
    // MARK: - Init
    init(viewModel: FavoritesVM = FavoritesVM()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
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
    
    func setupConstraints() { view.addSubview(tableView) }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func observeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: NSNotification.Name("FavoritesUpdated"), object: nil)
    }
}

// MARK: - FavoritesVCOutputProtocol
extension FavoritesVC: FavoritesVCOutputProtocol {
    func reloadData() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return viewModel.favoritesArticles.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { return UITableViewCell() }
        cell.setup(with: viewModel.favoritesArticles[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVM: NewsDetailVM = .init(article: viewModel.favoritesArticles[indexPath.row])
        let detailVC = NewsDetailVC(viewModel: detailVM, favoritesService: FavoriteService())
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: L("delete")) { [weak self] (_, _, completion) in
            let alert = UIAlertController( title: L("alert_title_confirm"), message: L("alert_message_remove_article"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: L("cancel"), style: .cancel))
            alert.addAction(UIAlertAction(title: L("remove"), style: .destructive) { _ in
                self?.viewModel.input?.removeNews(at: indexPath.row)
            })
            self?.present(alert, animated: true)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: Objective Methods
@objc private extension FavoritesVC {
    func favoritesUpdated() { viewModel.input?.fetchFavoritesNews() }
}
