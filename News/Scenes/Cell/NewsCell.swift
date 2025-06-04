//
//  NewsCell.swift
//  News
//
//  Created by Sami Gündoğan on 4.06.2025.
//

import Kingfisher
import SnapKit
import UIKit

final class NewsCell: UITableViewCell {
    
    // MARK: Properties
    
    private lazy var newsImage: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo.artframe")
        
        return imageView
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
        let seperator = UIView()
        seperator.layer.cornerRadius = 4
        seperator.backgroundColor = .separator
        
        return seperator
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
}
