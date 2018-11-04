//
//  HelloWorldLayer.h
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//

#import"AppDelegate.h"
#import "protocol.h"
#import "AdMob/AdMob.h"
@interface AppData : NSObject
{
    AppDelegate *appdelegate;
}

#define AppPasswordKey @"APP_Password"
#define AppPasscodeOnOffKey @"PasscodeOnOffStatus"
#define AppPasscodeKey @"APP_Passcode"

@property(assign,nonatomic)int appLaunchCount,admobFullScreenDislplayCount,notificationQuatesIndex;
@property (assign, nonatomic)BOOL isChalisaPlaying;
@property (strong, nonatomic,nullable)AdMob *adMob;
@property (assign, nonatomic)BOOL isRemoveAdPurchased,isLaunchFromNotiFication;
@property (strong, nonatomic,nullable) UIActivityIndicatorView   *activityLoaderView;
@property (strong, nonatomic,nullable) UIView   *viewActivityLoaderBG;
@property(retain,nullable)NSDictionary *dictChalisaURL,*dicQuates,*dicNotificationInfo;

+(nullable AppData *)sharedAppData;
-(void)showAlertWithMessage:(nullable NSString *)msg andTitle:(nullable NSString *)strTitle;

-(void)hideActivityLoderAfterSomeTime;

-(BOOL)showFullScreenAdonComtroller:(nullable UIViewController*)controller;
-(void)showAlertForRateUsOnViewController:(nullable UIViewController*) viewController;
-(void)rateUs;
-(void)alertForNotificationOnViewController:(UIViewController*) viewController;

@property (strong, nonatomic) NSMutableDictionary   *dictAllCategoryData;
@property (strong, nonatomic) NSString   *userAppPassword;
@property (assign) int numOfTimeWrong;

-(void)loadActivityView;
-(void)showActivityLoaderInView:(UIView *)view;
-(void)hideActivityLoader;
-(BOOL)isNetAvailable;

-(void)funCreateCategoryPhotosForRecordId:(int)categoryType recordID:(NSString *)recordID;

-(void)funSaveCategoryData:(int)categoryType objectKey:(NSString *)objectKey dictionary:(NSMutableDictionary *)categoryDict;
-(NSString *)funGetCategoryRecordIDDirectory:(int)categoryType recordID:(NSString *)recordID;
-(NSArray *)getListOfDirectoryOfCategoryType:(int)categroyType recordID:(NSString *)recordID;

#pragma mark - Fetch objects
-(NSMutableArray *)funGetDetailObject:(int)categoryType isFavArrayToReturn:(BOOL)isFavArrayToReturn;
-(NSMutableArray *)funGetDetailAllFavouriteObjects:(BOOL)isFavArrayToReturn;

#pragma mark - Delete objects
-(void)funDeleteCategoryData:(int)categoryType recordIDToDelete:(NSString *)recordIDToDelete;

#pragma mark - Encryption/Decryption methods
- (NSString *)encrypt:(NSString *)string withKey:(NSString *)Key;
- (NSString *)decrypt:(NSString *)string withKey:(NSString *)Key;

#pragma mark - Decrypt/Encrypt process for reset password methods
-(void)funDecryptEncryptDataForPasswordReset:(NSString *)newPasscode;

#pragma mark - Theme Helpers
-(UIColor *)funGetThemeColor;

-(UIImage *)funImageFromRGB:(UIColor *)colorRGB;


-(void)showAddOnTopOfToolBar;
-(void)showAddAtBottom;

#pragma mark - UDID
-(NSString *)funGenerateUDID;

-(void)sharePopUpWithTextMessage:(nullable NSString *)strMessage image:(nullable UIImage *)image andURL:(nullable NSString *)strURL onViewConrroller:(nullable UIViewController*) viewController;
@end
