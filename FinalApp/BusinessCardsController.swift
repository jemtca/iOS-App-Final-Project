//
//  ViewController.swift
//  FinalApp
//

import UIKit

class BusinessCardsController: UITableViewController {

    let businessCards = [
            BusinessCard(fullName: "fullName1", jobTitle: "jobTitle1", phone: "phone1", email: "email1", website: nil, address: "address1"),
            BusinessCard(fullName: "fullName2", jobTitle: "jobTitle2", phone: "phone2", email: "email2", website: nil, address: "address2"),
            BusinessCard(fullName: "fullName3", jobTitle: "jobTitle3", phone: "phone3", email: "email3", website: nil, address: "address3"),
            BusinessCard(fullName: "fullName4", jobTitle: "jobTitle4", phone: "phone4", email: "email4", website: nil, address: "address4")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Business Cards"
        
        tableView.backgroundColor = UIColor.mercury
        // hiding the separators
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.separatorColor = UIColor.black
        // it doesn't show the separators outside of the table view
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleAddBC))
    }
    
    @objc func handleAddBC() {
        print("Adding BC...")
        
        let createBC = CreateBusinessCardController()
        
        let navController = CustomNavigationController(rootViewController: createBC)
        
        present(navController, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.lightRed
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.backgroundColor = UIColor.white
        
        let businesCard = businessCards[indexPath.row]
        
        cell.textLabel?.text = businesCard.fullName
        //cell.textLabel?.textColor = UIColor.mercury
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessCards.count
    }

}
