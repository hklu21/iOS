//
//  ClosedIssueViewController.swift
//  Assignment 3
//
//  Created by 卢恒宽 on 1/30/22.
//

import UIKit

class ClosedIssueViewController: UITableViewController {

    var issues: [GithubIssue] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.view.backgroundColor = UIColor.red
        GitHubClient.fetchClosedIssues { (issues, error) in
            
            // Ensure we have good data before anything else
            guard let issues = issues, error == nil else {
              print(error!)
              return
            }
            self.issues = issues
            self.tableView.reloadData()
          }
        
    
        
        let refreshControl = UIRefreshControl()
        let title = NSAttributedString(string: "Refreshing Issues")
        refreshControl.attributedTitle = title
        refreshControl.addTarget(self,
                                 action: #selector(refresh(sender:)),
                                 for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // fetch updated data
        GitHubClient.fetchClosedIssues { (issues, error) in
            
            // Ensure we have good data before anything else
            guard let issues = issues, error == nil else {
              print(error!)
              return
            }
            self.issues = issues
            self.tableView.reloadData()
        }
        print("done refreshing")
        sender.endRefreshing()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return issues.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IssueCell", for: indexPath) as! IssueTableViewCell

        // Configure the cell...
        cell.IssueTitle?.text = "\(issues[indexPath.row].title ?? "nil")"
        cell.Username?.text = "@\(issues[indexPath.row].user.login)"
        return cell
    }
    
    // MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = indexPath.row
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "IssueDetail" {
            let issueDetailVC = segue.destination as! IssueDetailViewController
            issueDetailVC.issueDetail = issues[self.tableView.indexPathForSelectedRow?.row ?? 0]
        } else {
            print("Must be my modal segue")
        }
    }
    

}
