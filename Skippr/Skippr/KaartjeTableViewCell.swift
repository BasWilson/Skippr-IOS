//
//  KaartjeTableViewCell.swift
//  Skippr
//
//  Created by Bas Wilson on 20/02/2018.
//  Copyright © 2018 OnPointCoding. All rights reserved.
//

import UIKit

class KaartjeTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBAction func viewCardBtn(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
