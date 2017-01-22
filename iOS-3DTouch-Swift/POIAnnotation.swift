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
    
    var title: String{
        get {
            return self.poi.name
        }
    }
    
    var subtitle: String {
        get {
            return self.poi.address
        }
    }
    
    init(poi:AMapPOI) {
        super.init()
        self.poi = poi
    }
    
}
