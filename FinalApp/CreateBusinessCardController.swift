//
//  CreateBusinessCardController.swift
//  FinalApp
//

import UIKit

class CreateBusinessCardController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Business Card"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = UIColor.mercury
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
