//
//  HomeRouter.swift
//  Unsplash
//
//  Created by Аброрбек on 08.01.2023.
//

import UIKit

protocol HomeRouter: AnyObject {
    func pushView(with id: String)
}

final class HomeRouterImplementation: HomeRouter {
    
    //MARK: - Properties
    
    var homeView: HomeViewController
    private weak var homeViewModel: HomeViewModel?
    private var detailsRouter: DetailslRouter?
    
    private let networkingService: NetworkingService
    
    //MARK: - LifeCycle
    
    init(networkingService: NetworkingService){
        self.networkingService = networkingService
        let homeViewModel = HomeViewModelImplementation(networkingService: networkingService)
        self.homeViewModel = homeViewModel
        homeView = HomeViewController(homeViewModel: homeViewModel)
        homeView.homeViewModel.homeRouter = self
    }
    
    //MARK: - Methods
    
    func pushView(with id: String){
        detailsRouter = DetailslRouterImplementation(id: id, networkingService: networkingService)
        if let vc = detailsRouter?.detailsView {
            homeView.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
