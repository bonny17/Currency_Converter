//
//  currencyCell.swift
//  CurrencyConverter
//
//  Created by Massimiliano on 15/06/2019.
//  Copyright © 2019 Massimiliano Bonafede. All rights reserved.
//

import UIKit

class currencyCell: UITableViewCell {

    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var currencyImage: UIImageView!
    @IBOutlet weak var currencyNameLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCurrncy(currency : String , rates : Double, flag : String, name : String){
        
        currencyLbl.text = "\(currency) - \(rates)"
        currencyImage.image = UIImage(named: flag)
        currencyNameLbl.text = name
    }

}
