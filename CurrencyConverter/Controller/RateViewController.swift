//
//  RateViewController.swift
//  CurrencyConverter
//
//  Created by Massimiliano on 28/03/2020.
//  Copyright © 2020 Massimiliano Bonafede. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    
    
    //MARK: - My IBOutlet
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var amountToConvertText: UITextField!
    @IBOutlet weak var dismissKeyboardBtn: UIButton!
    
    
    //MARK: - My Variables
    public var currencyName: String = ""
    public var currency = CurrencyModelClass()
    public var amount: String?
    
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        dismissKeyboardBtn.isHidden = true
    }
    
    
    
    //MARK: - ViewDidAppear()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tapGestureRecognize()
    }
    
    
    //MARK: - ViewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        convertButton.isHidden = true
        amountToConvertText.text = ""
        currencyPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    
    //MARK: - IBActions
    
    
    
    //MARK: - ConvertButtonWasPressed
    @IBAction func convertButtonWasPressed(_ sender: UIButton) {
        let url = "https://api.exchangeratesapi.io/latest?base="
        let parameters : [String : String] = ["base" : currencyName]
        amount = amountToConvertText.text!
        CurrencyModel.getCurrencyData(url: url, parameters: parameters, amount: amount!, currency: currencyName, completion: {
            self.currency = $0
            self.performSegue(withIdentifier: "segueToMain", sender: self)
        })
    }
    
    
    //MARK: - PrepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMain"{
            let vc = segue.destination as! CurrencyViewController
            vc.currencyArray = currency
        } else {
            print("No segue")
        }
    }
    
    
    
    //MARK: - AmountTextEditingChanged
    @IBAction func amountTextEditingChanged(_ sender: UITextField) {
        if amountToConvertText.text == ""{
            convertButton.isHidden = true
            dismissKeyboardBtn.isHidden = true
        } else if amountToConvertText.text != "" {
            convertButton.isHidden = true
            dismissKeyboardBtn.isHidden = false
        }
    }
    
    
    
    //MARK: - AmountTextValueChanged
    @IBAction func amountTextValueChanged(_ sender: UITextField) {
        print(#function)
    }
    
    //MARK: - DismissKeyboardButton
    @IBAction func dismissKeyboardButton(_ sender: UIButton) {
        self.amountToConvertText.endEditing(true)
        self.dismissKeyboardBtn.isHidden = true
    }
    
    //MARK: - TextFieldTouchDown
    @IBAction func textFieldTouchDown(_ sender: UITextField) {
        dismissKeyboardBtn.isHidden = false
    }
    
    
    
    //MARK: - Tap Gesture Recognize
    func tapGestureRecognize(){
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rimuoviTastiera))
        view.addGestureRecognizer(tap)
    }
    
    @objc func rimuoviTastiera(){
        self.view.endEditing(true)
        self.amountToConvertText.endEditing(true)
        self.dismissKeyboardBtn.isHidden = true
    }
    
    
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension RateViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyModel.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CurrencyModel.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Avenir", size: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = CurrencyModel.currencyArray[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        currencyName = CurrencyModel.currencyName(currency: CurrencyModel.currencyArray[row])
        self.tapGestureRecognize()
        
        DispatchQueue.main.async {
            if self.currencyName != "UNKNOW" && self.amountToConvertText.text != ""{
                self.convertButton.isHidden = false
            } else{
                self.convertButton.isHidden = true
            }
        }
    }
    
    
    
}


