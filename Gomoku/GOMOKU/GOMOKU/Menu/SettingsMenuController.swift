//
//  SettingsMenuController.swift
//  GOMOKU
//
//  Created by 卢恒宽 on 3/9/22.
//

import UIKit

class SettingsMenuController: UITableViewController {
    
    @IBAction func backButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath) as! VolumeCell
            cell.VolumeType.text = "Launch Volume"
            cell.Volume.tag = 1 //first Slider
            cell.Volume.addTarget(self, action: #selector(self.sliderValueChange(_:)), for: .valueChanged)
            if let val=loadSetting("launch_volume") as? Float{
                cell.Volume.value=val
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VolumeCell", for: indexPath) as! VolumeCell
            cell.VolumeType.text = "Background Volume"
            cell.Volume.tag = 2 // sencond Slider
            cell.Volume.addTarget(self, action: #selector(self.sliderValueChange(_:)), for: .valueChanged)
            if let val=loadSetting("background_volume") as? Float{
                cell.Volume.value=val
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLimitAndRegretCell", for: indexPath) as! TimeLimitAndRegretCell
            cell.ControlType.text = "Time Limit"
            cell.ControlValue.tag = 1
            cell.ControlValue.setTitle("15s", forSegmentAt: 0)
            cell.ControlValue.setTitle("30s", forSegmentAt: 1)
            cell.ControlValue.setTitle("No Limit", forSegmentAt: 2)
            if let val=loadSetting("time_limit") as? Int{
                print(val)
                cell.ControlValue.selectedSegmentIndex=val
            }
            return cell

            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeLimitAndRegretCell", for: indexPath) as! TimeLimitAndRegretCell
            cell.ControlType.text = "Max Regret"
            cell.ControlValue.tag = 2
            cell.ControlValue.setTitle("1", forSegmentAt: 0)
            cell.ControlValue.setTitle("2", forSegmentAt: 1)
            cell.ControlValue.setTitle("No Regret", forSegmentAt: 2)
            if let val=loadSetting("max_regret") as? Int{
                cell.ControlValue.selectedSegmentIndex=val
            }
            return cell
            
        default:
            break
        }
        return UITableViewCell()
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        // Get the sliders value
        switch sender.tag {
        case 1:
            let currentValue = Float(sender.value)
            print("Launch Volume: \(currentValue)")
            saveSetting("launch_volume", currentValue)
        case 2:
            let currentValue = Float(sender.value)
            print("Background Volume: \(currentValue)")
            saveSetting("background_volume", currentValue)
        default:
            break
        }
    }
    
    
    @IBAction func controlValueChange(_ sender: UISegmentedControl) {
        switch sender.tag {
        case 1:
            let currentValue = sender.titleForSegment(at: sender.selectedSegmentIndex)!
            print("Time Limit: \(currentValue)")
            saveSetting("time_limit", sender.selectedSegmentIndex)
        case 2:
            let currentValue = sender.titleForSegment(at:
                sender.selectedSegmentIndex)!
            print("Max Regret: \(currentValue)")
            print(sender.selectedSegmentIndex)
            saveSetting("max_regret", sender.selectedSegmentIndex)
        default:
            break
        }
    }
    
    /* Handle restore button clicked*/
    @IBAction func restoreButtonClicked(_ sender: Any) {
        /* Prompt for verification*/
        let alertController = UIAlertController(title: "Restore", message: "Do you want to restore to defualt setting?", preferredStyle: .alert)

        // create cancel button
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (pAction) in
          alertController.dismiss(animated: true, completion: nil)
        }))

        // create Ok button
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (pAction) in
            /* Restore to default setting*/
            self.restoreCellToDefaultSetting()
          alertController.dismiss(animated: true, completion: nil)
        }))

        // show alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    /* Restore to defualt setting*/
    func restoreCellToDefaultSetting(){
        let cells = self.tableView.visibleCells

        for cell in cells {
            if let volumecell = cell as? VolumeCell{
                volumecell.Volume.value=0.5
            }
            if let timeCell = cell as? TimeLimitAndRegretCell{
                timeCell.ControlValue.selectedSegmentIndex=2
            }
        }
    }
    
    /* Update the setting of main board*/
    override func viewWillDisappear(_ animated: Bool) {
        print("Setting get closed")
        self.performSegue(withIdentifier: "unwindToSetting", sender: self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
