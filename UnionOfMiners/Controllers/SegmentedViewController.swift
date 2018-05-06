//
//  SegmentedViewController.swift
//  UnionOfMiners
//
//  Created by talgat on 15.10.17.
//  Copyright © 2017 Akezhan. All rights reserved.
//

import SJSegmentedScrollView
import UIKit
import EasyPeasy

class SegmentedViewController: SJSegmentedViewController {
    
    var selectedSegment: SJSegmentTab?
    var navigationBar:UINavigationController?
    
    override func viewDidLoad() {
        if let storyboard = self.storyboard {
            
            
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "Elements")
            firstViewController.title = "Подписки"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "News")
            secondViewController.title = "Новости"
            
            segmentControllers = [firstViewController,
                                  secondViewController
                                  ]
           
            headerViewHeight = 300
            selectedSegmentViewHeight = 1.0
            headerViewOffsetHeight = 25
            self.segmentViewHeight = 60
            self.segmentBackgroundColor = oneColor
            segmentTitleColor = .gray
            selectedSegmentViewColor = .white
            segmentShadow = SJShadow.light()
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
            delegate = self
            self.segmentBounces = true
            self.segmentTitleFont = UIFont.systemFont(ofSize: 14.0)
            
        }
        
        super.viewDidLoad()
    }
    
    func getSegmentTabWithImage(_ imageName: String) -> UIView {

        let view = UIImageView()
        view.frame.size.width = 100
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        return view
    }
}

extension SegmentedViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if selectedSegment != nil {
            selectedSegment?.titleColor(.lightGray)
        }
        
        if segments.count > 0 {
            selectedSegment = segments[index]
            selectedSegment?.titleColor(.white)
        }
        
        if selectedSegment == segments[1] {
            controller.viewDidLoad()
        }
    }

}
