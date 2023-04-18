import UIKit

protocol DetailsViewModel: AnyObject {
    func prepareDetails(with id: String)
    func configureImage(completion: @escaping (UIImage) -> Void)
    
    var updateUIElements: ((Photo) -> Void?)? { get set }
    var updateImage: ((UIImage) -> Void)? { get set }
    
    var detailsRouter: DetailslRouter? { get set }
}

final class DetaislViewModelImplementation: DetailsViewModel {
    var detailsRouter: DetailslRouter?
    var updateUIElements: ((Photo) -> Void?)?
    var updateImage: ((UIImage) -> Void)?
    private let networkingService: NetworkingService
    
    //MARK: - LifeCycle
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -Methdos
    
    func configureImage(completion: @escaping(UIImage) -> Void){
        if let url = PhotoDetails.photoDetails?.urls.small{
            networkingService.configureImage(with: url, completion: completion)
        }
    }
    
    func prepareDetails(with id: String) {
        PhotoDetails.photoDetails = nil
        DispatchQueue.global().async {
            self.networkingService.fetchDataWithId(id: id, completion: { result in
                PhotoDetails.photoDetails = result
            })
            DispatchQueue.main.async{
                if let photo = PhotoDetails.photoDetails{
                    self.updateUIElements?(photo)
                    if let updateImage = self.updateImage {
                        self.configureImage(completion: updateImage)
                    }
                }
            }
        }
    }
    
}
