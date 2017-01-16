//
//  ExampleChart.swift
//  Testing
//
//  Created by admin on 07/01/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import FSLineChart
import RealmSwift
import SwiftChart

class ExampleChart: UIViewController, ChartDelegate {
    
    @IBOutlet weak var chart: Chart!
    var selectedChart = 0
    override func viewDidLoad() {
        chart.delegate = self
        var data: Array<Float> = [1.0, 8.0, 4.0, 5.0, 7.0, 9.0, 2.0, 3.0, 8.0]
        let count = getCountFromDatabase()
        for i in 0..<count.count {
                        data.append(Float(count[i].count))
                    }
        let series = ChartSeries(data)
        series.area = true
        chart.add(series)
        // Set minimum and maximum values for y-axis
        chart.minY = 0
        chart.maxY = 9
        chart.minX = 0
        chart.maxX = 9
        // Format y-axis, e.g. with units
        chart.yLabelsFormatter = { String(Int($1)) +  "ºC" }
}
    
//    override func awakeFromNib() {
//        load(Numbers: 1)
//    }
//    
//    public func load(Numbers: Int) {
//        var data: [Int] = []
//        let count = getCountFromDatabase()
//        for i in 0..<count.count {
//            data.append(count[i].count)
//        }
//        verticalGridStep = 9
//        horizontalGridStep = 9
//        labelForIndex = { "\($0)" }
//        labelForValue = { "$\($0)" }
//        dataPointColor = UIColor.red
//        animationDuration = 5.0
//        setChartData(data)
//    }
//    
    public func getCountFromDatabase() -> Results<NumberCount>
    {
        do {
            let realm = try Realm()
            print("Number is :",realm.objects(NumberCount.self))
            return realm.objects(NumberCount.self)
        }
        catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }

   
}

