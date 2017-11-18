//
//  ExerciseCell.swift
//  Fitbod
//
//  Created by Sang Saephan on 11/16/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
