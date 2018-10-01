//
//  AppDelegate.m
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

/*
 √- secure note - section
 √- adview to add in all screens
 √- favourite and delete button events
 - plist issue - adding to all section
 - share view - preview first then share
    * make preview popup having info about category with share button
    * at press of share button dismiss preview and present share sheet to category view controller
 - photos to save per category
    - from photo library
    - from camera
 -
 */

#import "AppDelegate.h"
#import "MPassCodeViewController.h"
#import "MPasswordViewController.h"
#import "GettingStartedViewController.h"

#import "MPasswordViewController.h"
#import "MPassCodeViewController.h"

#import "ViewController.h"
#import "AppData.h"
#import "protocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    UIViewController *launchScreenVC;
    BOOL isSplashPresented;
    BOOL isAppWasInBackground;
    BOOL isLaunching;
    NSTimer *timerSecurity;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    AppData *appData = [AppData sharedAppData];
    isLaunching = false;
    

//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:81.0/255.0 green:38.0/255.0 blue:171.0/255.0 alpha:1.0]];//81, 38, 171
    
//    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
//    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTranslucent:true];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,nil]];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(funStartApp) name:@"LoadMainMenuNotification" object:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *mainVC = (ViewController *)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = nav;
    
    
    self.pascodeWindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    UIStoryboard *launchSB = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]];
    launchScreenVC = (UIViewController *)[launchSB instantiateViewControllerWithIdentifier:@"LaunchScreen"];;

    isSplashPresented = false;
    isAppWasInBackground = false;
    isLaunching = true;
    
    [self funOpenSecurity];
    
    [self funOpenSecurityAfterSomeMins];
    
    return YES;
}

-(void)funStartApp
{
    if (isLaunching == true)
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ViewController *mainVC = (ViewController *)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
        nav.navigationBar.backgroundColor = [UIColor clearColor];
//        self.window.rootViewController = nav;
        
        [UIView transitionWithView:self.window duration:0.7 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        self.window.rootViewController = nav;
        } completion:nil];
    }
    
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    isLaunching = false;
}

-(void)funOpenSecurity
{
    
    /*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *mainVC = (ViewController *)[sb instantiateViewControllerWithIdentifier:@"ViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    nav.navigationBar.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = nav;*/

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *strPasscode = [defaults valueForKey:@"APP_Password"];
    if(strPasscode == nil || strPasscode.length == 0)
    {
        //Open first Flow
//        self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        GettingStartedViewController *homeVc = [[GettingStartedViewController alloc]initWithNibName:@"GettingStartedViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
        nav.navigationBar.backgroundColor = [UIColor clearColor];
        self.window.rootViewController = nav;
        [self.window makeKeyAndVisible];
    }
    else
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger onOffStatus = [[defaults valueForKey:AppPasscodeOnOffKey] integerValue];
        if (onOffStatus == 1)
        {
            if ([AppData sharedAppData].numOfTimeWrong >= 2)
            {
                //Ask Password
                MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
                homeVc.passwordModeType = 2;
                if (isLaunching == true)
                {
                    self.window.rootViewController = homeVc;
                }
                else
                {
                    self.pascodeWindow.rootViewController = homeVc;
                }
            }
            else
            {
                //Ask Password
                MPassCodeViewController *homeVc = [[MPassCodeViewController alloc]initWithNibName:@"MPassCodeViewController" bundle:[NSBundle mainBundle]];
                homeVc.passcodeModeType = 2;
                if (isLaunching == true)
                {
                    self.window.rootViewController = homeVc;
                }
                else
                {
                    self.pascodeWindow.rootViewController = homeVc;
                }
            }
            
            if (isLaunching == true)
            {
                [self.window makeKeyWindow];
                [self.window makeKeyAndVisible];
            }
            else
            {
                [self.pascodeWindow makeKeyWindow];
                [self.pascodeWindow makeKeyAndVisible];
            }
        }
        else
        {
            //Ask Password
            MPasswordViewController *homeVc = [[MPasswordViewController alloc]initWithNibName:@"MPasswordViewController" bundle:[NSBundle mainBundle]];
            homeVc.passwordModeType = 2;
            if (isLaunching == true)
            {
                self.window.rootViewController = homeVc;
                [self.window makeKeyWindow];
                [self.window makeKeyAndVisible];
            }
            else
            {
                self.pascodeWindow.rootViewController = homeVc;
                [self.pascodeWindow makeKeyWindow];
                [self.pascodeWindow makeKeyAndVisible];
            }
        }
        
    }
}


-(void)funSuccessPassCode
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    ViewController *homeVc = (ViewController *)[sb instantiateViewControllerWithIdentifier:@"ViewController"];;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVc];
//    nav.navigationBar.backgroundColor = [UIColor clearColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

#pragma mark :- App lock timer method
-(void)funStartSecurityTimer:(NSTimeInterval)timeInterval
{
    [self funInvalidateSecurityTimer];
    timerSecurity = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(funOpenSecurity) userInfo:nil repeats:false];
    
}

-(void)funInvalidateSecurityTimer
{
    if (timerSecurity != nil)
    {
        [timerSecurity invalidate];
        timerSecurity = nil;
    }
}

-(void)funOpenSecurityAfterSomeMins
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSInteger lockTime = [userdefaults integerForKey:@"AppLockTime"];
    NSTimeInterval timeToCallSecurity = 0;
    switch (lockTime) {
        case 1:
            timeToCallSecurity = 10;
            break;
        case 2:
            timeToCallSecurity = 20;
            break;
        case 3:
            timeToCallSecurity = 30;
            break;
        default:
            
            break;
    }
    if (timeToCallSecurity > 0)
    {
        [self funStartSecurityTimer:timeToCallSecurity];
    }
    
}

#pragma mark : - Application life cycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    if (launchScreenVC != nil && isSplashPresented == false)
    {
        [self.window.rootViewController presentViewController:launchScreenVC animated:false completion:^{
            isSplashPresented = true;
        }];
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isAppWasInBackground = true;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    if (launchScreenVC != nil)
    {
        if (isAppWasInBackground == true)
        {
            [launchScreenVC dismissViewControllerAnimated:false completion:^{
                isSplashPresented = false;
                isAppWasInBackground = false;
            }];
            //
            [self funCheckTimerAndCallSecurity];
        }
    }
    else
    {
        isSplashPresented = false;
        isAppWasInBackground = false;
        [self funCheckTimerAndCallSecurity];
    }
    
}

-(void)funCheckTimerAndCallSecurity
{
    if (![timerSecurity isValid])
    {
        [self funOpenSecurity];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if (isAppWasInBackground == false)
    {
        [launchScreenVC dismissViewControllerAnimated:false completion:^{
            isSplashPresented = false;
            isAppWasInBackground = false;
        }];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
