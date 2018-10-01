//
//  SecureNote+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SecureNote+CoreDataProperties.h"

@implementation SecureNote (CoreDataProperties)

+ (NSFetchRequest<SecureNote *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SecureNote"];
}

@dynamic recordID;
@dynamic note;
@dynamic title;

@end
