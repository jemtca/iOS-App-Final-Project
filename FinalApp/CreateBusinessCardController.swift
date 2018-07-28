//
//  CreateBusinessCardController.swift
//  FinalApp
//

import UIKit
import CoreData

// custom delegation
protocol CreateBusinessCardControllerDelegate {
    func didAddBusinessCard(businessCard: BusinessCard)
}

class CreateBusinessCardController: UIViewController {
    
    // link between BusinessCardController and CreateBusinessCardController
    //var businessCardsController: BusinessCardsController?
    
    var delegate: CreateBusinessCardControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        // enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        // enable autolayout
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationItem.title = "Create Business Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleSave))
        view.backgroundColor = UIColor.mercury
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
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true // 50 beacause of the iPhone X notch
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // name text field
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: whiteBackgroung.topAnchor).isActive = true // important one!
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true // important one!
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: whiteBackgroung.bottomAnchor).isActive = true // important one!
//        nameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true // same as before
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        // code inside the clousure to save first then see the animation
        // inside the clousure self it needed to avoid retain cycle
//        dismiss(animated: true) {
//            guard let name = self.nameTextField.text else { return }
//            let businessCard = BusinessCard(fullName: name)
//            //self.businessCardsController?.addBusinessCard(businessCard: businessCard)
//            self.delegate?.didAddBusinessCard(businessCard: businessCard)
//        }
        
        // initialization of Core Data stack
        let persistentContainer = NSPersistentContainer(name: "FinalApp")
        persistentContainer.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        
        let context = persistentContainer.viewContext
        
        let businessCard = NSEntityDescription.insertNewObject(forEntityName: "BusinessCard", into: context)
        
        businessCard.setValue(nameTextField.text, forKey: "fullName")
        
        // perform save
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to save business card: \(saveErr)")
        }
        
    }
    
}
