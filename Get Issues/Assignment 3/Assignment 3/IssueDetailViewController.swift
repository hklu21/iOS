//
//  IssueDetailViewController.swift
//  Assignment 3
//
//  Created by 卢恒宽 on 1/30/22.
//

import UIKit

class IssueDetailViewController: UIViewController {
    var issueDetail: GithubIssue?
    @IBOutlet var IssueTitle: UILabel!
    @IBOutlet var Username: UILabel!
    @IBOutlet var Date: UILabel!
    @IBOutlet var IssueBody: UITextView!
    @IBOutlet var IssueState: UIImageView!
    
    
    @IBOutlet var topMargin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        topMargin.backgroundColor = UIColor.red
        
        
        
        IssueTitle.text = issueDetail?.title
        Username.text = "@\(issueDetail?.user.login ?? "nil")"
        IssueBody.text = issueDetail?.body
        
        if issueDetail?.state == "closed" {
            IssueState.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            IssueState.image = UIImage(systemName: "envelope.open.fill")
        }
                
        
        // format the date
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd, yyyy"

        let date = RFC3339DateFormatter.date(from: issueDetail!.createdAt)
        
        Date.text = dateFormatterPrint.string(from: date!)
        self.navigationController?.navigationBar.barTintColor  = UIColor.red;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
