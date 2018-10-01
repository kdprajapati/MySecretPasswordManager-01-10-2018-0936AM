//
//  Category+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 03/01/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Category+CoreDataProperties.h"

@implementation Category (CoreDataProperties)

+ (NSFetchRequest<Category *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Category"];
}

@dynamic image;
@dynamic name;
@dynamic recordID;
@dynamic category;
@dynamic bankAccount;

@end
