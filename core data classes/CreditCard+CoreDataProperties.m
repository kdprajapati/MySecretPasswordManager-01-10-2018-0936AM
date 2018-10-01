//
//  CreditCard+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 05/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "CreditCard+CoreDataProperties.h"

@implementation CreditCard (CoreDataProperties)

+ (NSFetchRequest<CreditCard *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CreditCard"];
}

@dynamic bankName;
@dynamic cardHolderName;
@dynamic cardNumber;
@dynamic cardPIN;
@dynamic cardType;
@dynamic expiryDate;
@dynamic localPhone;
@dynamic note;
@dynamic recordID;
@dynamic tollFreePhone;
@dynamic validFrom;
@dynamic website;
@dynamic title;

@end
