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
