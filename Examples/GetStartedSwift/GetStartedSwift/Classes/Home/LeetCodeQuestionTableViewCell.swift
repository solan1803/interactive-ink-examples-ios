//
//  LeetCodeQuestionTableViewCell.swift
//  GetStartedSwift
//
//  Created by Solan Manivannan on 29/05/2018.
//  Copyright © 2018 MyScript. All rights reserved.
//

import UIKit

class LeetCodeQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var acceptanceLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initialiseLabels(id: String, questionTitle: String, acceptance: String, difficulty: String, description: String) {
        idLabel.text = id
        questionTitleLabel.text = questionTitle
        acceptanceLabel.text = acceptance
        difficultyLabel.text = difficulty
        switch(difficulty) {
        case "Easy":
            difficultyLabel.textColor = UIColor(red: 0.3608, green: 0.749, blue: 0, alpha: 1.0)
        case "Medium":
            difficultyLabel.textColor = UIColor.orange
        case "Hard":
            difficultyLabel.textColor = UIColor.red
        default:
            break
        }
        descriptionLabel.text = description
    }

}
