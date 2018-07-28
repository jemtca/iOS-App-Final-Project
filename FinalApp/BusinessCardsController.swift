//
//  ViewController.swift
//  FinalApp
//

import UIKit
import CoreData

class BusinessCardsController: UITableViewController, CreateBusinessCardControllerDelegate {
    
    func didAddBusinessCard(businessCard: BusinessCard) {
        // modify array
        businessCards.append(businessCard)
        
        // insert a new index path into tableView
        let indexPath = IndexPath(row: businessCards.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }

    // var because the array has to change (adding/deleting elements from the array)
    var businessCards = [BusinessCard]() // empty array
    
//    func addBusinessCard(businessCard: BusinessCard) {
//        // modify array
//        businessCards.append(businessCard)
//
//        // insert a new index path into tableView
//        let indexPath = IndexPath(row: businessCards.count - 1, section: 0)
//        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
//    }
    
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
        let createBC = CreateBusinessCardController()
        
        let navController = CustomNavigationController(rootViewController: createBC)
        
        //createBC.businessCardsController = self // link
        createBC.delegate = self
        
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
