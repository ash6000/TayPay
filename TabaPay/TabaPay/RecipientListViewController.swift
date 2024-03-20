//
//  RecipientListViewController.swift
//  TabaPay
//
//  Created by Ashton Watson on 3/20/24.
//

import UIKit

class RecipientListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Mock data for recipients
    let recipients = ["Alice", "Bob", "Charlie", "Tim", "Eve"]
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientCell", for: indexPath)
        cell.textLabel?.text = recipients[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            i = indexPath.row
            performSegue(withIdentifier: "ShowRecipientDetails", sender: indexPath.row)
        }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowRecipientDetails" {
            if let recipientDetailsVC = segue.destination as? RecipientDetailsViewController{
                recipientDetailsVC.recipientName = recipients[i]
            
            }
        }
    }}

