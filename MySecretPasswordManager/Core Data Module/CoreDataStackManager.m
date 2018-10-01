//
//  CoreDataStackManager.m
//  MySecretPasswordManager
//
//  Created by Dev on 23/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import "CoreDataStackManager.h"
#import "LoginTable+CoreDataProperties.h"
#import "BankAccount+CoreDataProperties.h"

#import "CreditCardObject.h"
#import "BankAccountObject.h"

@implementation CoreDataStackManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static CoreDataStackManager *sharedManager = nil;


+(CoreDataStackManager *)sharedManager
{
    @synchronized([CoreDataStackManager class]) {
        if (!sharedManager)
            sharedManager = [[self alloc] init];
        return sharedManager;
    }
    return nil;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

-(void)funInitializeCoreData
{
    [self managedObjectContext];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    // Add the notification handler
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(tempContextSaved:)
//                                                 name:NSManagedObjectContextDidSaveNotification
//                                               object:_managedObjectContext];
    
    return _managedObjectContext;
}

- (void)tempContextSaved:(NSNotification *)notification {
    /* Merge the changes into the original managed object context */
    [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MySecretPasswordManager.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}} error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - UDID
-(NSString *)funGenerateUDID
{
    NSUUID  *UUID = [NSUUID UUID];
    NSString* stringUUID = [UUID UUIDString];
    return stringUUID;
}


#pragma mark - Add Category Items
-(void)funAddCategoryItems:(int)categoryType object:(NSManagedObject *)categoryObject
{
    switch (categoryType) {
        case 1:
            [self funAddBankAccountDetailObject:categoryObject];
            break;
            
        default:
            break;
    }
}

#pragma mark - Fetch objects
-(NSMutableArray *)funGetDetailObject:(int)categoryType
{
    NSString *tableName;
    switch (categoryType) {
        case 1://Bank Account
            tableName = @"BankAccount";
            break;
        case 2://Credit card
            tableName = @"CreditCard";
            break;
            
        default:
            break;
    }
    
    if(tableName == nil)
    {
        return nil;
    }
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    
    NSMutableArray *arrayObjects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];//nsmanagedobject array
    
    NSMutableArray *objectArray;//contains category custom objects
    if (arrayObjects.count == 0)
    {
        return nil;
    }
    else
    {
        switch (categoryType) {
            case 1://Bank Account
                objectArray = [self funGetDetailObjectBankAccount:arrayObjects];
                break;
            case 2://Credit card
                objectArray = [self funGetDetailObjectCreditCard:arrayObjects];
                break;
            default:
                break;
        }
    }
    
    return objectArray;
}


/**
 funGetDetailObjectCreditCard - to get credit card custom object
 
 @param objectArray NSManagedObject array fetched from persistence store
 @return credit card custom object array
 */
-(NSMutableArray *)funGetDetailObjectBankAccount:(NSMutableArray *)objectArray
{
    if (objectArray.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (id object in objectArray)
    {
        if ([object isKindOfClass:[NSManagedObject class]])
        {
            BankAccountObject *creditCard = [[BankAccountObject alloc] init];
            NSManagedObject *obj = (NSManagedObject *)object;
            NSLog(@"title - %@",[obj valueForKey:@"title"]);
            creditCard.recordID = [obj valueForKey:@"recordID"];
            creditCard.title = [obj valueForKey:@"title"];
            creditCard.bankName = [obj valueForKey:@"bankName"];
            creditCard.accountNumber = [obj valueForKey:@"accountNumber"];
            creditCard.accountHolderName = [obj valueForKey:@"accountHolderName"];
            creditCard.accountType = [obj valueForKey:@"accountType"];
            creditCard.accountPIN = [obj valueForKey:@"accountPIN"];
            creditCard.branchCode = [obj valueForKey:@"branchCode"];
            creditCard.branchPhone = [obj valueForKey:@"branchPhone"];
            creditCard.branchAddress = [obj valueForKey:@"branchAddress"];
            creditCard.note = [obj valueForKey:@"note"];
            [returnArray addObject:creditCard];
            
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectCreditCard - to get credit card custom object

 @param objectArray NSManagedObject array fetched from persistence store
 @return credit card custom object array
 */
-(NSMutableArray *)funGetDetailObjectCreditCard:(NSMutableArray *)objectArray
{
    if (objectArray.count == 0)
    {
        return nil;
    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    for (id object in objectArray)
    {
        if ([object isKindOfClass:[NSManagedObject class]])
        {
            CreditCardObject *creditCard = [[CreditCardObject alloc] init];
            NSManagedObject *obj = (NSManagedObject *)object;
            creditCard.recordID = [obj valueForKey:@"recordID"];
            creditCard.title = [obj valueForKey:@"title"];
            creditCard.bankName = [obj valueForKey:@"bankName"];
            creditCard.cardHolderName = [obj valueForKey:@"cardHolderName"];
            creditCard.cardNumber = [obj valueForKey:@"cardNumber"];
            creditCard.cardPIN = [obj valueForKey:@"cardPIN"];
            creditCard.cardType = [obj valueForKey:@"cardType"];
            creditCard.expiryDate = [obj valueForKey:@"expiryDate"];
            creditCard.localPhone = [obj valueForKey:@"localPhone"];
            creditCard.recordID = [obj valueForKey:@"recordID"];
            creditCard.tollFreePhone = [obj valueForKey:@"tollFreePhone"];
            creditCard.validFrom = [obj valueForKey:@"validFrom"];
            creditCard.website = [obj valueForKey:@"title"];
            creditCard.note = [obj valueForKey:@"note"];
            [returnArray addObject:creditCard];
        }
    }
    
    return returnArray;
}

#pragma mark - Delete objects
-(void)funDeleteDetailObject:(NSManagedObject *)toDeleteObj categoryType:(int)categoryType
{
    NSString *tableName;
    switch (categoryType) {
        case 1://Bank Account
            tableName = @"BankAccount";
            break;
        case 2://Credit card
            tableName = @"CreditCard";
            break;
            
        default:
            break;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:tableName];
    req.predicate= [NSPredicate predicateWithFormat:@"recordID == %@",[toDeleteObj valueForKey:@"recordID"]];
    NSArray *objectArray = [context executeFetchRequest:req error:nil];
    
    if (objectArray != nil && objectArray.count > 0)
    {
        NSManagedObject *object = [objectArray objectAtIndex:0];
        [context deleteObject:object];
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Failed to delete - error: %@", [error localizedDescription]);
        }
    }
}

-(void)funAddBankAccountDetailObject:(NSManagedObject *)object
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

#pragma mark - Get PreviewString
-(NSString *)funGetPreviewString:(NSMutableDictionary *)categoryObject categoryType:(int)categoryType
{
    NSString *previewString;
    switch (categoryType) {
        case 1://Bank Account
            previewString = [self funGetBankACPreviewString:categoryObject];
            break;
        case 2://Credit card
            previewString = [self funGetCreditCardPreviewString:categoryObject];
            break;
        case 3://Login
            previewString = [self funGetLoginPreviewString:categoryObject];
            break;
        case 4://Identity
            previewString = [self funGetIdentityPreviewString:categoryObject];
            break;
        case 5://Secure Note
            previewString = [self funGetSecureNotePreviewString:categoryObject];
            break;
        default:
            break;
    }
    return previewString;
}

-(NSString *)funGetBankACPreviewString:(NSMutableDictionary *)categoryObject
{
    NSString *previewString;
    NSString *bankName = [categoryObject valueForKey:@"bankName"];
    NSString *accountNumber = [categoryObject valueForKey:@"accountNumber"];
    NSString *accountHolderName = [categoryObject valueForKey:@"accountHolderName"];
    NSString *accountType = [categoryObject valueForKey:@"accountType"];
    NSString *branchCode = [categoryObject valueForKey:@"branchCode"];
    NSString *branchPhone = [categoryObject valueForKey:@"branchPhone"];
    NSString *branchAddress = [categoryObject valueForKey:@"branchAddress"];
    
    previewString = @"-:My Bank Detail:-\n\n";
    
    if (bankName != nil && bankName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Bank Name:- %@\n",bankName]];
    }
    if (accountNumber != nil && accountNumber.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Account Number:- %@\n",accountNumber]];
    }
    if (accountHolderName != nil && accountHolderName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Account Holder Name:- %@\n",accountHolderName]];
    }
    if (accountType != nil && accountType.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Account Type:- %@\n",accountType]];
    }
    if (branchCode != nil && branchCode.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Branch Code:- %@\n",branchCode]];
    }
    if (branchPhone != nil && branchPhone.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Branch Phone:- %@\n",branchPhone]];
    }
    if (branchAddress != nil && branchAddress.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Branch Address:- %@",branchAddress]];
    }
    
    return previewString;
}

-(NSString *)funGetCreditCardPreviewString:(NSMutableDictionary *)categoryObject
{
    NSString *previewString;
    NSString *cardHolderName = [categoryObject valueForKey:@"cardHolderName"];
    NSString *cardNumber = [categoryObject valueForKey:@"cardNumber"];
    NSString *cardType = [categoryObject valueForKey:@"cardType"];
    NSString *expiryDate = [categoryObject valueForKey:@"expiryDate"];
    NSString *localPhone = [categoryObject valueForKey:@"localPhone"];
    NSString *tollFreePhone = [categoryObject valueForKey:@"tollFreePhone"];
    NSString *validFrom = [categoryObject valueForKey:@"validFrom"];
    NSString *website = [categoryObject valueForKey:@"website"];
    
    previewString = @"-:My Credit Card Detail:-\n\n";
    
    if (cardHolderName != nil && cardHolderName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Card Holder Name:- %@\n",cardHolderName]];
    }
    if (cardNumber != nil && cardNumber.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Card Number:- %@\n",cardNumber]];
    }
    if (cardType != nil && cardType.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Card Type:- %@\n",cardType]];
    }
    if (expiryDate != nil)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Expiry Date:- %@\n",expiryDate]];
    }
    if (localPhone != nil && localPhone.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Local Phone:- %@\n",localPhone]];
    }
    if (tollFreePhone != nil && tollFreePhone.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Toll Free:- %@\n",tollFreePhone]];
    }
    if (validFrom != nil)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Valid From:- %@\n",validFrom]];
    }
    if (website != nil && website.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Website:- %@",website]];
    }
    
    return previewString;
}

-(NSString *)funGetLoginPreviewString:(NSMutableDictionary *)categoryObject
{
    NSString *previewString;
    NSString *loginName = [categoryObject valueForKey:@"title"];
    NSString *url = [categoryObject valueForKey:@"url"];
    NSString *username = [categoryObject valueForKey:@"username"];
    NSString *note = [categoryObject valueForKey:@"note"];
    
    previewString = @"-:My Login Details:-\n\n";
    
    if (loginName != nil && loginName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Login Name:- %@\n",loginName]];
    }
    
    if (url != nil && url.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Web URL:- %@\n",url]];
    }
    
    if (username != nil && username.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"UserName:- %@\n",username]];
    }
   
    if (note != nil && note.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Note:- %@\n",note]];
    }
    
    return previewString;
}

-(NSString *)funGetIdentityPreviewString:(NSMutableDictionary *)categoryObject
{
    
    NSString *previewString;
    NSString *firstName = [categoryObject valueForKey:@"firstName"];
    NSString *lastName = [categoryObject valueForKey:@"lastName"];
    NSString *email = [categoryObject valueForKey:@"email"];
    NSString *occupation = [categoryObject valueForKey:@"occupation"];
    NSString *phoneNumber = [categoryObject valueForKey:@"phoneNumber"];
    NSString *webSite = [categoryObject valueForKey:@"webSite"];
    NSString *address = [categoryObject valueForKey:@"address"];
    NSString *country = [categoryObject valueForKey:@"country"];
    NSString *birthDate = [categoryObject valueForKey:@"birthDate"];
    
    previewString = @"-:My Identity Detail:-\n\n";
    
    if (firstName != nil && firstName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"First Name:- %@\n",firstName]];
    }
    if (lastName != nil && lastName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Last Name:- %@\n",lastName]];
    }
    if (email != nil && email.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Email:- %@\n",email]];
    }
    
    if (occupation != nil && occupation.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Occupation:- %@\n",occupation]];
    }
    if (phoneNumber != nil && phoneNumber.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Phone Number:- %@\n",phoneNumber]];
    }
    
    if (webSite != nil && webSite.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Website:- %@",webSite]];
    }
    
    if (address != nil && address.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Address:- %@",address]];
    }
    
    if (country != nil && country.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Country:- %@",country]];
    }
    
    if (birthDate != nil)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Birth Date:- %@\n",birthDate]];
    }
    return previewString;
}

-(NSString *)funGetSecureNotePreviewString:(NSMutableDictionary *)categoryObject
{
    
    NSString *previewString;
    NSString *noteName = [categoryObject valueForKey:@"title"];
    NSString *note = [categoryObject valueForKey:@"note"];
    
    previewString = @"-:My Note:-\n\n";
    
    if (noteName != nil && noteName.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Note Name:- %@\n",noteName]];
    }
    
    if (note != nil && note.length != 0)
    {
        previewString = [previewString stringByAppendingString:[NSString stringWithFormat:@"Note:- %@\n",note]];
    }
    
    return previewString;
}

#pragma mark - Login Items Add
-(void)funAddLoginItem
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    [context performBlockAndWait:^{
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginTable" inManagedObjectContext:context];
        
        NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        
        [object setValue:@"record1" forKey:@"recordID"];
        [object setValue:@"user1" forKey:@"username"];
        [object setValue:@"Pass1" forKey:@"password"];
    }];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }
}

@end
