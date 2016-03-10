//
//  TableViewCell.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 04/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet var imagenCelda: UIImageView!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var checkInLabel: UILabel!
    @IBOutlet var tituloLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
