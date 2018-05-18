//
//  ServerSettingsPropertyViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 18/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class ServerSettingsPropertyViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    public var labelText = ""
    public var textFieldText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
        if label.text == "Password" {
            textField.isSecureTextEntry = true
        }
        textField.text = textFieldText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        if let property = label.text, let value = textField.text {
            let defaults = UserDefaults.standard
            var serverSettingsDictionary = defaults.dictionary(forKey: "ServerSettings") ?? [:]
            print("Saving server property \(property)")
            serverSettingsDictionary[property] = value
            defaults.set(serverSettingsDictionary, forKey: "ServerSettings")
            defaults.synchronize()
            print(defaults.value(forKey: "ServerSettings"))
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
