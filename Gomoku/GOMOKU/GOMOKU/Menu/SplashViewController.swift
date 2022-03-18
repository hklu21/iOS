//
//  MainMenuController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/6/22.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet var myView: UIView!
    override func viewDidLoad() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.myView.addGestureRecognizer(gesture)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {self.showMainMenu()}
    }
    
    /* When the splash view get clicked*/
    @objc func checkAction(_ sender:UITapGestureRecognizer){
        showMainMenu()
    }
    
    /* Show the main menu */
    func showMainMenu(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! MainMenuController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
