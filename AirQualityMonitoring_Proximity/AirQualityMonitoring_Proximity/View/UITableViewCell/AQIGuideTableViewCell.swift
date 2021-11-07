//
//  AQIGuideTableViewCell.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 07/11/21.
//

import UIKit

class AQIGuideTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ category: AirQualityIndex) {
        switch category {
        case .good:
            lblIndex.text = "0-50"
        case .satisfactory:
            lblIndex.text = "51-100"
        case .moderate:
            lblIndex.text = "101-200"
        case .poor:
            lblIndex.text = "201-300"
        case .veryPoor:
            lblIndex.text = "301-400"
        case .severe:
            lblIndex.text = "401-500"
        case .none:
            lblIndex.text = ""
        }
        
        lblCategory.text = category.rawValue
        backgroundColor = category.color
    }
    
    func configureTitleCell(){
        self.lblIndex.textColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1.0)
        self.lblIndex.text = "AIR QUALITY INDEX"
        self.lblCategory.textColor = UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1.0)
        self.lblCategory.text = "CATEGORY"
        backgroundColor = .white
    }
}
