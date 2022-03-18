//
//  NewGameMenuController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/6/22.
//

import UIKit

class NewGameMenuController: UIViewController {

    @IBAction func backButtonTouched(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func playerVsPlayerButtonTouched(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PvP", sender: "PvP")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("new game page loaded")
        // Do any additional setup after loading the view.
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
