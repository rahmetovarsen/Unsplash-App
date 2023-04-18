//
//  HomeViewModel.swift
//  Unsplash
//
//  Created by Аброрбек on 08.01.2023.
//

import UIKit

protocol HomeViewModel: AnyObject {
    func fetchRandomData()
    func fetchDataWithQuery(with text: String)
    func viewDidAppear()
    func getNumberOfPhotos() -> Int
    func getUrl(with index: Int) -> String
    func openDetailsViewController(wiht index: Int)
    func configureImage(with index: Int, completion: @escaping(UIImage) -> Void)
    
    var reloadCollectionView: (() -> Void)? { get set }
    var homeRouter: HomeRouter? { get set }
}

final class HomeViewModelImplementation: HomeViewModel {
    
    var reloadCollectionView: (() -> Void)?
    
    var homeRouter: HomeRouter?
    private let networkingService: NetworkingService
    
    //MARK: - LifeCycle
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func fetchRandomData() {
        DispatchQueue.global().async {
            self.networkingService.fetchDataWithQuery(query: "Random")
            DispatchQueue.main.async {
                self.reloadCollectionView?()
            }
        }
    }
    func fetchDataWithQuery(with text: String){
        PhotoCollection.photoCollection = []
        reloadCollectionView?()
        
        DispatchQueue.global().async {
            self.networkingService.fetchDataWithQuery(query: text)
            DispatchQueue.main.async {
                self.reloadCollectionView?()
            }
        }
    }
    
    func configureImage(with index: Int, completion: @escaping(UIImage) -> Void){
        let url = PhotoCollection.photoCollection[index].urls.small
        DispatchQueue.global().async {
            self.networkingService.configureImage(with: url, completion: completion)
        }
    }
    
    func viewDidAppear() {
        fetchRandomData()
    }
    
    func getNumberOfPhotos() -> Int{
        return PhotoCollection.photoCollection.count
    }
    
    func getUrl(with index: Int) -> String {
        return PhotoCollection.photoCollection[index].urls.small
    }
    
    func openDetailsViewController(wiht index: Int) {
        let id = PhotoCollection.photoCollection[index].id
        homeRouter?.pushView(with: id)
    }
}
