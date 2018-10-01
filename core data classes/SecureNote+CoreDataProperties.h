//
//  SecureNote+CoreDataProperties.h
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SecureNote+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SecureNote (CoreDataProperties)

+ (NSFetchRequest<SecureNote *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *recordID;
@property (nullable, nonatomic, copy) NSString *note;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
