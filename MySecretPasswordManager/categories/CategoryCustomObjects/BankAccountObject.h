//
//  BankAccountObject.h
//  MySecretPasswordManager
//
//  Created by Dev on 25/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankAccountObject : NSObject

@property (nullable, nonatomic) NSString *accountHolderName;
@property (nullable, nonatomic) NSString *accountNumber;
@property (nullable, nonatomic) NSString *accountPIN;
@property (nullable, nonatomic) NSString *accountType;
@property (nullable, nonatomic) NSString *bankName;
@property (nullable, nonatomic) NSString *branchAddress;
@property (nullable, nonatomic) NSString *branchCode;
@property (nullable, nonatomic) NSString *branchName;
@property (nullable, nonatomic) NSString *branchPhone;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *title;

@end
