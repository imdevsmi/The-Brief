//
//  HomeVC.swift
//  The Brief
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import Kingfisher
import SnapKit
import UIKit


// MARK: - HomeVMOutputProtocol
protocol HomeVMOutputProtocol: AnyObject {
    func didFail(with error: Error)
    func didBecomeEmpty(_ isEmpty: Bool)
    func didUpdateArticles(_ articles: [Article], append: Bool)
}

final class HomeVC: UIViewController {
    
    // MARK: - UI Elements
    private let viewModel: HomeVM
    private var categories = CategoryModel.allCases
    private var selectedCategory: CategoryModel = .general
    private var selectedIndexPath: IndexPath = IndexPath(item: 0, section: 0)

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = L("search_news")
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refresh
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = L("no_news_found")
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifier)
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureView()
        viewModel.input?.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

    
    // MARK: Inits
    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.output = self
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

// MARK: - HomeVMOuputProtocol
extension HomeVC: HomeVMOutputProtocol {
    func didFail(with error: Error) { }
    
    func didBecomeEmpty(_ isEmpty: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            emptyLabel.isHidden = !isEmpty
        }
    }
    
    func didUpdateArticles(_ articles: [Article], append: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
            self.tableView.reloadData()
            self.emptyLabel.isHidden = !articles.isEmpty
        }
    }
}

// MARK: - Private Methods
private extension HomeVC {
    func configureView() {
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        addViews()
        configureLayout()
    }
    
    func addViews() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        categoryCollectionView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        tableView.tableHeaderView = categoryCollectionView
    }

    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.articles.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { fatalError() }
        cell.setup(with: viewModel.articles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { viewModel.articles[$0.row].urlToImage }.compactMap(URL.init(string:))
        ImagePrefetcher(urls: urls).start()
    }
}

// MARK: - UICollectionViewDataSource - UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return categories.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else { fatalError() }
        
        let category = categories[indexPath.item]
        cell.configure(with: category.displayName, selected: indexPath == selectedIndexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        collectionView.reloadItems(at: [previousIndexPath, selectedIndexPath])
        selectedCategory = categories[selectedIndexPath.item]
        viewModel.changeCategory(to: selectedCategory)
        searchController.isActive = false
        searchController.searchBar.text = ""
        viewModel.search(term: "")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = categories[indexPath.item]
        let label = UILabel()
        label.text = category.displayName
        label.sizeToFit()
        return CGSize(width: label.frame.width + 24, height: 32) 
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = NewsDetailVC(viewModel: NewsDetailVM(article: viewModel.articles[indexPath.row]))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.articles.count - 1 { viewModel.more() }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) { (cell as? NewsCell)?.cancel() }
}


// MARK: - UISearchBarDelegate
extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        if text.isEmpty { viewModel.search(term: "") }
        else if text.count >= 3 { viewModel.search(term: text) }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) { viewModel.search(term: "") }
}

// MARK: Objective Methods
@objc private extension HomeVC {
    func refreshData() { viewModel.input?.more() }
}

extension HomeVC {
    func scrollToTop() {
        if tableView.numberOfRows(inSection: 0) > 0 { tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true) }
        categoryCollectionView.setContentOffset(.zero, animated: true)
    }
}
