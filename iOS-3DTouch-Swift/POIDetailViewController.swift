//
//  POIDetailViewController.swift
//  iOS-3DTouch
//
//  Created by eidan on 17/1/22.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class POIDetailViewController: UIViewController, MAMapViewDelegate {
    
    let RoutePlanningViewControllerStartTitle = "起点"
    let RoutePlanningViewControllerDestinationTitle = "终点"
    
    var poi: AMapPOI!
    var userLocaiton: CLLocation!
    var isFrom3DTouchPresent = false
    
    var startCoordinate: CLLocationCoordinate2D! //起始点经纬度
    var destinationCoordinate: CLLocationCoordinate2D! //终点经纬度
    
    //xib views
    @IBOutlet weak var mapView: MAMapView!
    @IBOutlet weak var mapViewTop: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = poi.name
        
        //模态弹出的话为0
        if isFrom3DTouchPresent {
            self.mapViewTop.constant = 0
        }
        
        self.startCoordinate = CLLocationCoordinate2DMake(self.userLocaiton.coordinate.latitude, self.userLocaiton.coordinate.longitude)
        self.destinationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(self.poi.location.latitude), CLLocationDegrees(self.poi.location.longitude))

        self.mapView.mapType = MAMapType.satellite
        self.mapView.delegate = self
        self.mapView.isScrollEnabled = false
        self.mapView.isZoomEnabled = false
        self.mapView.isRotateCameraEnabled = false
        self.mapView.showsScale = false
        self.mapView.showsCompass = false
        self.mapView.isShowsLabels = false
        self.mapView.isShowTraffic = false
        self.mapView.isRotateEnabled = false
        
        self.addressLabel.text = self.poi.address
        self.telLabel.text = self.poi.tel
        
        self.addDefaultAnnotations()
        
    }
    
    //在地图上添加起始和终点的标注点
    func addDefaultAnnotations() {
        let startAnnotation = MAPointAnnotation()
        startAnnotation.coordinate = self.startCoordinate
        startAnnotation.title = RoutePlanningViewControllerStartTitle
        startAnnotation.subtitle = "{\(self.startCoordinate.latitude), \(self.startCoordinate.longitude)}"
        let destinationAnnotation = MAPointAnnotation()
        destinationAnnotation.coordinate = self.destinationCoordinate
        destinationAnnotation.title = RoutePlanningViewControllerDestinationTitle
        destinationAnnotation.subtitle = "{\(self.destinationCoordinate.latitude), \(self.destinationCoordinate.longitude)}"
        self.mapView.addAnnotation(startAnnotation)
        self.mapView.addAnnotation(destinationAnnotation)
        
        self.mapView.showAnnotations([startAnnotation, destinationAnnotation], edgePadding: UIEdgeInsetsMake(20, 20, 20, 20), animated: false)
    }
    
    //MARK: - Preview Actions
    
    @available(iOS 9.0, *)
    lazy var previewActions: [UIPreviewActionItem] = {
        
        func previewActionForTitle(_ title: String, index: NSInteger, style: UIPreviewActionStyle = .default) -> UIPreviewAction {
            
            return UIPreviewAction(title: title, style: style) { previewAction, viewController in

                self.showRoute(index:index)
                
            }
            
        }
        
        let action1 = previewActionForTitle("步行",index:1)
        let action2 = previewActionForTitle("公交",index:2)
        let action3 = previewActionForTitle("驾车",index:3)
        
        return [action1, action2, action3]
        
    }()
    
    @available(iOS 9.0, *)
    override var previewActionItems: [UIPreviewActionItem] {
        return previewActions
    }
    
    // MARK: -Xib Click
    
    @IBAction func showRouteClick(_ sender: UIButton) {
        let tag = sender.tag
        self.showRoute(index: tag)
    }
    
    // MARK: -Show Route
    
    func showRoute(index : NSInteger) {
        print(index)
    }
    
    
    // MARK: - MAMapViewDelegate
    
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
            
            if annotation.title == RoutePlanningViewControllerStartTitle {
                annotationView!.image = UIImage(named: "startPoint")
            }
            else if annotation.title == RoutePlanningViewControllerDestinationTitle {
                annotationView!.image = UIImage(named: "endPoint")
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
