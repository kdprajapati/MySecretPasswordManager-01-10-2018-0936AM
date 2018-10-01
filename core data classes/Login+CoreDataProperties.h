//
//  Login+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Login+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Login (CoreDataProperties)

+ (NSFetchRequest<Login *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *username;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
