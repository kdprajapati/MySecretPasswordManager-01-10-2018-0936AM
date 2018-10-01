//
//  Login+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Login+CoreDataProperties.h"

@implementation Login (CoreDataProperties)

+ (NSFetchRequest<Login *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Login"];
}

@dynamic note;
@dynamic title;
@dynamic recordID;
@dynamic username;
@dynamic password;
@dynamic url;

@end
