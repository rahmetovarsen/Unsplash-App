
import UIKit

final class DetailsViewController: UIViewController {
    
    //MARK: - Constants
    
    private enum Constants {
        static let imageHeight: CGFloat = 250
        static let imageWidth: CGFloat = 250
        
        static let labelHeight: CGFloat = 50
        static let labelWidth: CGFloat = 200
    }
    
    //MARK: - Properties
    
    var detailsViewModel: DetailsViewModel
    let id: String
    var isFavourite = false

    //MARK: - LifeCycle
    
    init(id: String, detailsViewModel: DetailsViewModel){
        self.detailsViewModel = detailsViewModel
        self.id = id
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkFavourite()
        prepareDetails()
        setupView()
        setupViewModel()
        setupNavigationBar()
        setupLayout()
        setupTargets()
        setupFavouriteButton()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    //MARK: - Setup
    
    private func setupView(){
        view.backgroundColor = .systemBackground
        [imageView, authorLabel, dateLabel, locationLabel, downloadsLabel, favouriteButton].forEach{view.addSubview($0)}
    }
    
    private func setupNavigationBar(){
        let image = UIImage(systemName: "xmark")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(dismissButton))
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupFavouriteButton(){
        if isFavourite {
            favouriteButton.tintColor = .systemRed
        } else {
            favouriteButton.tintColor = .systemGray
        }
    }
    
    private func setupTargets(){
        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
    }
    //mvvm?
    private func setupViewModel(){
        detailsViewModel.updateImage = { (image) in
            self.imageView.image = nil
            self.imageView.image = image
        }
        detailsViewModel.updateUIElements = { (result) in
            self.authorLabel.text = "Author: \(result.user.name)"
            
            var newDate = ""
            for each in result.created_at {
                if each == "T"{
                    break
                }
                newDate.append(each)
            }
            self.dateLabel.text = "Date: \(newDate)"
            
            if let location = result.location.city {
                self.locationLabel.text = "Location: \(location)"
            } else {
                self.locationLabel.text = "Location: Seoul"
            }
            self.downloadsLabel.text = "Downloads: \(result.downloads)"
            self.detailsViewModel.configureImage
                { (image) in
                    self.imageView.image = nil
                    self.imageView.image = image
                }
            return nil
        }
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            
            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 25),
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            authorLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            authorLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 25),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            dateLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            dateLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25),
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            locationLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            locationLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            
            downloadsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 25),
            downloadsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            downloadsLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            downloadsLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40),
            
            favouriteButton.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -5),
            favouriteButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            
            favouriteButton.heightAnchor.constraint(equalToConstant: 50),
            favouriteButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    //MARK: - Private Methods
    
    private func prepareDetails(){ // Fetchs data and updates UI
        detailsViewModel.prepareDetails(with: id)
    }
    
    private func checkFavourite(){
        for id in FavouritesData.favouritesData {
            if self.id == id {
                isFavourite = true
            }
        }
    }
    
    //MARK: - Objc Methods
    private let customPopUp = CustomPopUp() // Initialised custom popup
    @objc private func favouriteButtonPressed(){
        customPopUp.showPopUp(on: self)
    }
    
    @objc private func dismissButton(){
        PhotoDetails.photoDetails = nil
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.remove(at: navigationArray.count - 1) // To remove current UIViewController
        self.navigationController?.viewControllers = navigationArray
    }
    
    //MARK: - UI Elements
    
    lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
        
        return button
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemGray.withAlphaComponent(0.3)
        
        return image
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Author: "
        label.font = .customFont(type: .medium, size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Date: "
        label.font = .customFont(type: .medium, size: 25)
        label.textColor = .label
        
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Location: "
        label.font = .customFont(type: .medium, size: 25)
        label.textColor = .label
        
        return label
    }()
    
    private let downloadsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "Downloads: "
        label.font = .customFont(type: .medium, size: 25)
        label.textColor = .label
        
        return label
    }()
}
