//
//  HelloWorldLayer.h
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//

#import"AppDelegate.h"
#import "protocol.h"
@interface AppData : NSObject
{
    AppDelegate *appdelegate;
}

#define AppPasswordKey @"APP_Password"
#define AppPasscodeOnOffKey @"PasscodeOnOffStatus"
#define AppPasscodeKey @"APP_Passcode"


@property (strong, nonatomic) UIActivityIndicatorView   *activityLoaderView;
@property (strong, nonatomic) UIView   *viewActivityLoaderBG;
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

-(void)showAlertWithMessage:(NSString *)msg andTitle:(NSString *)strTitle;

+(AppData *)sharedAppData;

#pragma mark - Encryption/Decryption methods
- (NSString *)encrypt:(NSString *)string withKey:(NSString *)Key;
- (NSString *)decrypt:(NSString *)string withKey:(NSString *)Key;

#pragma mark - Decrypt/Encrypt process for reset password methods
-(void)funDecryptEncryptDataForPasswordReset:(NSString *)newPasscode;

#pragma mark - Theme Helpers
-(UIColor *)funGetThemeColor;

-(UIImage *)funImageFromRGB:(UIColor *)colorRGB;
@end
