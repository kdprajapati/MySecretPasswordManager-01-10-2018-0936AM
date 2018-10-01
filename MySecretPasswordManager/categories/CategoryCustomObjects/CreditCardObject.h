//
//  CreditCardObject.h
//  MySecretPasswordManager
//
//  Created by Dev on 17/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCardObject : NSObject

@property (nullable, nonatomic) NSString *bankName;
@property (nullable, nonatomic) NSString *cardHolderName;
@property (nullable, nonatomic) NSString *cardNumber;
@property (nullable, nonatomic) NSString *cardPIN;
@property (nullable, nonatomic) NSString *cardType;
@property (nullable, nonatomic) NSDate *expiryDate;
@property (nullable, nonatomic) NSString *localPhone;
@property (nullable, nonatomic) NSString *note;
@property (nullable, nonatomic) NSString *recordID;
@property (nullable, nonatomic) NSString *tollFreePhone;
@property (nullable, nonatomic) NSDate *validFrom;
@property (nullable, nonatomic) NSString *website;
@property (nullable, nonatomic) NSString *title;

@end
