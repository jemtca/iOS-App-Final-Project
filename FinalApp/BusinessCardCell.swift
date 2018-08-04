//
//  BusinessCardCell.swift
//  FinalApp
//

import UIKit

class BusinessCardCell: UITableViewCell {
    
    var businessCard: BusinessCard? {
        didSet {
            if let imageData = businessCard?.imageData {
                businessCardLogoView.image = UIImage(data: imageData)
            }
            fullNameLabel.text = businessCard?.fullName
        }
    }
    
    let businessCardLogoView: UIImageView = {
        // image by default
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_logo_empty"))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        // enable autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        //label.text = "Test"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //backgroundColor = UIColor.mercury
        
        addSubview(businessCardLogoView)
        businessCardLogoView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        businessCardLogoView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        businessCardLogoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40).isActive = true
        businessCardLogoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(fullNameLabel)
        fullNameLabel.leftAnchor.constraint(equalTo: businessCardLogoView.rightAnchor, constant: 20).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fullNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        fullNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
