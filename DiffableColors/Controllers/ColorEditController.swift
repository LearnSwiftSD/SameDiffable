//
//  ColorEditController.swift
//  DiffableColors
//
//  Created by Stephen Martinez on 9/14/19.
//  Copyright © 2019 Stephen Martinez. All rights reserved.
//

import UIKit

class ColorEditController: ColorController {
    
    @IBOutlet weak var deleteButton: UIButton!
    static let sbid = "ColorEditController"
    
    
    static func activate(from loadingPoint: UIViewController, setToColor: FavColor) {
        guard let navController = loadingPoint.navigationController else { return }
        guard let colorEditController = loadingPoint.storyboard?.instantiateViewController(
            withIdentifier: ColorEditController.sbid) as? ColorEditController else { return }
        colorEditController.existingFav = setToColor
        navController.pushViewController(colorEditController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWithExistingColor()
    }
    
    func setUpWithExistingColor(){
        guard let color = existingFav?.color else { return }
        nameField.text = existingFav?.name
        
        redSlider.setValue(color.float.red, animated: false)
        greenSlider.setValue(color.float.green, animated: false)
        blueSlider.setValue(color.float.blue, animated: false)
        
        hexValueLabel.text = color.hex
        redValue.text = "\(color.red)"
        greenValue.text = "\(color.green)"
        blueValue.text = "\(color.blue)"
    }
    
    @IBAction func editColor(_ sender: Any) {

        defer { navigationController?.popViewController(animated: true) }
        guard var newFav = existingFav else { return }
        
        let newColor = Color.Values(
            red: redSlider.value,
            green: greenSlider.value,
            blue: blueSlider.value
        )
        
        newFav.color = newColor
        newFav.name = nameField.text
        InAppMemory.shared.update(color: newFav)
    }
    
    @IBAction func deleteColor(_ sender: Any) {
        defer { navigationController?.popViewController(animated: true) }
        guard let existingFav = existingFav else { return }
        InAppMemory.shared.delete(color: existingFav)
    }
    
    override func setUpStyle() {
        super.setUpStyle()
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 2.5
    }
    
}
