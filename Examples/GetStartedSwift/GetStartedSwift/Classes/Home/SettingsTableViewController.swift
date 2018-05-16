//
//  SettingsTableViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 13/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var injectionCandidates: Dictionary<String, [String]> = [:]
    
    var selectedCell = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if let d = defaults.dictionary(forKey: "InjectionCandidates") {
            injectionCandidates = d as! Dictionary<String, [String]>
            print(injectionCandidates)
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return injectionCandidates.keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InjectionCell", for: indexPath)

        let lookFor = Array(injectionCandidates.keys)[indexPath.row]
        let replaceWith = injectionCandidates[lookFor]
        cell.textLabel?.text = lookFor
        cell.detailTextLabel?.text = replaceWith?.joined(separator: " ")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        performSegue(withIdentifier: "injectionCandidateSegue", sender: self)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "injectionCandidateSegue" && selectedCell != -1) {
            let icViewController = segue.destination as? InjectionCandidateWordViewController
            icViewController?.lookForText = Array(injectionCandidates.keys)[selectedCell]
            icViewController?.replaceWithText = (injectionCandidates[Array(injectionCandidates.keys)[selectedCell]]?.joined(separator: " "))!
        }
        
    }
    

}
