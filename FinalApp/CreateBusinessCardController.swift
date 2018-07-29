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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        // code inside the clousure to save first then see the animation
        // inside the clousure self it needed to avoid retain cycle
//        dismiss(animated: true) {
//            guard let name = self.fullNameTextField.text else { return }
//            let businessCard = BusinessCard(fullName: name)
//            //self.businessCardsController?.addBusinessCard(businessCard: businessCard)
//            self.delegate?.didAddBusinessCard(businessCard: businessCard)
//        }
        
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
    
}
