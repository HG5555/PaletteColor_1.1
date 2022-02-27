//
//  ViewController.swift
//  PaletteColor
//
//  Created by Николай Петров on 14.02.2022.
//

import UIKit

class SettingsController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var colorField: UIView!
    
    @IBOutlet var redDisplayLaible: UILabel!
    @IBOutlet var greenDisplayLaible: UILabel!
    @IBOutlet var blueDisplayLaible: UILabel!
    
    @IBOutlet var redTune: UISlider!
    @IBOutlet var greenTune: UISlider!
    @IBOutlet var blueTune: UISlider!
    
    @IBOutlet var redDisplayValue: UITextField!
    @IBOutlet var greenDisplayValue: UITextField!
    @IBOutlet var blueDisplayValue: UITextField!
    
    // MARK: - Publick Properties
    var colorForMainVC: UIColor!
    var delegate: ColorDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorField.layer.cornerRadius = colorField.frame.width / 12
        colorField.backgroundColor = colorForMainVC
        
        setValueForSlider()
        setValueForLaible()
        setValueForTextField()
    
        addDoneButtonTo(redDisplayValue)
        addDoneButtonTo(greenDisplayValue)
        addDoneButtonTo(blueDisplayValue)
        
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - IBActions
    @IBAction func rgbSlider(_ sender: UISlider) {
        switch sender.tag {
    case 0:
        redDisplayLaible.text = string(from: sender)
        redDisplayValue.text = string(from: sender)
    case 1:
        greenDisplayLaible.text = string(from: sender)
        greenDisplayValue.text = string(from: sender)
    case 2:
        blueDisplayLaible.text = string(from: sender)
        blueDisplayValue.text = string(from: sender)
    default: break
    }
        
    setColor()
}
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
  
    func setColor() {
        let settingColor = UIColor(displayP3Red: CGFloat(redTune.value),
                               green: CGFloat(greenTune.value),
                               blue: CGFloat(blueTune.value),
                               alpha: 1)
        colorField.backgroundColor = settingColor
        delegate?.getColor(settingColor)
    }
    
    // MARK: - Private Methods
    private func setValueForLaible() {
        redDisplayLaible.text = string(from: redTune)
        greenDisplayLaible.text = string(from: greenTune)
        blueDisplayLaible.text = string(from: blueTune)
    }
    
    private func setValueForTextField(){
        redDisplayValue.text = string(from: redTune)
        greenDisplayValue.text = string(from: greenTune)
        blueDisplayValue.text = string(from: blueTune)
    }
    
    private func setValueForSlider() {
        let ciColor = CIColor(color: colorForMainVC)
        redTune.value = Float(ciColor.red)
        greenTune.value = Float(ciColor.green)
        blueTune.value = Float(ciColor.blue)
    }
    
    private func string(from slider: UISlider) -> String {
        return String(format: "%0.2f", slider.value)
        
    }
}


extension SettingsController: UITextFieldDelegate {
    
    //hide keyboard by tap on "Done"
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //hide keyboard tap on outside Text View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true) //Скрывает клавиатуруб вызванную для любого объекта
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if let currentValue = Float(text) {
            
            switch textField.tag {
            case 0: redTune.value = currentValue
            case 1: greenTune.value = currentValue
            case 2: blueTune.value = currentValue
            default: break
            }
            
            setColor()
            setValueForLaible()
            
        } else {
            showAlert(title: "Wrong format!",
                      message: "Please enter correct value")
        }
    }
}

extension SettingsController {
    
    //Метод для отображения кнопки "Готово" на цифровой клавиатуре
    private func addDoneButtonTo(_ textField: UITextField) {
        
        let toolBar = UIToolbar()
        textField.inputAccessoryView = toolBar
        toolBar.sizeToFit()
                
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDone))
        
        let flexibleSpace  = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                             target: self,
                                             action: nil)

        toolBar.items = [flexibleSpace, doneButton]
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}





