//
//  PlotViewController.swift
//  Fitbod
//
//  Created by Sang Saephan on 11/17/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit
import Charts

class PlotViewController: UIViewController {

    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var details: [String]!
    var maxRepAtDate: Dictionary<String,[Any]>!
    var maxRepAtDateArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exerciseLabel.text = details[0]
        weightLabel.text = details[1]
        
        maxRepAtDateArray = maxRepAtDate.keys.sorted()
        
        updateGraph()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateGraph() {
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<maxRepAtDate.count {
            
            let value = ChartDataEntry(x: Double(i), y: Double(maxRepAtDate["\(maxRepAtDateArray[i])"]![1] as! Int))
            lineChartEntry.append(value)
            
            let line = LineChartDataSet(values: lineChartEntry, label: nil)
            line.circleColors = [UIColor(red: 255/255, green: 110/255, blue: 96/255, alpha: 1.0)]
            line.circleRadius = 3.0
            line.colors = [UIColor.white]
            line.valueTextColor = UIColor.clear
            
            let data = LineChartData()
            data.addDataSet(line)
            
            chartView.data = data
            chartView.chartDescription?.text = nil
            chartView.legend.form = .none
            chartView.xAxis.labelTextColor = UIColor.white
        }
        
    }

}
