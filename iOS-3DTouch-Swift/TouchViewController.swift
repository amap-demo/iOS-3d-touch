//
//  TouchViewController.swift
//  iOS-3DTouch
//
//  Created by eidan on 17/1/22.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class TouchViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate,UIViewControllerPreviewingDelegate {
    
    let KAPIKey = "95ed2da3e9f4ece6319afbc437fc0b01"
    
    var mapView: MAMapView!         //地图
    var search: AMapSearchAPI!      // 地图内的搜索API类
    
    var selectedPOI: AMapPOI?
    
    var poiAnnotationViews = [MAPinAnnotationView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "请用力点击Annotation"
        
        AMapServices.shared().apiKey = KAPIKey
        
        self.initMapViewAndSearch()
        
        self.searchPoiKeyword("肯德基")
        
        self.check3DTouch()

        // Do any additional setup after loading the view.
    }
    
    //初始化地图,和搜索API
    func initMapViewAndSearch() {
        self.mapView = MAMapView(frame: CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(self.view.bounds.size.width), height: CGFloat(self.view.bounds.size.height - 64)))
        self.mapView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = MAUserTrackingMode.follow
        self.view.addSubview(self.mapView)
        self.view.sendSubview(toBack: self.mapView)
        self.search = AMapSearchAPI()
        self.search.delegate = self
    }
    
    //搜索POI
    func searchPoiKeyword(_ keyword: String) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.city = "北京"
        request.offset = 20
        self.search.aMapPOIKeywordsSearch(request)
    }
    
    //是否支持3D Touch，如果支持，注册一下
    func check3DTouch() {
        if #available(iOS 9.0, *) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                self.registerForPreviewing(with: self, sourceView: self.view)
                print("3D Touch is available! Hurra!");
            }
        } else {
            print("3D Touch is not available on this device. Sniff!");
        }
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    
    //3DTouch刚触发的时候弹出的模态视图
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        var touchOnAnnotation = false
        var selectPoi: AMapPOI?
        
        //找到点击的哪个点
        for (_, poiAnnotationView) in self.poiAnnotationViews.enumerated() {
            
            if poiAnnotationView.frame.contains(location) {
                
                touchOnAnnotation = true;
                
                let poiAnno: POIAnnotation = poiAnnotationView.annotation as! POIAnnotation
                
                selectPoi = poiAnno.poi
                
                break;
            }
            
        }
        
        if touchOnAnnotation == false {
            return nil
        }
        
        // check if we're not already displaying a preview controller
        if self.presentedViewController != nil {
            return nil
        }
        
        self.selectedPOI = selectPoi
        
        let poiDetailVC: POIDetailViewController = POIDetailViewController(nibName: "POIDetailViewController", bundle: nil)
        poiDetailVC.poi = selectPoi
        poiDetailVC.userLocaiton = self.mapView.userLocation.location
        poiDetailVC.isFrom3DTouchPresent = true
        poiDetailVC.preferredContentSize = CGSize.init(width: 0, height: 400)
        
        return poiDetailVC
        
    }
    
    //模态视图弹出后，继续按住屏幕不放，就会调用下面这句话，进入VC
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        let poiDetailVC: POIDetailViewController = POIDetailViewController(nibName: "POIDetailViewController", bundle: nil)
        poiDetailVC.poi = self.selectedPOI
        poiDetailVC.userLocaiton = self.mapView.userLocation.location
        
        self.show(poiDetailVC, sender: self)
    }
    
    // MARK: - AMapSearchDelegate
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.poiAnnotationViews.removeAll()
        
        if response.pois.count == 0 {
            return;
        }
        
        var poiAnnotations = [POIAnnotation]()
        
        for (_, obj) in response.pois.enumerated() {
            
            let anno: POIAnnotation = POIAnnotation.init(poi: obj)
            poiAnnotations.append(anno)
            
        }
        
        /* 将结果以annotation的形式加载到地图上. */
        self.mapView.addAnnotations(poiAnnotations)
        
        if poiAnnotations.count == 1 { /* 如果只有一个结果，设置其为中心点. */
            self.mapView.setCenter(poiAnnotations[0].coordinate, animated: false)
        } else {
            self.mapView.showAnnotations(poiAnnotations, animated: false)
        }
        
    }
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let annotation : MAAnnotation = view.annotation
        if annotation.isKind(of: POIAnnotation.self) {
            let poiAnno: POIAnnotation = annotation as! POIAnnotation
            
            self.selectedPOI = poiAnno.poi
            
            let poiDetailVC: POIDetailViewController = POIDetailViewController(nibName: "POIDetailViewController", bundle: nil)
            poiDetailVC.poi = poiAnno.poi
            poiDetailVC.userLocaiton = self.mapView.userLocation.location
            
            self.navigationController?.pushViewController(poiDetailVC, animated: true)
        }
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: POIAnnotation.self) {
            
            //标注的view的初始化和复用
            let pointReuseIndetifier = "poiIdentifier"
            
            var poiAnnotationView: MAPinAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView!
            
            if poiAnnotationView == nil {
                poiAnnotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                self.poiAnnotationViews.append(poiAnnotationView)
            }

            poiAnnotationView.canShowCallout = true
            poiAnnotationView.rightCalloutAccessoryView = UIButton.init(type: UIButtonType.detailDisclosure)
            poiAnnotationView.rightCalloutAccessoryView.accessibilityIdentifier = "rightCalloutAccessoryView"
            
            return poiAnnotationView!
        }
        
        return nil
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
