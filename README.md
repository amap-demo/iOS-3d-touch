本工程为基于高德地图iOS SDK进行封装，集成了3DTouch预览兴趣点信息的功能
## 前述 ##
- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK、搜索SDK实现

## 功能描述 ##
通过搜索SDK进行POI周边搜索，在3D地图上展示。实现了对兴趣点标注进行3DTouch进行信息预览的功能。

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| AMapSearchAPI	| - (void)AMapPOIAroundSearch:(AMapPOIAroundSearchRequest *)request; | POI 周边查询接口 | v4.0.0 |

## 核心难点 ##

```
/*检查是否支持3D touch功能*/
- (void)check3DTouch
{
    // register for 3D Touch (if available)
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:(id)self sourceView:self.view];
        NSLog(@"3D Touch is available! Hurra!");
    }
    else
    {
        NSLog(@"3D Touch is not available on this device. Sniff!");
    }
}
```
```
/*实现3D touch delegate*/
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    __block BOOL touchOnAnnotation = NO;
    __block AMapPOI *poi = nil;
    
    [self.annotationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MAPinAnnotationView class]])
        {
            MAPinAnnotationView *view = (MAPinAnnotationView *)obj;
            CGPoint point = [view convertPoint:location fromView:self.mapView];
            
            if (CGRectContainsPoint(view.bounds, point))
            {
                touchOnAnnotation = YES;
                
                if ([view.annotation isKindOfClass:[POIAnnotation class]])
                {
                    POIAnnotation *annotion = (POIAnnotation *)view.annotation;
                    poi = annotion.poi;
                }
                
                *stop = YES;
            }
        }
    }];
    
    if (!touchOnAnnotation)
    {
        return nil;
    }
    
    // check if we're not already displaying a preview controller
    if ([self.presentedViewController isKindOfClass:[POIPreviewViewController class]])
    {
        return nil;
    }
    // shallow press: return the preview controller here (peek)
    self.selectedPoi = poi;
    
    POIPreviewViewController *previewController = [[POIPreviewViewController alloc] initWithUserPoint:self.userLocation.coordinate selectedPOI:self.selectedPoi];
    previewController.delegate = self;
    previewController.preferredContentSize = CGSizeMake(0, 400);
    
    return previewController;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    
    // deep press: bring up the commit view controller (pop)
    UIViewController *commitController = [[POIPreviewViewController alloc] initWithUserPoint:self.userLocation.coordinate selectedPOI:self.selectedPoi];

    [self showViewController:commitController sender:self];
}
```