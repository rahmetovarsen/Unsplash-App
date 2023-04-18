//
//  FavouriteViewController.swift
//  Unsplash
//
//  Created by Аброрбек on 03.01.2023.
//

import UIKit
import RealmSwift

final class FavouriteViewController: UIViewController {
    
    let favouriteViewModel: FavouriteViewModel
    
    //MARK: - LifeCycle
    
    init(favouriteViewModel: FavouriteViewModel) {
        self.favouriteViewModel = favouriteViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        renderData()
        setupNavigation()
        setupView()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    //MARK: - Setup
    
    private func setupView(){
        view.addSubview(tableView)
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigation(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.customFont(type: .bold, size: 25), NSAttributedString.Key.foregroundColor: UIColor.label]
        
        title = "Favourite"
    }
    
    private func setupLayout(){
        tableView.frame = view.bounds
    }
    //MARK: - Methods
    
    private func renderData(){
        favouriteViewModel.renderData()
    }
    
    //MARK: - UI Elements
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        return table
    }()
}


extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavouritesData.favouritesData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let completion1 = cell.configureImageCompletion()
        let completion2 = cell.configureLabelCompletion()
        
        favouriteViewModel.configureImage(with: indexPath.row, completion1: completion1, completion2: completion2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        favouriteViewModel.openDetailsViewController(with: indexPath.row)
    }
}
