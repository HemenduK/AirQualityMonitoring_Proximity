//
//  AirQualityTableViewCell.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit

class AirQualityTableViewCell: UITableViewCell {
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblLastUpdated: UILabel!
    @IBOutlet weak var lblAQI: UILabel!
    
    let COLUMNCITY = "CITY"
    let COLUMNAQI = "CURRENT AQI"
    let COLUMNLASTUPDATED = "LAST UPDATED"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: CUSTOM METHODS
    
    func configureCell(model:AirQualityModel){
        if let city = model.city{
            self.lblCity.text = city
        }
        if let lastUpdated = model.lastUpdated{
            self.lblLastUpdated.text = lastUpdated
        }
        self.lblAQI.text = "\(model.aqi)"
        
        if model.hasDegraded {
            backgroundColor = model.category.color
            lblAQI.textColor = .white
        } else {
            backgroundColor = .white
            lblAQI.textColor = model.category.color
        }
    }
    
    func configureTitleCell(){
        self.lblCity.text = COLUMNCITY
        self.lblAQI.textColor = .black
        self.lblAQI.text = COLUMNAQI
        self.lblLastUpdated.text = COLUMNLASTUPDATED
    }
}
