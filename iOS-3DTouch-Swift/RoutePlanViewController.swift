//
//  RoutePlanViewController.swift
//  iOS-3DTouch
//
//  Created by eidan on 17/1/22.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class RoutePlanViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {
    
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
    
    var totalRouteNums: NSInteger!  //总共规划的线路的条数

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "路线详情"
        
        self.initMapViewAndSearch()
        
        self.resetSearchResultAndXibViewsToDefault()
        
        self.addDefaultAnnotations()
        
        self.searchRoute()

        // Do any additional setup after loading the view.
    }
    
    //初始化地图,和搜索API
    func initMapViewAndSearch() {
        self.mapView = MAMapView(frame: CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(self.view.bounds.size.width), height: CGFloat(self.view.bounds.size.height - 64)))
        self.mapView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        self.search = AMapSearchAPI()
        self.search.delegate = self
    }
    
    //初始化或者规划失败后，设置view和数据为默认值
    func resetSearchResultAndXibViewsToDefault() {
        self.totalRouteNums = 0
        self.naviRoute?.removeFromMapView()
    }
    
    //在地图上添加起始和终点的标注点
    func addDefaultAnnotations() {
        let startAnnotation = MAPointAnnotation()
        startAnnotation.coordinate = self.startCoordinate
        startAnnotation.title = RoutePlanningViewControllerStartTitle
        startAnnotation.subtitle = "{\(self.startCoordinate.latitude), \(self.startCoordinate.longitude)}"
        self.startAnnotation = startAnnotation
        let destinationAnnotation = MAPointAnnotation()
        destinationAnnotation.coordinate = self.destinationCoordinate
        destinationAnnotation.title = RoutePlanningViewControllerDestinationTitle
        destinationAnnotation.subtitle = "{\(self.destinationCoordinate.latitude), \(self.destinationCoordinate.longitude)}"
        self.destinationAnnotation = destinationAnnotation
        self.mapView.addAnnotation(startAnnotation)
        self.mapView.addAnnotation(destinationAnnotation)
    }
    
    //路线开始规划
    func searchRoute() {
        
        let origin: AMapGeoPoint = AMapGeoPoint.location(withLatitude: CGFloat(self.startCoordinate.latitude), longitude: CGFloat(self.startCoordinate.longitude))
        let destination: AMapGeoPoint = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationCoordinate.latitude), longitude: CGFloat(self.destinationCoordinate.longitude))
        
        if self.routeType == 1 {  //步行
            
            let navi = AMapWalkingRouteSearchRequest()
            navi.multipath = 1; ///提供备选方案
            navi.origin = origin
            navi.destination = destination
            self.search.aMapWalkingRouteSearch(navi)
            
        } else if self.routeType == 2 {  //公交
            
            let navi = AMapTransitRouteSearchRequest()
            navi.city = "beijing"  //指定城市，必填
            navi.origin = origin
            navi.destination = destination
            self.search.aMapTransitRouteSearch(navi)
            
        } else if self.routeType == 3 {  //驾车
            
            let navi = AMapDrivingRouteSearchRequest()
            navi.requireExtension = true
            navi.strategy = 5 //驾车导航策略,5-多策略（同时使用速度优先、费用优先、距离优先三个策略）
            navi.origin = origin
            navi.destination = destination
            self.search.aMapDrivingRouteSearch(navi)
            
        }
        
    }
    
    //在地图上显示当前选择的路径
    func presentCurrentRouteCourse() {
        
        if self.totalRouteNums <= 0 {
            return
        }
        
        self.naviRoute?.removeFromMapView() //清空地图上已有的路线
        
        let startPoint = AMapGeoPoint.location(withLatitude: CGFloat(self.startAnnotation.coordinate.latitude), longitude: CGFloat(self.startAnnotation.coordinate.longitude)) //起点
        
        let endPoint = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationAnnotation.coordinate.latitude), longitude: CGFloat(self.destinationAnnotation.coordinate.longitude))  //终点
        
        var type = MANaviAnnotationType.walking //类型
        
        if self.routeType == 1 {  //步行
            
            type =  MANaviAnnotationType.walking
            self.naviRoute = MANaviRoute(for: self.route.paths[0], withNaviType: type, showTraffic: false, start: startPoint, end: endPoint)
            
        } else if self.routeType == 2 {  //公交
            
            type =  MANaviAnnotationType.bus
            self.naviRoute = MANaviRoute(for: self.route.transits[0], start: startPoint, end: endPoint)
            
        } else if self.routeType == 3 {  //驾车
            
            type =  MANaviAnnotationType.drive
            self.naviRoute = MANaviRoute(for: self.route.paths[0], withNaviType: type, showTraffic: false, start: startPoint, end: endPoint)
            
        }
        
        self.naviRoute?.add(to: self.mapView)
        
        //显示到地图上
        let edgePaddingRect = UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge)
        //缩放地图使其适应polylines的展示
        self.mapView.setVisibleMapRect(CommonUtility.mapRect(forOverlays: self.naviRoute?.routePolylines), edgePadding: edgePaddingRect, animated: true)
    }
    
    
    // MARK: - AMapSearchDelegate
    
    //当路径规划搜索请求发生错误时，会调用代理的此方法
    func aMapSearchRequest(_ request: Any, didFailWithError error: Error?) {
        print("Error: \(error)")
        self.resetSearchResultAndXibViewsToDefault()
    }
    
    //路径规划搜索完成回调.
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest, response: AMapRouteSearchResponse) {
        if response.route == nil {
            self.resetSearchResultAndXibViewsToDefault()
            return
        }
        self.route = response.route
        if self.routeType == 2 {  //公交
            self.totalRouteNums = self.route.transits.count
        } else {
            self.totalRouteNums = self.route.paths.count
        }
        self.presentCurrentRouteCourse()
    }
    
    // MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        
        //虚线，如需要步行的
        if overlay.isKind(of: LineDashPolyline.self) {
            let naviPolyline: LineDashPolyline = overlay as! LineDashPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 6
            renderer.strokeColor = UIColor.red
            renderer.lineDash = true
            
            return renderer
        }
        
        //showTraffic为NO时，不需要带实时路况，路径为单一颜色，比如驾车线路目前为blueColor
        if overlay.isKind(of: MANaviPolyline.self) {
            
            let naviPolyline: MANaviPolyline = overlay as! MANaviPolyline
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: naviPolyline.polyline)
            renderer.lineWidth = 6
            
            if naviPolyline.type == MANaviAnnotationType.walking {
                renderer.strokeColor = naviRoute?.walkingColor
            }
            else if naviPolyline.type == MANaviAnnotationType.railway {
                renderer.strokeColor = naviRoute?.railwayColor;
            }
            else {
                renderer.strokeColor = naviRoute?.routeColor;
            }
            
            return renderer
        }
        
        //showTraffic为YES时，需要带实时路况，路径为多颜色渐变
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(multiPolyline: overlay as! MAMultiPolyline!)
            renderer.lineWidth = 6
            renderer.strokeColors = naviRoute?.multiPolylineColors
            
            return renderer
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            
            //标注的view的初始化和复用
            let pointReuseIndetifier = "RoutePlanningCellIdentifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView!.canShowCallout = true
                annotationView!.isDraggable = false
            }
            
            annotationView!.image = nil
            
            if annotation.isKind(of: MANaviAnnotation.self) {
                let naviAnno = annotation as! MANaviAnnotation
                
                switch naviAnno.type {
                case MANaviAnnotationType.railway:
                    annotationView!.image = UIImage(named: "railway_station")
                    break
                case MANaviAnnotationType.drive:
                    annotationView!.image = UIImage(named: "car")
                    break
                case MANaviAnnotationType.riding:
                    annotationView!.image = UIImage(named: "ride")
                    break
                case MANaviAnnotationType.walking:
                    annotationView!.image = UIImage(named: "man")
                    break
                case MANaviAnnotationType.bus:
                    annotationView!.image = UIImage(named: "bus")
                    break
                }
            }
            else {
                if annotation.title == "起点" {
                    annotationView!.image = UIImage(named: "startPoint")
                }
                else if annotation.title == "终点" {
                    annotationView!.image = UIImage(named: "endPoint")
                }
            }
            return annotationView!
        }
        
        return nil
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
