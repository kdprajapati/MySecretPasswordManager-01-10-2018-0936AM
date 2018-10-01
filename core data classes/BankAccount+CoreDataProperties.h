//
//  BankAccount+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 04/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "BankAccount+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankAccount (CoreDataProperties)

+ (NSFetchRequest<BankAccount *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountHolderName;
@property (nullable, nonatomic, copy) NSString *accountNumber;
@property (nullable, nonatomic, copy) NSString *accountPIN;
@property (nullable, nonatomic, copy) NSString *accountType;
@property (nullable, nonatomic, copy) NSString *bankName;
@property (nullable, nonatomic, copy) NSString *branchAddress;
@property (nullable, nonatomic, copy) NSString *branchCode;
@property (nullable, nonatomic, copy) NSString *branchName;
@property (nullable, nonatomic, copy) NSString *branchPhone;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) Category *relationship;

@end

NS_ASSUME_NONNULL_END
