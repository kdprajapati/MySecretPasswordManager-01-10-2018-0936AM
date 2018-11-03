//
//  AppDelegate.h
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MPassCodeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PasscodeDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *pascodeWindow;


#pragma mark :- App lock timer method
-(void)funOpenSecurityAfterSomeMins;
-(void)funStartSecurityTimer:(NSTimeInterval)timeInterval;
-(void)funInvalidateSecurityTimer;
-(void)funOpenSecurity;
@end

/*
 - get started screen
 -privacy policy
 - terms of service
 */
