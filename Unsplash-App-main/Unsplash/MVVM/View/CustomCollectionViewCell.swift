//
//  CustomCollectionViewCell.swift
//  Unsplash
//
//  Created by Аброрбек on 04.01.2023.
//

import UIKit

final class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CustomCollectionViewCell.self)
    
    //MARK: -LifeCycle
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    //MARK: - Setup
    
    private func setupView(){
        contentView.addSubview(imageView)
    }
    
    //MARK: - Private Methods
    
    func configure() -> ((UIImage) -> Void){
        let completion: (UIImage) -> Void  = { (image) in
            self.imageView.image = nil
            self.imageView.image = image
        }
        return completion
    }
    
    //MARK: - UI Elements
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .systemGray.withAlphaComponent(0.3)
        
        return image
    }()
    
}
