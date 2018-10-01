//
//  IdentityObject.h
//  MySecretPasswordManager
//
//  Created by Dev on 14/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IdentityObject : NSObject

@property (nullable, nonatomic) NSDate *birthDate;
@property (nullable, nonatomic) NSString *cityName;
@property (nullable, nonatomic) NSString *country;
@property (nullable, nonatomic) NSString *departmentName;
@property (nullable, nonatomic) NSString *email;
@property (nullable, nonatomic) NSString *firstName;
@property (nullable, nonatomic) NSString *jobTitle;
@property (nullable, nonatomic) NSString *lastName;
@property (nullable, nonatomic) NSString *nickName;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *occupation;
@property (nullable, nonatomic) NSString *phoneNumber;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *sex;
@property (nullable, nonatomic) NSString *address;
@property (nullable, nonatomic) NSString *street;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSString *webSite;
@property (nullable, nonatomic) NSString *zip;

@end
