//
//  ColorSaveController.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

class ColorSaveController: ColorController {
 
    static let sbid = "ColorSaveController"
    
    static func activate(from loadingPoint: UIViewController) {
        guard let navController = loadingPoint.navigationController else { return }
        guard let colorSaveController = loadingPoint.storyboard?.instantiateViewController(
            withIdentifier: ColorSaveController.sbid) as? ColorSaveController else { return }
        navController.pushViewController(colorSaveController, animated: true)
    }
    
    @IBAction func saveColor(_ sender: Any) {
        let color = FavColor(
            color: Color.Values(
                red: redSlider.value,
                green: greenSlider.value,
                blue: blueSlider.value),
            name: nameField.text
        )
        InAppMemory.shared.save(color: color)
        navigationController?.popViewController(animated: true)
    }
    
}
