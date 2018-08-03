//
//  CreateBusinessCardController.swift
//  FinalApp
//

import UIKit
import CoreData

// custom delegation
protocol CreateBusinessCardControllerDelegate {
    func didAddBusinessCard(businessCard: BusinessCard)
    func didEditBusinessCard(businessCard: BusinessCard)
}

class CreateBusinessCardController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: CreateBusinessCardControllerDelegate?
    
    var businessCard: BusinessCard? {
        // this shows the right information when editing
        didSet {
            fullNameTextField.text = businessCard?.fullName
            
            if let imageData = businessCard?.imageData {
                businessCardLogoImageView.image = UIImage(data: imageData)
                setupCircularLogoStyle()
            }
        }
    }
    
    // changed from let to lazy var
    lazy var businessCardLogoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_logo_empty"))
        // enable autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        // make the image view interactive
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editImagine = info[UIImagePickerControllerEditedImage] as? UIImage {
            businessCardLogoImageView.image = editImagine
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            businessCardLogoImageView.image = originalImage
        }
        
        setupCircularLogoStyle()
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func setupCircularLogoStyle() {
        // make the logo circular
        businessCardLogoImageView.layer.cornerRadius = businessCardLogoImageView.frame.width / 2
        businessCardLogoImageView.clipsToBounds = true
        
        // add a frame around the logo
        businessCardLogoImageView.layer.borderColor = UIColor.black.cgColor
        businessCardLogoImageView.layer.borderWidth = 2
    }
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        //navigationItem.title = "Create Business Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSave))
        view.backgroundColor = UIColor.mercury
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if businessCard == nil {
            createBusinessCard()
        }
        else {
            saveBusinessCardChanges()
        }
    }
    
    private func createBusinessCard() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let businessCard = NSEntityDescription.insertNewObject(forEntityName: "BusinessCard", into: context)
        
        businessCard.setValue(fullNameTextField.text, forKey: "fullName")
        
        if let businessCardLogo = businessCardLogoImageView.image {
            let imageData = UIImageJPEGRepresentation(businessCardLogo, 0.8)
            businessCard.setValue(imageData, forKey: "imageData")
        }

        // perform save
        do {
            try context.save()
            // success
            dismiss(animated: true) {
                self.delegate?.didAddBusinessCard(businessCard: businessCard as! BusinessCard)
            }
        } catch let saveErr {
            print("Failed to save business card: \(saveErr)")
        }
    }
    
    private func saveBusinessCardChanges() {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        businessCard?.fullName = fullNameTextField.text
        
        if let businessCardLogo = businessCardLogoImageView.image {
            let imageData = UIImageJPEGRepresentation(businessCardLogo, 0.8)
            businessCard?.imageData = imageData
        }
        
        // perform save after changes
        do {
            try context.save()
            // success
            dismiss(animated: true) {
                self.delegate?.didEditBusinessCard(businessCard: self.businessCard!)
            }
        } catch let saveErr {
            print("Failed to save business card changes \(saveErr)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = businessCard == nil ? "Create Business Card" : "Edit Business Card"
    }
    
    private func setupUI() {
        // header
        let lightRed = UIView()
        lightRed.backgroundColor = UIColor.lightRed
        lightRed.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightRed)
        lightRed.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightRed.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightRed.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightRed.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // white background
        let whiteBackgroung = UIView()
        whiteBackgroung.backgroundColor = UIColor.white
        whiteBackgroung.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(whiteBackgroung)
        whiteBackgroung.topAnchor.constraint(equalTo: lightRed.bottomAnchor).isActive = true // important one!
        whiteBackgroung.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        whiteBackgroung.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        // change this value depending on how many elements on the screen
        whiteBackgroung.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        // image view
        view.addSubview(businessCardLogoImageView)
        businessCardLogoImageView.topAnchor.constraint(equalTo: lightRed.bottomAnchor, constant: 10).isActive = true
        businessCardLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true // center the image
        businessCardLogoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        businessCardLogoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // name label
        view.addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: businessCardLogoImageView.bottomAnchor).isActive = true
        fullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X notch
        fullNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //fullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // name text field
        view.addSubview(fullNameTextField)
        fullNameTextField.topAnchor.constraint(equalTo: businessCardLogoImageView.bottomAnchor).isActive = true
        fullNameTextField.leftAnchor.constraint(equalTo: fullNameLabel.rightAnchor).isActive = true // important one!
        fullNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
