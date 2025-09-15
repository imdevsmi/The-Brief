//
//  NewsCell.swift
//  The Brief
//
//  Created by Sami Gündoğan on 4.06.2025.
//

import Kingfisher
import SnapKit
import UIKit

final class NewsCell: UITableViewCell {
    
    static let reuseIdentifier = "NewsCell"
    private var url: String?
    private var article: Article?
    
    // MARK: Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 16, bottom: 24, trailing: 16)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: Properties
    private lazy var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo.artframe")
        
        return imageView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        button.setImage( UIImage(systemName: "ellipsis")?.withTintColor(.label),for: .normal)
        button.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        
        return button
    }()
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let hourSeperatorView: UIView = {
        let hour = UIView()
        hour.layer.cornerRadius = 4
        hour.backgroundColor = .separator
        
        return hour
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .systemGray6
        
        return separator
    }()
}

// MARK: - Private Methods
private extension NewsCell {
    func setupUI() {
        addViews()
        setupLayouts()
    }
    
    func addViews() {
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(hourLabel)
        contentView.addSubview(hourSeperatorView)
        contentView.addSubview(moreButton)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsLabel)
        contentView.addSubview(separatorView)
        newsImage.addSubview(loadingIndicator)
    }
    
    func setupLayouts() {
        newsImage.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView.layoutMarginsGuide)
            make.width.height.equalTo(136)
        }
        newsLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.layoutMarginsGuide)
            make.leading.equalTo(newsImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(newsLabel.snp.bottom).offset(12)
            make.leading.equalTo(newsImage.snp.trailing).offset(12)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
        }
        hourLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(12)
            make.leading.equalTo(newsImage.snp.trailing).offset(12)
            make.height.equalTo(24)
        }
        hourSeperatorView.snp.makeConstraints { make in
            make.leading.equalTo(hourLabel.snp.trailing).offset(12)
            make.centerY.equalTo(hourLabel)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(hourSeperatorView.snp.trailing).offset(12)
            make.centerY.equalTo(hourLabel)
            make.height.equalTo(24)
        }
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalTo(contentView.layoutMarginsGuide)
            make.width.equalTo(24)
        }
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(newsImage.snp.bottom).offset(24).priority(.low)
            make.top.greaterThanOrEqualTo(hourLabel.snp.bottom).offset(24).priority(.high)
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Public Methods
extension NewsCell {
    func setup(with article: Article) {
        self.article = article
        newsLabel.text = article.title
        authorLabel.text = article.author
        hourLabel.text = article.publishedAt?.formattedHourAndMinute()
        dateLabel.text = article.publishedAt?.timeAgoSinceDate()
        url = article.url
        
        loadingIndicator.startAnimating()
        newsImage.setImage(with: article.urlToImage, placeholder: nil, targetSize: nil) { [weak self] in
            self?.loadingIndicator.stopAnimating()
        }
    }

    func cancel() { newsImage.kf.cancelDownloadTask() }

    func clear() { newsImage.image = nil }
}

// MARK: Objective Methods
@objc private extension NewsCell {
    @objc func didTapMoreButton() {
        guard let url = url, let shareUrl = URL(string: url) else { return }
        
        let browser = openBrowser()
        let shareAction = UIAction(title: L("share_text"), image: UIImage(systemName: "square.and.arrow.up")) { _ in
            let browserVC = UIActivityViewController(activityItems: [shareUrl], applicationActivities: [browser])

            if let topController = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })?.rootViewController {
                topController.present(browserVC, animated: true)
            }
        }
        let menu = UIMenu(title: "", children: [shareAction])
        moreButton.menu = menu
        moreButton.showsMenuAsPrimaryAction = true
    }
    
    func didTapFavorite() { guard article != nil else { return } }
}
