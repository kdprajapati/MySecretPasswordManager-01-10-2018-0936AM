//
//  PassportObject.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 16/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassportObject : NSObject

@property (nullable, nonatomic) NSString *typeOfPassword;
@property (nullable, nonatomic) NSString *issuingCountry;
@property (nullable, nonatomic) NSString *fullName;
@property (nullable, nonatomic) NSString *nationality;
@property (nullable, nonatomic) NSString *issuingAuthority;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSDate *dateOfBirth;
@property (nullable, nonatomic) NSDate *issueDate;
@property (nullable, nonatomic) NSDate *expiryDate;

@end
