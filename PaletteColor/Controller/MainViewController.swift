//
//  MainViewController.swift
//  PaletteColor
//
//  Created by Николай Петров on 25.02.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let colorVC = segue.destination as! SettingsController
        colorVC.colorForMainVC = view.backgroundColor
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        let colorVC = segue.source as! SettingsController
        colorVC.delegate =  self
        colorVC.setColor()
    }
}

extension MainViewController: ColorDelegate {
    func getColor(_ color: UIColor) {
        view.backgroundColor = color
    }
  
}
