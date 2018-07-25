//
//  ViewController.swift
//  FinalApp
//

import UIKit

class ViewController: UITableViewController {

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
        
        setupNavigationController()
    }
    
    @objc func handleAddBC() {
        print("Adding BC...")
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
        
        cell.textLabel?.text = "Business card"
        //cell.textLabel?.textColor = UIColor.mercury
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // function to setup the navigation controller
    func setupNavigationController() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }

}
