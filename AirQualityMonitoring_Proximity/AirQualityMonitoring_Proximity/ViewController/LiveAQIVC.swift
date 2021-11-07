//
//  LiveAQIVC.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit

class LiveAQIVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = AirQualityViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Air Quality Monitoring"
        self.handleAQSuccessResponse()
    }
    
    //MARK: CUSTOM METHODS
    
    
    func handleAQSuccessResponse(){
        self.viewModel.closure = {[weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .updateDisplayList:
                    self!.tableView.reloadData()
                case .updateCityAQI(_):
                    break
                }
            }
        }
    }
    
    func openGuidePopover(sourceView:Any){
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let contentVC = storyboard.instantiateViewController(withIdentifier: "AQIGuideVC") as? AQIGuideVC
        contentVC?.preferredContentSize = CGSize(width: Int(self.view.frame.width) - 50, height: (AirQualityIndex.allCases.count) * 60)
        contentVC?.modalPresentationStyle = .popover

        let popoverVC = contentVC?.popoverPresentationController
        if sourceView is UIBarButtonItem{
            popoverVC?.barButtonItem = sourceView as? UIBarButtonItem
        }else{
            popoverVC?.sourceView = sourceView as? UIView
        }
        popoverVC?.delegate = self
        popoverVC?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        self.present(contentVC!, animated: true, completion: nil)
    }
    
    //MARK: BUTTONS ACTION METHODS
    
    @IBAction func btnGuideAction(_ sender: Any) {
        openGuidePopover(sourceView: sender)
    }

}

//MARK: UIPopoverPresentationControllerDelegate METHODS

extension LiveAQIVC:UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension LiveAQIVC : UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrAQ.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AirQualityTableViewCell") as? AirQualityTableViewCell
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("AirQualityTableViewCell", owner: self, options: nil)?.first as? AirQualityTableViewCell
            cell?.selectionStyle = .none
        }
        if(indexPath.row == 0){
            cell?.configureTitleCell()
        }else{
            if(self.viewModel.arrAQ.count > 0){
                let model = viewModel.arrAQ[indexPath.row - 1]
                cell?.configureCell(model: model)
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > 0){
           let model = viewModel.arrAQ[indexPath.row - 1]
            if let cityData = viewModel.detailedCityAQI[model.city!]{
                viewModel.selectedCity = model
                let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                let graphVC = storyboard.instantiateViewController(withIdentifier: "GraphAQVC") as? GraphAQVC
                graphVC?.viewModel = viewModel
                graphVC?.arrAQ = cityData
                self.navigationController?.pushViewController(graphVC!, animated: true)
            }
        }
    }
    
}
