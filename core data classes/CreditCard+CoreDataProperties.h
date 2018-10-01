//
//  CreditCard+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 05/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "CreditCard+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CreditCard (CoreDataProperties)

+ (NSFetchRequest<CreditCard *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bankName;
@property (nullable, nonatomic, copy) NSString *cardHolderName;
@property (nullable, nonatomic, copy) NSString *cardNumber;
@property (nullable, nonatomic, copy) NSString *cardPIN;
@property (nullable, nonatomic, copy) NSString *cardType;
@property (nullable, nonatomic, copy) NSDate *expiryDate;
@property (nullable, nonatomic, copy) NSString *localPhone;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *tollFreePhone;
@property (nullable, nonatomic, copy) NSDate *validFrom;
@property (nullable, nonatomic, copy) NSString *website;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
