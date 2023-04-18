//
//  CustomTableViewCell.swift
//  Unsplash
//
//  Created by Аброрбек on 06.01.2023.
//

    import UIKit

    final class CustomTableViewCell: UITableViewCell {

    static let identifier = String(describing: CustomTableViewCell.self)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        setupView()
        setupLayout()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        favouriteImageView.image = nil
    }
    //MARK: - Setup

    private func setupView(){
        contentView.addSubview(favouriteImageView)
        contentView.addSubview(nameLabel)
    }

    private func setupLayout(){
        NSLayoutConstraint.activate([
            favouriteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            favouriteImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            favouriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favouriteImageView.widthAnchor.constraint(equalToConstant: contentView.frame.size.height - 10),
            
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: favouriteImageView.trailingAnchor, constant: 20),
            nameLabel.widthAnchor.constraint(equalToConstant: (contentView.frame.size.width - contentView.frame.size.height - 40)),
        ])

    }

    //MARK: - Methods
    
    func configureImageCompletion() -> ((UIImage) -> Void){
        let completion: (UIImage) -> Void  = { (image) in
            self.favouriteImageView.image = nil
            self.favouriteImageView.image = image
        }
        return completion
    }
        
    func configureLabelCompletion() -> ((String) -> Void){
        let completion: (String) -> Void  = { (name) in
            self.nameLabel.text = name
        }
        return completion
    }

    //MARK: - UI Elements

    private let favouriteImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true

        return image
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        label.font = UIFont.customFont(type: .bold, size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label

        return label
    }()
}

