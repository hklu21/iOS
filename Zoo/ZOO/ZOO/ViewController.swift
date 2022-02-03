//
//  ViewController.swift
//  ZOO
//
//  Created by 卢恒宽 on 1/19/22.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    var animals = [Animal]()
    var sounds = [String]()
    var player: AVAudioPlayer!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Z O O"
    
        // Horse
        let horseImage = UIImage(named: "horse")!
        let horseSoundPath = Bundle.main.path(forResource: "horse", ofType: "wav")!
        let Horse = Animal(name: "Blemishine", species: "horse", age: 10, image: horseImage, soundPath: horseSoundPath)
        animals.append(Horse)
        
        // Cat
        let catImage = UIImage(named: "cat")!
        let catSoundPath = Bundle.main.path(forResource: "cat", ofType: "wav")!
        let Cat = Animal(name: "Schwarz", species: "cat", age: 3, image: catImage, soundPath: catSoundPath)
        animals.append(Cat)
        
        // Pig
        let pigImage = UIImage(named: "pig")!
        let pigSoundPath = Bundle.main.path(forResource: "pig", ofType: "wav")!
        let Pig = Animal(name: "Phantom", species: "pig", age: 5, image: pigImage, soundPath: pigSoundPath)
        animals.append(Pig)
        
        animals.shuffle()
        
        label.text = animals[0].species
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.gray
        scrollView.contentSize = CGSize(width: 390*3, height: scrollView.frame.height)
        
        
        for i in 0...2 {
            // add button
            let button = UIButton(frame: CGRect(x:300 + i*390 , y: 50, width: 90, height: 25))
            button.tag = i
            button.setTitle(animals[i].name, for: .normal)
            button.backgroundColor = UIColor.blue
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(UIColor.red, for: .highlighted)
            button.addTarget(self,
                             action: #selector(tapShowAlert),
                             for: UIControl.Event.touchUpInside)
            scrollView.addSubview(button)
            // add image
            let image = UIImageView(frame: CGRect(x:i*390 , y:0, width: 390, height: 600))
            image.image = animals[i].image
            scrollView.addSubview(image)
            scrollView.sendSubviewToBack(image)
            
        }
        

    }
    @IBAction func tapShowAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: sender.currentTitle,
                                      message: "This \(animals[sender.tag].species) is \(animals[sender.tag].age) year(s) old.", preferredStyle: .alert)
        
        
        // reference source: https://stackoverflow.com/questions/58360765/swift-5-1-error-plugin-addinstanceforfactory-no-factory-registered-for-id-c
        
        alert.addAction(UIAlertAction(title: "Play Sound", style: .default, handler: {action in
                let path = self.animals[sender.tag].soundPath
                let url = URL(fileURLWithPath: path)
                self.player = try? AVAudioPlayer(contentsOf: url)
                self.player?.play()
                
            }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }


}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x + 195
        let idx = x / 390
        label.text = animals[Int(idx)].species
        label.alpha = abs(scrollView.contentOffset.x.truncatingRemainder(dividingBy: 390) - 195) / 195
    }
}



