//
//  DetailsViewController.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var prevButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowtriangle.backward.fill"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.addTarget(self, action: #selector(prevTapped), for: .allTouchEvents)
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.addTarget(self, action: #selector(nextTapped), for: .allTouchEvents)
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: l)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var sourceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("show source", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sourceTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(prevButton)
        view.addSubview(collectionView)
        view.addSubview(nextButton)
        view.addSubview(sourceButton)
        view.addSubview(activityIndicator)
        setupConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoWithTitleCollectionViewCell.self, forCellWithReuseIdentifier: PhotoWithTitleCollectionViewCell.identifier)
    }
    
    @objc func sourceTapped() {
        navigationController?.pushViewController(WebViewViewController(photoLink: viewModel.photos[viewModel.indexPath].link), animated: true)
    }
    
    @objc func prevTapped() {
        guard let i = collectionView.indexPathsForVisibleItems.first else { return }
        
        if  viewModel.photos.indices.contains(i.row - 1) == true {
            collectionView.scrollToItem(at: .init(row: i.row - 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func nextTapped() {
        guard let i = collectionView.indexPathsForVisibleItems.first else { return }
        
        if  viewModel.photos.indices.contains(i.row + 1) == true {
            collectionView.scrollToItem(at: .init(row: i.row + 1, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            prevButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            prevButton.widthAnchor.constraint(equalToConstant: 40),
            prevButton.heightAnchor.constraint(equalToConstant: 40),
            
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),
            collectionView.widthAnchor.constraint(equalToConstant: 250),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            nextButton.widthAnchor.constraint(equalToConstant: 40),
            nextButton.heightAnchor.constraint(equalToConstant: 40),
            nextButton.centerYAnchor.constraint(equalTo: prevButton.centerYAnchor),
            
            sourceButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            sourceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sourceButton.widthAnchor.constraint(equalToConstant: 300),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWithTitleCollectionViewCell.identifier, for: indexPath) as? PhotoWithTitleCollectionViewCell else { return UICollectionViewCell() }
        let data = viewModel.photos[indexPath.row]
        viewModel.indexPath = indexPath.row
        cell.configure(data: .init(photoImage: data.thumbnail ?? "", titleLabel: data.title ?? ""))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}


