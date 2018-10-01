//
//  Identity+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Identity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Identity (CoreDataProperties)

+ (NSFetchRequest<Identity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *sex;
@property (nullable, nonatomic, copy) NSDate *birthDate;
@property (nullable, nonatomic, copy) NSString *occupation;
@property (nullable, nonatomic, copy) NSString *departmentName;
@property (nullable, nonatomic, copy) NSString *jobTitle;
@property (nullable, nonatomic, copy) NSString *street;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nullable, nonatomic, copy) NSString *zip;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSString *webSite;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *nickName;
@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
