import UIKit
import RealmSwift

final class CustomPopUp: NSObject {
    
    unowned private var controller : DetailsViewController!
    
    //MARK: - UI elements
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    
    private let popUpView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#F3F3F3")
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    func showPopUp(on viewController: DetailsViewController){

        controller = viewController
        guard let targetView = controller.view else {
            return
        }
        
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(popUpView)
        
        //UI elements via frame
        popUpView.frame = CGRect(
            x: 30,
            y: (backgroundView.frame.size.height - 170)/2,
            width: backgroundView.frame.size.width-60,
            height: 170)
        
        let titleLabel = UILabel(frame: CGRect(
            x: 37,
            y: 16,
            width: popUpView.frame.size.width - 74,
            height: 36))
        
        
        let okButton = UIButton(frame: CGRect(
            x: (popUpView.frame.size.width - 310)/2,
            y: (popUpView.frame.size.height-86),
            width: 145,
            height: 60))
        
        let cancelButton = UIButton(frame: CGRect(
            x: (popUpView.frame.size.width - 310)/2 + okButton.frame.size.width + 20,
            y: (popUpView.frame.size.height-86),
            width: 145,
            height: 60))
        
        if controller.isFavourite {
            titleLabel.text = "Remove from favourites"
        } else {
            titleLabel.text = "Add to favourites"
        }
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont.customFont(type: .bold, size: 25)
        titleLabel.textColor = .black
        titleLabel.backgroundColor = UIColor(hexString: "#F3F3F3")
        titleLabel.textAlignment = .center
        
        okButton.setTitle("Yes", for: .normal)
        okButton.titleLabel?.font = UIFont.customFont(type: .bold, size: 22)
        okButton.setTitleColor( UIColor.black, for: .normal)
        okButton.layer.cornerRadius = 30
        okButton.backgroundColor = .white
        okButton.layer.borderWidth = 3
        okButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        
        cancelButton.setTitle("No", for: .normal)
        cancelButton.titleLabel?.font = UIFont.customFont(type: .bold, size: 22)
        cancelButton.setTitleColor( UIColor.black, for: .normal)
        cancelButton.layer.cornerRadius = 30
        cancelButton.backgroundColor = .white
        cancelButton.layer.borderWidth = 3
        cancelButton.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.8).cgColor
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        
        popUpView.addSubview(titleLabel)
        popUpView.addSubview(okButton)
        popUpView.addSubview(cancelButton)

        self.backgroundView.alpha = 0.6
    }
    
    @objc func okPressed(){
        let realm = try! Realm()
        realm.beginWrite()
        let id = PersistedFavouriteData()
        id.id = controller.id
        
        if controller.favouriteButton.tintColor == .systemRed{
            realm.delete(realm.objects(PersistedFavouriteData.self).where{$0.id == controller.id}.first!)
            controller.favouriteButton.tintColor = .systemGray
            controller.isFavourite = false
            if let index = FavouritesData.favouritesData.firstIndex(of: controller.id){
                FavouritesData.favouritesData.remove(at: index)
            }
        } else {
            realm.add(id)
            controller.isFavourite = true
            controller.favouriteButton.tintColor = .systemRed
            FavouritesData.favouritesData.append(controller.id)
        }
        try! realm.commitWrite()
        
        self.popUpView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
    
    @objc private func cancelPressed(){
        self.popUpView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}
