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

class CreateBusinessCardController: UIViewController {
    
    var delegate: CreateBusinessCardControllerDelegate?
    
    var businessCard: BusinessCard? {
        didSet {
            fullNameTextField.text = businessCard?.fullName
        }
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
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
        
        // white background for the name label
        let whiteBackgroung = UIView()
        whiteBackgroung.backgroundColor = UIColor.white
        whiteBackgroung.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(whiteBackgroung)
        whiteBackgroung.topAnchor.constraint(equalTo: lightRed.bottomAnchor).isActive = true // important one!
        whiteBackgroung.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        whiteBackgroung.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        whiteBackgroung.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // name label
        view.addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fullNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X notch
        fullNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //fullNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // name text field
        view.addSubview(fullNameTextField)
        fullNameTextField.topAnchor.constraint(equalTo: whiteBackgroung.topAnchor).isActive = true // important one!
        fullNameTextField.leftAnchor.constraint(equalTo: fullNameLabel.rightAnchor).isActive = true // important one!
        fullNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        fullNameTextField.bottomAnchor.constraint(equalTo: whiteBackgroung.bottomAnchor).isActive = true // important one!
//        fullNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true // same as before
    }
    
}
