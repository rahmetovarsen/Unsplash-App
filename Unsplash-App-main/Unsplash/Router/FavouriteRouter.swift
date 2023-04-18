//
//  FavouriteRouter.swift
//  Unsplash
//
//  Created by Аброрбек on 10.01.2023.
//

import UIKit

protocol FavouriteRouter: AnyObject {
    func pushView(with id: String)
}

final class FavouriteRouterImplementation: FavouriteRouter {
    
    //MARK: - Properties
    
    var favouriteView: FavouriteViewController
    private weak var favouriteViewModel: FavouriteViewModel?
    private var detailsRouter: DetailslRouter?
    
    private let networkingService: NetworkingService
    
    //MARK: - LifeCycle
    
    init(networkingService: NetworkingService){
        self.networkingService = networkingService
        let viewModel = FavouriteViewModelImplementation(networkingService: networkingService)
        self.favouriteViewModel = viewModel
        favouriteView = FavouriteViewController(favouriteViewModel: viewModel)
        favouriteView.favouriteViewModel.favouriteRouter = self
    }
    
    //MARK: - Methods
    
    func pushView(with id: String){
        detailsRouter = DetailslRouterImplementation(id: id, networkingService: networkingService)
        if let vc = detailsRouter?.detailsView {
            favouriteView.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
