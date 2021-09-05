//
//  ViewController.swift
//  BarChart
//
//  Created by Penny Huang on 2021/3/16.
//

import UIKit
import Charts

class ViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var chartView: BarChartView!
    let customMarkerView = CustomMarkerView()
    var items = [CountryItem]()
    let populationReplacementRate = 2.1
    let highIncomeAverage = 1.6
    
    private let rawData = [
        "Australia, 1.83",
        "Belgium, 1.71",
        "Germany, 1.59",
        "Japan, 1.4",
        "Netherlands, 1.66",
        "Norway, 1.72",
        "Singapore, 1.20",
        "Taiwan, 1.15",
        "South Korea, 0.92",
        "United Kingdom, 1.8",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        items = getFormattedItemValue(rawData)
        
        setupData()
        setupChart()
        setupMarker()
    }

    //MARK: - init Methods
    func setupChart() {
        chartView.delegate = self
        chartView.highlightPerTapEnabled = true
        chartView.highlightFullBarEnabled = true
        chartView.highlightPerDragEnabled = false
        
        chartView.pinchZoomEnabled = false
        chartView.setScaleEnabled(false)
        chartView.doubleTapToZoomEnabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.drawBordersEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.animate(yAxisDuration: 1.5 , easingOption: .easeOutBounce)
        chartView.legend.enabled = false
        chartView.borderColor = .chartLineColour
        chartView.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 50)
        
        // Setup X axis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.labelRotationAngle = -25
        xAxis.setLabelCount(rawData.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: items.map { $0.country })
        xAxis.axisMaximum = Double(rawData.count)
        xAxis.axisLineColor = .chartLineColour
        xAxis.labelTextColor = .chartLineColour

        // Setup left axis
        let leftAxis = chartView.leftAxis
        leftAxis.drawTopYLabelEntryEnabled = true
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
//        leftAxis.granularity = 1
        leftAxis.axisLineColor = .chartLineColour
        leftAxis.labelTextColor = .chartLineColour

        leftAxis.setLabelCount(5, force: false)
        leftAxis.axisMinimum = 0.0
        leftAxis.axisMaximum = 2.5
        
        // Remove right axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        // Setup replacement rate line
        let replacementRateLine = ChartLimitLine()
        replacementRateLine.limit = populationReplacementRate
        replacementRateLine.lineColor = .chartReplacementColour
        replacementRateLine.valueTextColor = .chartReplacementColour
        replacementRateLine.label = "Population Replacement Rate: \(populationReplacementRate)"
        replacementRateLine.labelPosition = .topLeft
        leftAxis.addLimitLine(replacementRateLine)
        
        // Setup high income average line
        let highIncomeAverageLine = ChartLimitLine()
        highIncomeAverageLine.limit = highIncomeAverage
        highIncomeAverageLine.lineColor = .chartAverageColour
        highIncomeAverageLine.valueTextColor = .chartAverageColour
        highIncomeAverageLine.label = "Average (High Income): \(highIncomeAverage)"
        highIncomeAverageLine.labelPosition = .bottomLeft
        leftAxis.addLimitLine(highIncomeAverageLine)
    }

    func setupData() {
        let dataEntries = items.map{ $0.transformToBarChartDataEntry() }
        
        let set1 = BarChartDataSet(entries: dataEntries)
        set1.setColor(.chartBarColour)
        set1.highlightColor = .chartHightlightColour
        set1.highlightAlpha = 1
        
        let data = BarChartData(dataSet: set1)
        data.setDrawValues(true)
        data.setValueTextColor(.chartLineColour)
        let barValueFormatter = BarValueFormatter()
        data.setValueFormatter(barValueFormatter)
        chartView.data = data
    }
    
    func setupMarker() {
        customMarkerView.chartView = chartView
        chartView.marker = customMarkerView
    }
    
    // MARK: - Logic Methods
    func getFormattedItemValue(_ rawValues: [String]) -> [CountryItem] {
        var items = [CountryItem]()
        var index = 0
        
        for i in rawValues {
            let valuePair = i.components(separatedBy: ", ")
            let country = valuePair[0]
            let birthRateStr = valuePair[1]
            
            let birthRate = Double(birthRateStr) ?? 0.0

            items.append(CountryItem(index: index, country: country, birthRate: birthRate))
            index += 1
        }
        return items
    }

    // MARK: - Chart Methods
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        let entryIndex = dataSet.entryIndex(entry: entry)

        customMarkerView.rateLabel.text = "\(items[entryIndex].birthRate)"
        customMarkerView.countryLabel.text = items[entryIndex].country
    }
}

// MARK: - Type Definition
struct CountryItem {
    let index: Int
    let country: String
    let birthRate: Double
    
    func transformToBarChartDataEntry() -> BarChartDataEntry {
        let entry = BarChartDataEntry(x: Double(index), y: birthRate)
        return entry
    }
}

class BarValueFormatter: IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value)
    }
}

extension UIColor {
    static let chartBarColour = #colorLiteral(red: 1, green: 0.831372549, blue: 0.3764705882, alpha: 1)
    static let chartLineColour = #colorLiteral(red: 0.1764705882, green: 0.2509803922, blue: 0.3490196078, alpha: 1)
    static let chartReplacementColour = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3333333333, alpha: 1)
    static let chartAverageColour = #colorLiteral(red: 0.9176470588, green: 0.3294117647, blue: 0.3333333333, alpha: 1)
    static let chartBarValueColour = #colorLiteral(red: 0.9411764706, green: 0.4823529412, blue: 0.2470588235, alpha: 1)
    static let chartHightlightColour = #colorLiteral(red: 0.9411764706, green: 0.4823529412, blue: 0.2470588235, alpha: 1)
}

