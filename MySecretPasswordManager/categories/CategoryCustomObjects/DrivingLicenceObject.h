//
//  DrivingLicenceObject.h
//  MySecretPasswordManager
//
//  Created by Nilesh on 16/09/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrivingLicenceObject : NSObject

@property (nullable, nonatomic) NSString *fullName;
@property (nullable, nonatomic) NSString *address;
@property (nullable, nonatomic) NSString *height;
@property (nullable, nonatomic) NSString *licenceNumber;
@property (nullable, nonatomic) NSString *classType;
@property (nullable, nonatomic) NSString *documentNumber;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *title;
@property (nullable, nonatomic) NSDate *dateOfBirth;
@property (nullable, nonatomic) NSDate *issueDate;
@property (nullable, nonatomic) NSDate *expiryDate;

@end
