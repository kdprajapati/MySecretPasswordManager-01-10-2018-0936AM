//
//  CoreDataStackManager.h
//  MySecretPasswordManager
//
//  Created by Dev on 23/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataStackManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(CoreDataStackManager *)sharedManager;

-(NSString *)funGenerateUDID;

-(void)funInitializeCoreData;
-(void)funAddCategoryItems:(int)categoryType object:(NSManagedObject *)categoryObject;
-(void)funAddBankAccountDetailObject:(NSManagedObject *)object;
#pragma mark - Login Items Add
-(BOOL)funAddLoginItem;

#pragma mark - Fetch objects
-(NSMutableArray *)funGetDetailObject:(int)categoryType;

#pragma mark - Get PreviewString
-(NSString *)funGetPreviewString:(NSMutableDictionary *)categoryObject categoryType:(int)categoryType;

#pragma mark - Delete objects
-(void)funDeleteDetailObject:(NSManagedObject *)toDeleteObj categoryType:(int)categoryType;
@end
