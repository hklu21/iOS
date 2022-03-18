//
//  MainMenuController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/6/22.
//

import UIKit

class MainMenuController: UIViewController {

    @IBAction func NewGameButtonTouched(_ sender: UIButton) {
        self.performSegue(withIdentifier: "NewGame", sender: "NewGame")
        
    }
    
    @IBAction func ContinueButtonTouched(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Continue", sender: "Continue")
    }
    
    @IBAction func PartyButtonTouched(_ sender: UIButton) {
        let alert = UIAlertController(title: "Compete With Friend?", message: "", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {action in
            
            let PartyView = self.storyboard!.instantiateViewController(withIdentifier: "PartyView")
            PartyView.modalPresentationStyle = .fullScreen
            self.present(PartyView, animated:true, completion:nil)
            
            }
        ))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let val=loadSetting("launch_time") as? Int
        if val == 1{
            let userDefaults = UserDefaults.standard
            userDefaults.register(
                defaults: [
                    "gomoku_setting_launch_volume": 10,
                    "gomoku_setting_background_volume": 10,
                    "gomoku_setting_time_limit":0,
                    "gomoku_setting_time_max_regret":0,
                    "gomoku_setting_initial_launch":NSDate()
                ]
            )
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let val=loadSetting("launch_time") as? Int
        if val==3{
            /* Ask for rating */
            askForUserRating()
        }
    }
    
    /* Show a prompt to ask for user rating*/
    func askForUserRating(){
        /* Prompt for verification*/
        print("called")
        let alertController = UIAlertController(title: "Rating", message: "Please rate our application", preferredStyle: .alert)

        // create cancel button
        alertController.addAction(UIAlertAction(title: "Skip", style: .cancel, handler: { (pAction) in
          alertController.dismiss(animated: true, completion: nil)
        }))

        // create Ok button
        alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (pAction) in
            /* Restore to default setting*/
          alertController.dismiss(animated: true, completion: nil)
        }))

        // show alert controller
        self.present(alertController, animated: true, completion: nil)
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
