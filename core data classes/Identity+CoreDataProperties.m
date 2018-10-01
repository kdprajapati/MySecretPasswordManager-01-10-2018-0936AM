//
//  Identity+CoreDataProperties.m
//  MySecretPasswordManager
//
//  Created by Dev on 13/02/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "Identity+CoreDataProperties.h"

@implementation Identity (CoreDataProperties)

+ (NSFetchRequest<Identity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Identity"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic sex;
@dynamic birthDate;
@dynamic occupation;
@dynamic departmentName;
@dynamic jobTitle;
@dynamic street;
@dynamic cityName;
@dynamic zip;
@dynamic state;
@dynamic country;
@dynamic phoneNumber;
@dynamic webSite;
@dynamic email;
@dynamic note;
@dynamic nickName;
@dynamic recordID;
@dynamic title;

@end
