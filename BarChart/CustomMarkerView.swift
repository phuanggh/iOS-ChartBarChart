//
//  CustomMarkerView.swift
//  BarChart
//
//  Created by Penny Huang on 2021/9/5.
//

import UIKit
import Charts

class CustomMarkerView: MarkerView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var markerBoard: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var markerStick: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    private func initUI() {
        Bundle.main.loadNibNamed("CustomMarkerView", owner: self, options: nil)
        addSubview(contentView)
        markerStick.backgroundColor = .chartHightlightColour
        markerBoard.backgroundColor = .chartHightlightColour
        markerBoard.layer.cornerRadius = 5
        rateLabel.textColor = .white
        countryLabel.textColor = .white

        self.frame = CGRect(x: 0, y: 0, width: 79, height: 73)
        self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height)
    }

}
