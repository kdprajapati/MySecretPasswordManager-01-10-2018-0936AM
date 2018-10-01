//
//  LoginTable+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 25/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "LoginTable+CoreDataProperties.h"

@implementation LoginTable (CoreDataProperties)

+ (NSFetchRequest<LoginTable *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LoginTable"];
}

@dynamic categoryID;
@dynamic password;
@dynamic recordID;
@dynamic username;
@dynamic webUrl;
@dynamic loginTable;

@end
