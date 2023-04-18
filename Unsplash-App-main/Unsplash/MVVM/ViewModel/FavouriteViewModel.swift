//
//  FavouriteViewModel.swift
//  Unsplash
//
//  Created by Аброрбек on 10.01.2023.
//

import UIKit
import RealmSwift

protocol FavouriteViewModel: AnyObject {
    func renderData()
    func configureImage(with index: Int, completion1: @escaping (UIImage) -> Void, completion2: @escaping (String) -> Void)
    func openDetailsViewController(with index: Int)
    
    var favouriteRouter: FavouriteRouter? { get set }
}

final class FavouriteViewModelImplementation: FavouriteViewModel {
    
    private let networkingService: NetworkingService
    var favouriteRouter: FavouriteRouter?
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methdos
    
    func renderData() {
        let realm = try! Realm().objects(PersistedFavouriteData.self)
        FavouritesData.favouritesData = []
        for each in realm{
            FavouritesData.favouritesData.append(each.id)
        }
    }
    
    func openDetailsViewController(with index: Int) {
        let id = FavouritesData.favouritesData[index]
        favouriteRouter?.pushView(with: id)
    }
    
    func configureImage(with index: Int, completion1: @escaping (UIImage) -> Void, completion2: @escaping (String) -> Void){
        DispatchQueue.global().async {
            self.networkingService.fetchDataWithId(id: FavouritesData.favouritesData[index], completion: { result in
                if let result = result {
                    self.networkingService.configureImage(with: result.urls.small, completion: completion1)
                    DispatchQueue.main.async {
                        completion2(result.user.name)
                    }
                }
            })
        }
    }
}
