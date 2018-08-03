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
    
    func didEditBusinessCard(businessCard: BusinessCard) {
        // update my tableview
        let row = businessCards.index(of: businessCard)
        let reloadIndexPath = IndexPath(item: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: UITableViewRowAnimation.automatic)
    }

    // var because the array has to change (adding/deleting elements from the array)
    var businessCards = [BusinessCard]() // empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchBusinessCards()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Business Cards"
        
        tableView.backgroundColor = UIColor.mercury
        // hiding the separators
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.separatorColor = UIColor.black
        // it doesn't show the separators outside of the table view
        tableView.tableFooterView = UIView() // blank UIView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleReset))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleAddBusinessCard))
    }
    
    private func fetchBusinessCards() {
        //attempt core data fetch
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<BusinessCard>(entityName: "BusinessCard")
        
        do {
            let businessCards = try context.fetch(fetchRequest)
            businessCards.forEach { (businessCard) in
                print(businessCard.fullName ?? "")
            }
            self.businessCards = businessCards
            self.tableView.reloadData()
        } catch let fetchErr {
            print("Failed to fetch business cards: \(fetchErr)")
        }
    }
    
    @objc private func handleReset() {
        // reset core data and array
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: BusinessCard.fetchRequest())
        do{
            try context.execute(batchDeleteRequest)
            
            // animation
            var indexPathsToRemove = [IndexPath]()
            for (index, _) in businessCards.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathsToRemove.append(indexPath)
            }
            businessCards.removeAll()
            tableView.deleteRows(at: indexPathsToRemove, with: UITableViewRowAnimation.left)
            
            // no animation
            //businessCards.removeAll()
            //tableView.reloadData()
        } catch let deleteErr {
            print("Failed to delete objects from Core Data: \(deleteErr)")
        }
    }
    
    @objc private func handleAddBusinessCard() {
        let createBusinessCard = CreateBusinessCardController()
        
        let navController = CustomNavigationController(rootViewController: createBusinessCard)
        
        createBusinessCard.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // delete action
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: deleteHandlerFunction)
        deleteAction.backgroundColor = UIColor.lightRed
        
        // edit action
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = UIColor.black
        
        return [deleteAction, editAction]
    }
    
    private func deleteHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let businessCard = self.businessCards[indexPath.row]
            
        // remove the business card from the tableview
        self.businessCards.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        
        // delete the business card fom Core Data
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(businessCard)
            
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete business card: \(saveErr)")
        }
    }
    
    private func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let editBusinessCardController = CreateBusinessCardController()
        editBusinessCardController.delegate = self
        editBusinessCardController.businessCard = businessCards[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editBusinessCardController)
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No business cards available..."
        //label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return businessCards.count == 0 ? 150 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        cell.backgroundColor = UIColor.white
        
        let businesCard = businessCards[indexPath.row]
        
        cell.textLabel?.text = businesCard.fullName
        //cell.textLabel?.textColor = UIColor.mercury
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        // image by default
        cell.imageView?.image = #imageLiteral(resourceName: "select_logo_empty")
        
        // logo for those business cards with it
        if let imageData = businesCard.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessCards.count
    }

}
