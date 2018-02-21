//
//  LoadFilesTableViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 17/02/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class LoadFilesTableViewController: UITableViewController {

    var fileURLs: [URL] = []
    
    private func getListOfFiles() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        } catch {
            print("Error in getListOfFiles")
            print("Error while enumerating files: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfFiles()
        self.title = "Load document"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return fileURLs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        // cell.textLabel?.text = String(describing: fileURLs[indexPath.row])
        let fileURL = String(describing: fileURLs[indexPath.row])
        cell.textLabel?.text = String(fileURL[fileURL.index(fileURL.startIndex, offsetBy: 102)...fileURL.index(fileURL.endIndex, offsetBy: -6)])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navController = self.navigationController {
            if let hvc = navController.viewControllers[navController.viewControllers.count - 2] as? HomeViewController {
                let filePath = String(describing: fileURLs[indexPath.row])
                let range = filePath.index(filePath.startIndex, offsetBy:15)
                hvc.loadContent(withFileURL: String(filePath[range...]))
            }
            navController.popViewController(animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func createNewFile(_ sender: UIBarButtonItem) {
        
            //Creating UIAlertController and
            //Setting title and message for the alert dialog
            let alertController = UIAlertController(title: "Create new file", message: "Enter filename", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
                
                //getting the input values from user
                if let filename = alertController.textFields?[0].text {
                    if let navController = self.navigationController {
                        if let hvc = navController.viewControllers[navController.viewControllers.count - 2] as? HomeViewController {
                            do {
                                try hvc.createPackage(packageName: filename)?.save()
                                let fullPath = FileManager.default.pathForFile(inDocumentDirectory: filename) + ".iink"
                                hvc.loadContent(withFileURL: fullPath)
                            } catch {
                                print("ERROR: CREATING NEW FILE IN TABLEVIEW")
                            }
                        }
                    }
                }
                
            }
            
            //the cancel action doing nothing
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            
            //adding textfields to our dialog box
            alertController.addTextField { (textField) in
            }
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
    }
    
}
