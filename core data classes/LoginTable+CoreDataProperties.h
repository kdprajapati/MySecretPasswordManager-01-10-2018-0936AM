//
//  LoginTable+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 25/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "LoginTable+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LoginTable (CoreDataProperties)

+ (NSFetchRequest<LoginTable *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *categoryID;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *webUrl;
@property (nullable, nonatomic, retain) Category *loginTable;

@end

NS_ASSUME_NONNULL_END
