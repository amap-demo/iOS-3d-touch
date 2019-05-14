//
//  POIAnnotation.swift
//  MultipleInfowindows
//
//  Created by eidan on 17/1/16.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class POIAnnotation: NSObject,MAAnnotation {
    
    var poi: AMapPOI!
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(CLLocationDegrees(self.poi.location.latitude), CLLocationDegrees(self.poi.location.longitude))
        }
    }
    
    @objc var title: String{//因为这个title在SDK内部，会使用OC调用，所以必须添加@objc,否则会报unrecognized selector
        get {
            return self.poi.name
        }
    }
    
    @objc var subtitle: String {//同title一样，也需要添加@objc
        get {
            return self.poi.address
        }
    }
    
    init(poi:AMapPOI) {
        super.init()
        self.poi = poi
    }
    
}
