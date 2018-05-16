//
//  InjectionCandidateWordViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 13/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class InjectionCandidateWordViewController: UIViewController {

    @IBOutlet weak var lookForTextField: UITextField!
    
    @IBOutlet weak var replaceWithTextField: UITextField!
    
    public var lookForText = ""
    public var replaceWithText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookForTextField.text = lookForText
        replaceWithTextField.text = replaceWithText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveInjectionCandidate(_ sender: Any) {
        
        if let lookFor = lookForTextField.text, let replaceWith = replaceWithTextField.text?.split(separator: " ").map({ String($0) }) {
            let defaults = UserDefaults.standard
            var injectionDictionary = defaults.dictionary(forKey: "InjectionCandidates") ?? [:]
            print("Saving injection candidate")
            injectionDictionary[lookFor] = replaceWith
            defaults.set(injectionDictionary, forKey: "InjectionCandidates")
            defaults.synchronize()
            print(defaults.value(forKey: "InjectionCandidates"))
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
