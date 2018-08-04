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
            if let imageData = businessCard?.imageData {
                businessCardLogoImageView.image = UIImage(data: imageData)
                setupCircularLogoStyle()
            }
            
            fullNameTextField.text = businessCard?.fullName
            jobTitleTextField.text = businessCard?.jobTitle
            phoneTextField.text = businessCard?.phone
            emailTextField.text = businessCard?.email
            websiteTextField.text = businessCard?.website
            addressTextField.text = businessCard?.address
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
        label.text = "Full name"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter full name"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let jobTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Title"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter job title"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Phone"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter phone"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.text = "Website"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let websiteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter website"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter address"
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
        
        if let businessCardLogo = businessCardLogoImageView.image {
            let imageData = UIImageJPEGRepresentation(businessCardLogo, 0.8)
            businessCard.setValue(imageData, forKey: "imageData")
        }
        
        businessCard.setValue(fullNameTextField.text, forKey: "fullName")
        businessCard.setValue(jobTitleTextField.text, forKey: "jobTitle")
        businessCard.setValue(phoneTextField.text, forKey: "phone")
        businessCard.setValue(emailTextField.text, forKey: "email")
        businessCard.setValue(websiteTextField.text, forKey: "website")
        businessCard.setValue(addressTextField.text, forKey: "address")

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
        
        if let businessCardLogo = businessCardLogoImageView.image {
            let imageData = UIImageJPEGRepresentation(businessCardLogo, 0.8)
            businessCard?.imageData = imageData
        }
        
        businessCard?.fullName = fullNameTextField.text
        businessCard?.jobTitle = jobTitleTextField.text
        businessCard?.phone = phoneTextField.text
        businessCard?.email = emailTextField.text
        businessCard?.website = websiteTextField.text
        businessCard?.address = addressTextField.text
        
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
        whiteBackgroung.heightAnchor.constraint(equalToConstant: 420).isActive = true
        
        // image view
        view.addSubview(businessCardLogoImageView)
        businessCardLogoImageView.topAnchor.constraint(equalTo: lightRed.bottomAnchor, constant: 10).isActive = true
        businessCardLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true // center the image
        businessCardLogoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        businessCardLogoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        // full name label
        view.addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: businessCardLogoImageView.bottomAnchor).isActive = true
        fullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X notch
        fullNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //fullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // full name text field
        view.addSubview(fullNameTextField)
        fullNameTextField.topAnchor.constraint(equalTo: businessCardLogoImageView.bottomAnchor).isActive = true
        fullNameTextField.leftAnchor.constraint(equalTo: fullNameLabel.rightAnchor).isActive = true // important one!
        fullNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // job title label
        view.addSubview(jobTitleLabel)
        jobTitleLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor).isActive = true
        jobTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 because of the iPhone X
        jobTitleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //jobTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        jobTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // job title text field
        view.addSubview(jobTitleTextField)
        jobTitleTextField.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor).isActive = true
        jobTitleTextField.leftAnchor.constraint(equalTo: jobTitleLabel.rightAnchor).isActive = true // important one
        jobTitleTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        jobTitleTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // phone label
        view.addSubview(phoneLabel)
        phoneLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor).isActive = true
        phoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X
        phoneLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //phoneLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // phone text field
        view.addSubview(phoneTextField)
        phoneTextField.topAnchor.constraint(equalTo: jobTitleTextField.bottomAnchor).isActive = true
        phoneTextField.leftAnchor.constraint(equalTo: phoneLabel.rightAnchor).isActive = true //important one
        phoneTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // email label
        view.addSubview(emailLabel)
        emailLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X
        emailLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // email text field
        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true // important one
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // website label
        view.addSubview(websiteLabel)
        websiteLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        websiteLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X
        websiteLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //websiteLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        websiteLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // website text field
        view.addSubview(websiteTextField)
        websiteTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        websiteTextField.leftAnchor.constraint(equalTo: websiteLabel.rightAnchor).isActive = true // important one
        websiteTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        websiteTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // address label
        view.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: websiteLabel.bottomAnchor).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X
        addressLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //addressLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // address text field
        view.addSubview(addressTextField)
        addressTextField.topAnchor.constraint(equalTo: websiteTextField.bottomAnchor).isActive = true
        addressTextField.leftAnchor.constraint(equalTo: addressLabel.rightAnchor).isActive = true // important one
        addressTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
