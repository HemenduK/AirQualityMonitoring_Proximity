//
//  AQIGuideVC.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 07/11/21.
//

import UIKit

class AQIGuideVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension AQIGuideVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AirQualityIndex.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AQIGuideTableViewCell") as? AQIGuideTableViewCell
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("AQIGuideTableViewCell", owner: self, options: nil)?.first as? AQIGuideTableViewCell
            cell?.selectionStyle = .none
        }
        if(indexPath.row == 0){
            cell?.configureTitleCell()
        }else{
            cell?.configureCell(AirQualityIndex.allCases[indexPath.row - 1])
        }
        return cell!
    }
}
