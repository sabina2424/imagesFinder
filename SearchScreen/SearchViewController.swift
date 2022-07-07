//
//  SearchViewController.swift
//  ImagesFinder
//
//  Created by 003995_Mac on 04.07.22.
//

import UIKit

class SearchViewController: UIViewController {
    
    let viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let filter = [ButtonModel(title: .init(rawValue: "size")), ButtonModel(title: .init(rawValue: "country")), ButtonModel(title: .init(rawValue: "language"))]
    
    lazy var containerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.placeholder = "Search photo..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 15)
        textField.returnKeyType = .search
        textField.layer.cornerRadius = 8
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.clearButtonMode = .whileEditing
        textField.backgroundColor = #colorLiteral(red: 0.9607003331, green: 0.9608382583, blue: 0.9606701732, alpha: 1)
        textField.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        textField.layer.borderWidth = 0.5
        textField.delegate = self
        return textField
    }()
    
    lazy var toolsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tools", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .allTouchEvents)
        return button
    }()
    
    
    lazy var collectionView: UICollectionView = {
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        setupView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filterStackView.isHidden = true
    }
    
    private func setupViewModel() {
        viewModel.changeHandler = { [weak self] state in
            guard let self = self else { return }
            self.render(state: state)
        }
    }
    
    private func render(state: SearchState) {
        switch state {
        case .loaded:
            self.collectionView.reloadData()
        case .error(let error):
            self.showAlert(title: error?.errorDescription,
                           message: error?.failureReason,
                           buttonTitle: "Cancel",
                           style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        case .isFetching(let isFetching):
            DispatchQueue.main.async {
                isFetching ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func buttonTapped() {
        filterStackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        filterStackView.isHidden = false
        setupFilters(filter: filter)
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoWithTitleCollectionViewCell.self, forCellWithReuseIdentifier: PhotoWithTitleCollectionViewCell.identifier)
         [containerStack, collectionView, activityIndicator].forEach { item in
            view.addSubview(item)
        }
        containerStack.addArrangedSubview(searchStackView)
        containerStack.addArrangedSubview(filterStackView)
        searchStackView.addArrangedSubview(textField)
        searchStackView.addArrangedSubview(toolsButton)
        activityIndicator.frame = self.view.bounds
        setupConstraints()
    }
    
    func setupFilters(filter: [ButtonModel]) {
        for (index, value) in filter.enumerated() {
            let button = UIButton()
            button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            button.layer.cornerRadius = 8
            button.setTitle(value.title?.rawValue, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tag = index
            filterStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(handleFilterTap), for: .touchUpInside)
            
        }
    }
    
    @objc func handleFilterTap(sender: UIButton) -> UIMenu {
        var filterActions: [UIMenuElement] = []
        switch filter[sender.tag].title {
        case .size:
            SizeFilter.allCases.forEach { size in
                filterActions.append(UIAction(title: size.rawValue, handler: { _ in
                    print("size is selected")
                }))
            }
            
            let menu = UIMenu(title: "Size", children: filterActions)
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
            
            return menu
            
        case .country:
            var countryJson: [CountryFilter]?
            if let url = Bundle.main.url(forResource: Constants.countries, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let json = try decoder.decode([CountryFilter].self, from: data)
                    countryJson = json
                } catch {
                    print("Decoding CountryFilter failed")
                }
            }
            
            countryJson?.forEach({ json in
                filterActions.append(UIAction(title: json.countryName, handler: { _ in
                    print("country is selected")
                }))
            })
            
            let menu = UIMenu(title: "Country", identifier: nil, options: [], children: filterActions)
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
            return menu
            
        case .language:
            var languageJson: [LanguageFilter]?
            if let url = Bundle.main.url(forResource: Constants.languages, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let json = try decoder.decode([LanguageFilter].self, from: data)
                    languageJson = json
                } catch {
                    print("Decoding LanguageFilter failed")
                }
            }
            languageJson?.forEach({ json in
                filterActions.append(UIAction(title: json.languageName, handler: { _ in
                   print("language is selected")
                }))
            })
            
            let menu = UIMenu(title: "Languages", identifier: nil, options: [], children: filterActions)
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
            return menu
            
        default:
            return UIMenu()
        }
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 16),
            containerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            containerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            collectionView.topAnchor.constraint(equalTo: containerStack.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWithTitleCollectionViewCell.identifier, for: indexPath) as? PhotoWithTitleCollectionViewCell else { return UICollectionViewCell() }
        let data = viewModel.photos[indexPath.item]
        cell.configure(data: .init(photoImage: data.thumbnail ?? "", titleLabel: data.title ?? ""))
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row, viewModel.photos.count - 1)
        if indexPath.row == viewModel.photos.count - 1  {
            viewModel.currentPage += 1
            self.viewModel.fetchData(pagination: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
 
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let details = DetailsViewController(viewModel: DetailsViewModel(photos: viewModel.photos, indexPath: indexPath.item))
        self.navigationController?.pushViewController(details, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        viewModel.inputData.image = text
        viewModel.photos = []
        viewModel.fetchData(pagination: false)
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.photos = []
        collectionView.reloadData()
        return true
    }
}
