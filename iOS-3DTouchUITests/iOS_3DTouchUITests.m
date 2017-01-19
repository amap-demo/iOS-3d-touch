//
//  iOS_3DTouchUITests.m
//  iOS-3DTouchUITests
//
//  Created by hanxiaoming on 17/1/18.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOS_3DTouchUITests : XCTestCase

@end

@implementation iOS_3DTouchUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    sleep(1);
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"3DTouch"] tap];
    
    sleep(2);
    XCUIElement *mapElement = [[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"3D Touch Demo"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1];
    
    XCUIElement *element1 = [[mapElement childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:8];
    
    [element1 tap];
    
    sleep(1);
    
    XCUIElement *calloutView1 = [[element1 descendantsMatchingType:XCUIElementTypeAny] childrenMatchingType:XCUIElementTypeButton].element;
    XCUICoordinate *cooridnate1 = [[calloutView1 coordinateWithNormalizedOffset:CGVectorMake(0, 0)] coordinateWithOffset:CGVectorMake(calloutView1.frame.size.width - 20, 25)];
    [cooridnate1 tap];

    
    sleep(1);
    [app.tables.buttons[@"car"] tap];
    
    sleep(3);
    [[app.navigationBars.buttons elementBoundByIndex:0] tap];
    
    sleep(1);
    [[app.navigationBars.buttons elementBoundByIndex:0] tap];
    
    sleep(1);
}

@end
