//
//  ConvertedOutputViewController.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 20/02/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class ConvertedOutputViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    var convertedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLabel.text = convertedText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
