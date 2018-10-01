//
//  BankAccount+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 04/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "BankAccount+CoreDataProperties.h"

@implementation BankAccount (CoreDataProperties)

+ (NSFetchRequest<BankAccount *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BankAccount"];
}

@dynamic accountHolderName;
@dynamic accountNumber;
@dynamic accountPIN;
@dynamic accountType;
@dynamic bankName;
@dynamic branchAddress;
@dynamic branchCode;
@dynamic branchName;
@dynamic branchPhone;
@dynamic note;
@dynamic recordID;
@dynamic title;
@dynamic relationship;

@end
