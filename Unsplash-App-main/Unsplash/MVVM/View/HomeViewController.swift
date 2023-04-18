//
//  HomeViewController.swift
//  Unsplash
//
//  Created by Аброрбек on 06.01.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Constants
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 20
    }
    
    //MARK: - Properties
    
    var homeViewModel: HomeViewModel
    
    //MARK: - LifeCycle
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRandomData()
        setupViewModel()
        setupCollectionView()
        setupSearchBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    //MARK: - Setup
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        [searchBar, collectionView].forEach{view.addSubview($0)}
    }
    
    private func setupViewModel() {
        homeViewModel.reloadCollectionView = {
            self.collectionView.reloadData()
        }
    }
    
    private func setupSearchBar(){
        searchBar.delegate = self
    }
    
    private func setupCollectionView(){ //
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: view.frame.size.width/2-25, height: view.frame.size.width/2-25) //25 = (20+10+20)/2 horizontal margins and space between items
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsVerticalScrollIndicator = false
        collection.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
        self.collectionView = collection
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalMargin),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalMargin),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Methods
    
    private func fetchRandomData(){
        homeViewModel.fetchRandomData()
    }

    //MARK: - UI Elements
    
    private var collectionView: UICollectionView!
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundColor = .systemBackground
        
        return search
    }()
    
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.getNumberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let completion = cell.configure()
        homeViewModel.configureImage(with: indexPath.row, completion: completion)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeViewModel.openDetailsViewController(wiht: indexPath.row)
    } 
}

//MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            homeViewModel.fetchDataWithQuery(with: text)
        }
    }
}
