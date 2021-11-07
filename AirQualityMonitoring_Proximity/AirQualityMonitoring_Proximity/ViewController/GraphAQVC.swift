//
//  GraphAQVC.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit
import Charts

class GraphAQVC: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    var viewModel = AirQualityViewModel()
    var arrAQ = [AirQualityModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chart View"
        self.setupChartView()
        self.handleAQSuccessResponse()
    }
    
    deinit{
        viewModel.closure = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.socket.disconnect()
        viewModel.socket = nil
        viewModel.closure = nil
        chartView.delegate = nil
    }
    
    //MARK: CUSTOM METHODS
    
    func setupChartView(){
        chartView.delegate = self
        chartView.chartDescription!.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.rightAxis.enabled = false
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.valueFormatter = DateValueFormatter()
        chartView.xAxis.granularity = 7
        chartView.xAxis.axisMaxLabels = 4
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker

        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 2.5)
    }
    
    func setupChartData(arrAQMdel:[AirQualityModel]){
        var arrChartData = [ChartDataEntry]()
        for model in arrAQMdel{
            let chartModel = ChartDataEntry(x: (model.time?.timeIntervalSince1970)!, y: model.aqi)
            arrChartData.append(chartModel)
        }
        let data = LineChartData(dataSet: getGraphDataSet(values:arrChartData, metricName: "AQI"))
        chartView.data = data
        
        view.layoutIfNeeded()
    }
    
    private func getGraphDataSet(values: [ChartDataEntry]?, metricName: String) -> LineChartDataSet {
        let set = LineChartDataSet(entries: values, label: metricName)
        
        // Configure Line Chart Data Set
        set.highlightEnabled = true
        set.lineWidth = 1
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightLineDashLengths = [5, 10]
        
        // If Sinle data point then show filled circle
        if let points = values,
            points.count > 1 {
            set.circleRadius = 0
            set.drawCircleHoleEnabled = false
            set.circleHoleRadius = 0
        }
        else {
            set.circleRadius = 3
            set.drawCircleHoleEnabled = true
            set.circleHoleRadius = 0
        }
        return set
    }
    
    func handleAQSuccessResponse(){
        self.viewModel.closure = {[weak self] event in
            DispatchQueue.main.async {
                switch event {
                case .updateDisplayList:
                    break
                case .updateCityAQI(let updatedData):
                    guard let newData = updatedData else {
                        return
                    }
                    self!.setupChartData(arrAQMdel: newData)
                }
            }
        }
    }
    

}

extension GraphAQVC:ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}
