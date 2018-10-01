//
//  Category+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 03/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Category+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, retain) NSSet<LoginTable *> *category;
@property (nullable, nonatomic, retain) NSSet<BankAccount *> *bankAccount;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(LoginTable *)value;
- (void)removeCategoryObject:(LoginTable *)value;
- (void)addCategory:(NSSet<LoginTable *> *)values;
- (void)removeCategory:(NSSet<LoginTable *> *)values;

- (void)addBankAccountObject:(BankAccount *)value;
- (void)removeBankAccountObject:(BankAccount *)value;
- (void)addBankAccount:(NSSet<BankAccount *> *)values;
- (void)removeBankAccount:(NSSet<BankAccount *> *)values;

@end

NS_ASSUME_NONNULL_END
