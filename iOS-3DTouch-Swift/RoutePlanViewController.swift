//
//  RoutePlanViewController.swift
//  iOS-3DTouch
//
//  Created by eidan on 17/1/22.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class RoutePlanViewController: UIViewController {
    
    let RoutePlanningPaddingEdge = CGFloat(20)
    let RoutePlanningViewControllerStartTitle = "起点"
    let RoutePlanningViewControllerDestinationTitle = "终点"
    
    var routeType: NSInteger = 0
    
    var mapView: MAMapView!         //地图
    var search: AMapSearchAPI!      // 地图内的搜索API类
    var route: AMapRoute!           //路径规划信息
    var naviRoute: MANaviRoute?     //用于显示当前路线方案.
    
    var startAnnotation: MAPointAnnotation!
    var destinationAnnotation: MAPointAnnotation!
    
    var startCoordinate: CLLocationCoordinate2D! //起始点经纬度
    var destinationCoordinate: CLLocationCoordinate2D! //终点经纬度

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
