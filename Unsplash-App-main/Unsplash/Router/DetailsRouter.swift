

import UIKit

protocol DetailslRouter: AnyObject {
    var detailsView: DetailsViewController { get set }
}

final class DetailslRouterImplementation: DetailslRouter {
    
    //MARK: - Properties
    
    var detailsView: DetailsViewController
    private weak var detailsViewModel: DetailsViewModel?
    private let networkingService: NetworkingService
    
    //MARK: - LifeCycle
    
    init(id: String, networkingService: NetworkingService){
        self.networkingService = networkingService
        let viewModel = DetaislViewModelImplementation(networkingService: networkingService)
        self.detailsViewModel = viewModel
        detailsView = DetailsViewController(id: id, detailsViewModel: viewModel)
        detailsView.detailsViewModel.detailsRouter = self
    }
}
