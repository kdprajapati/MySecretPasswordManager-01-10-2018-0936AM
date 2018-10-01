//
//  MembershipObject.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 16/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MembershipObject : NSObject

@property (nullable, nonatomic) NSString *groupName;
@property (nullable, nonatomic) NSString *telephone;
@property (nullable, nonatomic) NSString *memberName;
@property (nullable, nonatomic) NSString *memberID;
@property (nullable, nonatomic) NSString *memberPassword;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *website;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSDate *memerSinceDate;
@property (nullable, nonatomic) NSDate *expiryDate;

@end
