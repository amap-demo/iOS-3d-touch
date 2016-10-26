//
//  POIPreviewViewController.h
//  officialDemo2D
//
//  Created by KuangYe on 15/11/18.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class AMapPOI;
@class MARouteViewController;

@protocol PreviewActionDelegate <NSObject>

- (void)presentViewContrller:(UIViewController *)controller;

@end

@interface POIPreviewViewController : UIViewController


- (instancetype)initWithUserPoint:(CLLocationCoordinate2D)userCoor selectedPOI:(AMapPOI *)poi;

@property (nonatomic, weak) id<PreviewActionDelegate> delegate;

@end
