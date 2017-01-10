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

class ExampleChart: FSLineChart {
    override func awakeFromNib() {
        load(Numbers: 1)
    }
    
    public func load(Numbers: Int) {
        var data: [Int] = []
        let count = getCountFromDatabase()
        for i in 0..<count.count {
            data.append(count[i].count)
        }
        verticalGridStep = 9
        horizontalGridStep = 9
        labelForIndex = { "\($0)" }
        labelForValue = { "$\($0)" }
        dataPointColor = UIColor.red
        animationDuration = 5.0
        setChartData(data)
    }
    
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
   
}

