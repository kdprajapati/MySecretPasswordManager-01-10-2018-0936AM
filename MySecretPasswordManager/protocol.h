//
//  protocol.h
//  MySecretPasswordManager
//
//  Created by Dev on 22/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#ifndef global_h
#define global_h


/*static NSString *AppPlistName = @"AppPlist";

static NSURL *AppPlistPath = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"AppPlist.plist"];*/

#define AppAllDataPlistName @"AllDataPlist"

#define CategoryBankAccount  @"CategoryBankAccount"
#define CategoryCreditCard  @"CategoryCreditCard"
#define CategoryLoginPassword  @"CategoryLoginPassword"
#define CategoryIdentity  @"CategoryIdentity"
#define CategorySecureNote  @"CategorySecureNote"
#define CategoryDrivingLicence  @"CategoryDrivingLicence"
#define CategoryMemberShip  @"CategoryMemberShip"
#define CategoryPassport  @"CategoryPassport"


#define AppId @"1441211373"
#define InAppId @"PasswordManager_RemoveAllAds"
#define ADMob_AppID @"ca-app-pub-9071153832703835~5612056277"
#define ADMob_BannerID @"ca-app-pub-9071153832703835/2578698829"
#define ADMob_FullScreenID @"ca-app-pub-9071153832703835/2195555440"
#define AdMobFullScreenRepeatCount 4

typedef enum : int {
    KCategoryBankAccount=1,
    KCategoryCreditCard=2,
    KCategoryLoginPassword=3,
    KCategoryIdentity=4,
    KCategorySecureNote=5,
    KCategoryDrivingLicence=6,
    KCategoryMemberShip=7,
    KCategoryPassport=8
} PasswordCategory;

//int fontMultiplier;
#endif /* global_h */
