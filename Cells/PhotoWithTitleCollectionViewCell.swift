//
//  PhotoWithTitleCollectionViewCell.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

protocol ReusableView: AnyObject {
    static var identifier: String { get }
}

class PhotoWithTitleCollectionViewCell: UICollectionViewCell {
    
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.clipsToBounds = false
        return view
    }()
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(data: Item) {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubview(container)
        container.addSubview(photoImageView)
        container.addSubview(titleLabel)
        setupConstraints()
        titleLabel.text = data.titleLabel
        photoImageView.downloadImage(urlString: data.photoImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            photoImageView.topAnchor.constraint(equalTo: container.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6),
            
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

extension PhotoWithTitleCollectionViewCell {
    struct Item {
        var photoImage: String
        var titleLabel: String
        
        init(photoImage: String, titleLabel: String) {
            self.titleLabel = titleLabel
            self.photoImage = photoImage
        }
    }
}

extension PhotoWithTitleCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}


