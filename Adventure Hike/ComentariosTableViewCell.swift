//
//  ComentariosTableViewCell.swift
//  Adventure Hike
//
//  Created by Roberto Gutierrez on 11/01/16.
//  Copyright © 2016 Roberto Gutierrez. All rights reserved.
//

import UIKit

class ComentariosTableViewCell: UITableViewCell {
    
    @IBOutlet var nombreLabel: UILabel!
    @IBOutlet var fechaLabel: UILabel!
    @IBOutlet var comentarioLabel: UILabel!
    @IBOutlet var imagenUsuario: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
