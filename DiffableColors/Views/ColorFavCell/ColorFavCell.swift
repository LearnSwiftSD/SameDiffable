//
//  ColorFavCell.swift
//  ColorFav
//
//  Created by Stephen Martinez on 7/16/18.
//  Copyright © 2018 Stephen Martinez. All rights reserved.
//

import UIKit

class ColorFavCell : UITableViewCell {
    
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    
    static let sbid = "ColorFavCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func defaulSetUp() {
        let defaultColor = Color.Values(red: 0.5, green: 0.5, blue: 0.5)
        colorView.shiftTo(defaultColor)
        nameLabel.text = "Gray Color"
        hexLabel.text = "000000"
    }
    
}
