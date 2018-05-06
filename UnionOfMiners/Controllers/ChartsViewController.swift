
//
//  ChartsViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 26.09.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import UIKit
import Charts
import Firebase
import EasyPeasy
import Alamofire
import Kingfisher


class ChartsViewController: UIViewController,ChartViewDelegate, IAxisValueFormatter{
    
    var lineChartView = LineChartView()
    var allTimeLineChartView = LineChartView()
    var coinName: String?
    var coinImageUrl: String?
    var coinNameFull: String?
    var coinImage = UIImageView()
    var dolarLabel = UILabel()
    var coinNameFullLabel = UILabel()
    var coinNameLabel = UILabel()
    var coinNameShort: String?
    var coinNameShortLabel = UILabel()
    var warningLabel = UILabel()
    var lineLabel = UILabel()
    var marketPrice = [Double]()
    var marketPriceLabel = UILabel()
    var marketPriceNameLabel = UILabel()
    var coinPriceLabel = UILabel()
    var coinTimeLabel = UILabel()
    var oneDay = UIButton()
    var week = UIButton()
    var mounth = UIButton()
    
    var ref : DatabaseReference?
    var descriptionOfThePoint = UILabel()
    var dataOfThePoint = UILabel()
    var allStatistics = [[String:String]]()
    var values = [Double]()
    var dataPoints = [String]()
    
    var index = 0
    var counter = 0

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = oneColor
       
        Statistics.convertToImage(url: coinImageUrl!){response, err in
           
            self.coinImage.image = response
        }
        
        oneDay.addTarget(self, action: #selector(changeTime(_:)), for: .touchUpInside)
        week.addTarget(self, action: #selector(changeTime(_:)), for: .touchUpInside)
        mounth.addTarget(self, action: #selector(changeTime(_:)), for: .touchUpInside)
        
        oneDay.tag = 0
        week.tag = 1
        mounth.tag = 2
    }
    
    func changeTime(_ elem: UIButton){
        
        if elem.tag == 0 {
            defaults.set(true, forKey: "1day")
            defaults.set(false, forKey: "7day")
            defaults.set(false, forKey: "30day")
            elem.isSelected = defaults.bool(forKey: "1day")
            week.isSelected = defaults.bool(forKey: "7day")
            mounth.isSelected = defaults.bool(forKey: "30day")
        } else if elem.tag == 1{
            defaults.set(false, forKey: "1day")
            defaults.set(true, forKey: "7day")
            defaults.set(false, forKey: "30day")
            elem.isSelected = defaults.bool(forKey: "7day")
            oneDay.isSelected = defaults.bool(forKey: "1day")
            mounth.isSelected = defaults.bool(forKey: "30day")
        } else {
            defaults.set(false, forKey: "1day")
            defaults.set(false, forKey: "7day")
            defaults.set(true, forKey: "30day")
            elem.isSelected = defaults.bool(forKey: "30day")
            oneDay.isSelected = defaults.bool(forKey: "1day")
            week.isSelected = defaults.bool(forKey: "7day")
        }
        
        changeTimeRange((elem.titleLabel?.text)!)
    }
    
    func changeTimeRange(_ data:String){
        
        self.showActivityIndicator()
        
        Statistics.changeTime(coinName: coinName!,data: data){(el,ele,elee) in
            
            self.marketPrice = elee
            self.dataPoints = ele
            self.values = el
            
            if self.values.count != 0{
                self.hideActivityIndicator()
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 0;
            
            self.setChart(dataPoints: self.dataPoints, Values: self.values, chart: self.lineChartView)
            self.descriptionOfThePoint.text = "$  " + String((round(self.values[self.values.count - 1]*1000)/1000))
            self.dataOfThePoint.text = " " + String(describing: self.dataPoints[self.dataPoints.count - 1])
            self.marketPriceLabel.text = formatter.string(for: (Int(round((self.marketPrice[(self.marketPrice.count) - 1])*1000)/1000)) as Int)!
        }
        
    }
    
    func check() -> String{
        if defaults.bool(forKey: "1day") == true{
             return "1day"
        } else if defaults.bool(forKey: "7day") == true {
            return "7day"
        } else {
            return "30day"
        }
    }
    
    override func viewWillAppear(_ appear:Bool) {
        super.viewWillAppear(true)
        
        warningLabel.isHidden = true
        changeTimeRange(check())
        self.view.addSubview(oneDay)
        self.view.addSubview(week)
        self.view.addSubview(coinTimeLabel)
        self.view.addSubview(coinPriceLabel)
        self.view.addSubview(marketPriceLabel)
        self.view.addSubview(descriptionOfThePoint)
        self.view.addSubview(allTimeLineChartView)
        self.view.addSubview(lineChartView)
        self.view.addSubview(coinImage)
        self.view.addSubview(dataOfThePoint)
        self.view.addSubview(coinNameFullLabel)
        self.view.addSubview(coinNameShortLabel)
        self.view.addSubview(warningLabel)
        self.view.addSubview(lineLabel)
        self.view.addSubview(marketPriceNameLabel)
        self.view.addSubview(mounth)
        
        descriptionOfThePoint.isHidden = false
        
        lineChartView.delegate = self
        lineChartView.xAxis.valueFormatter = self
        
        allTimeLineChartView.delegate = self
        allTimeLineChartView.xAxis.valueFormatter = self
        
        coinNameFullLabel.text = coinNameFull
        coinNameShortLabel.text = coinNameShort
        
        marketPriceNameLabel.text = "Капитал"
        coinPriceLabel.text = "Цена"
        
        self.oneDay.isSelected = self.defaults.bool(forKey: "1day")
        self.week.isSelected = self.defaults.bool(forKey: "7day")
        self.mounth.isSelected = self.defaults.bool(forKey: "30day")

        oneDay.setTitleColor(.gray, for: .selected)
        week.setTitleColor(.gray, for: .selected)
        mounth.setTitleColor(.gray, for: .selected)
        
        oneDay.setTitle("1day", for: .normal)
        oneDay.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 18)
        oneDay.titleLabel?.textColor = .white
        
        week.setTitle("7day", for: .normal)
        week.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 18)
        week.titleLabel?.textColor = .white
        
        mounth.setTitle("30day", for: .normal)
        mounth.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 18)
        mounth.titleLabel?.textColor = .white
        
        coinNameFullLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        coinNameFullLabel.font = UIFont.boldSystemFont(ofSize: 20)
        coinNameShortLabel.font = UIFont(name: "Avenir Next Medium", size: 16)
        marketPriceLabel.font = UIFont(name: "Avenir Next Medium", size: 16)
        marketPriceNameLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
        coinPriceLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        coinTimeLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
        
        dataOfThePoint.textAlignment = .center
        
        marketPriceNameLabel.textColor = .white
        self.descriptionOfThePoint.textColor = .white
        self.dataOfThePoint.textColor = .white
        coinNameFullLabel.textColor = .white
        coinNameLabel.textColor = .white
        coinNameShortLabel.textColor = .white
        marketPriceLabel.textColor = .white
        coinTimeLabel.textColor = .white
        coinPriceLabel.textColor = .white
        
        lineLabel.backgroundColor = .white
        self.descriptionOfThePoint.font = UIFont(name: "Avenir Next Medium", size: 30)
        self.dataOfThePoint.font = UIFont(name: "Avenir Next Medium", size: 20)
        
        descriptionOfThePoint.numberOfLines = 2
        
        //MARK: constraints
        marketPriceLabel <- [Top(20).to(descriptionOfThePoint), Width(150), RightMargin(0), Height(30)]
        coinPriceLabel <- [Top(40), Width(100), RightMargin(20), Height(30)]
        descriptionOfThePoint <- [TopMargin(70), Width(150), RightMargin(10), Height(50)]
        dataOfThePoint <- [Top(220), Height(100), RightMargin(0), LeftMargin(0)]
        lineChartView <- [BottomMargin(10),RightMargin(0), LeftMargin(0), Height(self.view.frame.height*0.5)]
        coinImage <- [TopMargin(50),LeftMargin(30),Height(50),Width(50)]
        coinNameFullLabel <- [TopMargin(110),LeftMargin(30),Height(20),Width(200)]
        coinNameShortLabel <- [Top(5).to(coinNameFullLabel), LeftMargin(30), Height(20),Width(120)]
        lineLabel <- [Bottom(5).to(dataOfThePoint), Right(0),Left(0), Height(3)]
        marketPriceNameLabel <- [Top(5).to(descriptionOfThePoint), Width(100), RightMargin(20), Height(20)]
        
        oneDay <- [Bottom(5).to(lineLabel), Height(40), LeftMargin(20), Width(60)]
        mounth <- [Bottom(5).to(lineLabel), Height(40), RightMargin(20), Width(60)]
        week <- [Bottom(5).to(lineLabel), Height(40), Right(30).to(mounth),Left(30).to(oneDay)]
    }
    
    //MARK: when the user touches the screen of the graph
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        self.descriptionOfThePoint.text = "$  " + String((round(entry.y*1000)/1000))
        self.dataOfThePoint.text = " " + String(describing: entry.data!)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0;
        
        self.marketPriceLabel.text = formatter.string(for: Int(self.marketPrice[
            dataPoints.index(of: entry.data! as! String)!]) as Int)!
    
        descriptionOfThePoint.isHidden = false
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        return ""

    }
    
    
    
    func setChart(dataPoints:[String]?, Values:[Double], chart: LineChartView){
        
        var dataEntries: [ChartDataEntry] = []
        
        
        for i in 0..<dataPoints!.count{
            
            let DataEntry = ChartDataEntry(x: Double(i), y:Values[i],data: dataPoints?[i] as AnyObject)
            
            dataEntries.append(DataEntry)
            
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Курс биткоина")
        
        lineChartDataSet.drawCirclesEnabled = false
        
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        lineChartDataSet.drawFilledEnabled = true // Draw the Gradient
        
        chart.leftAxis.labelTextColor = .white
        
        chart.data = lineChartData
        chart.borderLineWidth = 4
        chart.data?.setValueTextColor(UIColor.clear)
        chart.backgroundColor = oneColor
       // chart.xAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
       // chart.leftAxis.drawLabelsEnabled = false
        chart.legend.enabled = false
        chart.clipValuesToContentEnabled = false
        chart.chartDescription?.text = ""
        
    }


}
