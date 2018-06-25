//
//  SettingsTableViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 13/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var filename = ""
    var injectionCandidates: Dictionary<String, [String]> = [:]
    var serverSettings: Dictionary<String, String> = [:]
    var leetcodeDetails: Dictionary<String, String> = [:]
    var fileSettings: Dictionary<String, String> = ["type":"custom", "placeholder":"false"]
    
    var selectedCell = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        tableView.register(UINib(nibName: "LeetCodeQuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "LeetCodeCell")
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
        if let d = defaults.dictionary(forKey: "ServerSettings") {
            serverSettings = d as! Dictionary<String, String>
            tableView.reloadData()
        }
        if let d = defaults.dictionary(forKey: "LeetCodeDetails") {
            leetcodeDetails = d as! Dictionary<String, String>
            tableView.reloadData()
        }
        if let d = defaults.dictionary(forKey: "FileSettings") {
            var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
            if let fs = allFileSettings[filename] {
                fileSettings = fs
                if fileSettings["type"] == "custom" && fileSettings["placeholder"] == nil {
                    fileSettings["placeholder"] = "false"
                }
            } else {
                // for all old files, save default file settings with type = custom
                print("old file, need to create filesettings dictionary for it")
                allFileSettings[filename] = fileSettings
                defaults.set(allFileSettings, forKey: "FileSettings")
                print(defaults.value(forKey: "FileSettings"))
            }
        } else {
            // create empty filesettings dictionary (one time)
            let allFileSettings: Dictionary<String, Dictionary<String, String>> = [:]
            defaults.set(allFileSettings, forKey: "FileSettings")
            defaults.synchronize()
            print(defaults.value(forKey: "FileSettings"))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Injection Candidates"
        case 1:
            return "Server Settings"
        case 2:
            return "LeetCode Details"
        case 3:
            return "File Settings"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch (section) {
            case 0: return injectionCandidates.keys.count
            case 1: return serverSettings.keys.count
            case 2: return leetcodeDetails.keys.count
            case 3: return fileSettings.keys.count
            default: return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "InjectionCell", for: indexPath)
        if indexPath.section == 0 {
            let lookFor = Array(injectionCandidates.keys)[indexPath.row]
            let replaceWith = injectionCandidates[lookFor]
            cell.textLabel?.text = lookFor
            cell.detailTextLabel?.text = replaceWith?.joined(separator: " ")
        } else if indexPath.section == 1 {
            // server settings
            let key = Array(serverSettings.keys)[indexPath.row]
            let value = serverSettings[key]
            cell.textLabel?.text = key
            cell.detailTextLabel?.text = value
        } else if indexPath.section == 2 {
            // leetcode details
            let key = Array(leetcodeDetails.keys)[indexPath.row]
            let value = leetcodeDetails[key]
            cell.textLabel?.text = key
            cell.detailTextLabel?.text = value
        } else if indexPath.section == 3 {
            // file settings
            let key = Array(fileSettings.keys)[indexPath.row]
            let value = fileSettings[key]
            if fileSettings["type"] == "leetcode" && key == "id" {
                let id = Int(value!)! - 1
                cell = tableView.dequeueReusableCell(withIdentifier: "LeetCodeCell", for: indexPath) as! LeetCodeQuestionTableViewCell
                (cell as! LeetCodeQuestionTableViewCell).initialiseLabels(id: LEETCODE_DATA[id][0], questionTitle: LEETCODE_DATA[id][1], acceptance: LEETCODE_DATA[id][3], difficulty: LEETCODE_DATA[id][4], description: LEETCODE_DATA[id][5])
            } else if fileSettings["type"] == "custom" && key == "placeholder" {
                cell = tableView.dequeueReusableCell(withIdentifier: "customCodePlaceholderCell", for: indexPath)
                cell.textLabel?.text = "Placeholder"
                if value == "true" {
                    cell.accessoryType = .checkmark
                } else if value == "false" {
                    cell.accessoryType = .none
                }
            } else {
                cell.textLabel?.text = key
                cell.detailTextLabel?.text = value
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedCell = indexPath.row
            performSegue(withIdentifier: "injectionCandidateSegue", sender: self)
        } else if indexPath.section == 1 {
            selectedCell = indexPath.row
            performSegue(withIdentifier: "serverSettingsPropertySegue", sender: self)
        } else if indexPath.section == 3 && fileSettings["type"] == "custom"{
            let cell = tableView.cellForRow(at: indexPath)
            let defaults = UserDefaults.standard
            if cell?.reuseIdentifier == "customCodePlaceholderCell" {
                if let d = defaults.dictionary(forKey: "FileSettings") {
                    var allFileSettings = d as! Dictionary<String, Dictionary<String, String>>
                    if cell?.accessoryType == UITableViewCellAccessoryType.none {
                        fileSettings["placeholder"] = "true"
                        allFileSettings[filename] = fileSettings
                        defaults.set(allFileSettings, forKey: "FileSettings")
                        print(defaults.value(forKey: "FileSettings"))
                        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                    } else if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
                        fileSettings["placeholder"] = "false"
                        allFileSettings[filename] = fileSettings
                        defaults.set(allFileSettings, forKey: "FileSettings")
                        print(defaults.value(forKey: "FileSettings"))
                        cell?.accessoryType = UITableViewCellAccessoryType.none
                    }
                }
            }
        }
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
        } else if (segue.identifier == "serverSettingsPropertySegue" && selectedCell != -1) {
            let sspViewController = segue.destination as? ServerSettingsPropertyViewController
            sspViewController?.labelText = Array(serverSettings.keys)[selectedCell]
            if let value = serverSettings[Array(serverSettings.keys)[selectedCell]] {
                sspViewController?.textFieldText = value
            }
        }
        
    }
    

}
