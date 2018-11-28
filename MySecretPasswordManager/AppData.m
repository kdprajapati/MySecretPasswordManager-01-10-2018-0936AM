//
//  HelloWorldLayer.m
//  MatchColor
//
//  Created by Ganesh on 17/04/15.
//  Copyright Ganesh 2015. All rights reserved.
//

/*
 change to made in method if any category added and to check
-(id) init
 -(void)funCreateCategoryPhotosDirectories:(NSString *)dirPath
 -(void)funCreateCategoryPhotosForRecordId:(int)categoryType recordID:(NSString *)recordID
 -(void)funCreateAppDataPlist
 -(void)funSaveCategoryData:(int)categoryType objectKey:(NSString *)objectKey dictionary:(NSMutableDictionary *)categoryDict
 -(NSMutableArray *)funGetDetailObject:(int)categoryType isFavArrayToReturn:(BOOL)isFavArrayToReturn
 -(NSMutableArray *)funGetDetailAllFavouriteObjects:(BOOL)isFavArrayToReturn
 -(NSMutableArray *)funGetDetailObjectBankAccount:(BOOL)isFavArrayToReturn //per category different method
 -(void)funDeleteCategoryData:(int)categoryType recordIDToDelete:(NSString *)recordIDToDelete

 
 */

#import "AppData.h"
#import "Reachability.h"
#import "protocol.h"
#import "FBEncryptorAES.h"
#import "InAppPurchase.h"
@implementation AppData
{
    NSArray *arrayCategoryDirFolderName;
    InAppPurchase *inAppPurchase;
}
@synthesize userAppPassword;

static AppData *_sharedAppData = nil;
+(AppData *)sharedAppData
{
    if(!_sharedAppData)
    {
        if( [ [AppData class] isEqual:[self class]] )
            _sharedAppData = [[AppData alloc] init];
        else
            _sharedAppData = [[self alloc] init];
    }
    return _sharedAppData;
}
+(id)alloc
{
    NSAssert(_sharedAppData == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

-(id) init
{
    if((self=[super init]))
    {
        appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        self.isRemoveAdPurchased=[[userdefaults objectForKey:@"isRemoveAdPurchased"] boolValue];
        
        self.appLaunchCount=[[userdefaults objectForKey:@"AppLaunchCount"] intValue];
        self.appLaunchCount++;
        [userdefaults setObject:[NSNumber numberWithInt:self.appLaunchCount] forKey:@"AppLaunchCount"];
        [userdefaults synchronize];
        
        if(!self.isRemoveAdPurchased)
        {
            self.adMob=[AdMob sharedAdMob];
        }
        [InAppPurchase sharedInAppPurchase];
        
        arrayCategoryDirFolderName = [[NSArray alloc] initWithObjects:@"BankAccountPhotos",@"CreditCardPhotos",@"LoginPhotos",@"IdentityPhotos",@"SecureNotesPhotos",@"DrivingLicence",@"Membership",@"Passport", nil];
        
        [self funCreateAppDataPlist];
        [self funCreatePhotoSaveDirectory];
        [self loadActivityView];
    }
    return self;
 }

-(void)funCreatePhotoSaveDirectory
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"Category_Photos"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
    {
        NSString *imagesPath = [libraryPath stringByAppendingPathComponent:@"Category_Photos"];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:&error];
        if(!error)
        {
            [self funCreateCategoryPhotosDirectories:imagesPath];
        }
    }
}

-(NSString *)funGetCategoryMainDirectory
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"Category_Photos"];
    return dirPath;
}

-(void)funCreateCategoryPhotosDirectories:(NSString *)dirPath
{
    
    for (int i=0; i<8 ; i++)
    {
        NSString *photoPath = [dirPath stringByAppendingPathComponent:[arrayCategoryDirFolderName objectAtIndex:i]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:photoPath])
        {
            NSError *error;
            [[NSFileManager defaultManager] createDirectoryAtPath:photoPath withIntermediateDirectories:NO attributes:nil error:&error];
            NSLog(@"error creating dir - %@",error);
        }
    }
}

-(NSString *)funGetCategoryRecordIDDirectory:(int)categoryType recordID:(NSString *)recordID
{
    NSString *dirPath = [self funGetCategoryMainDirectory];
    NSString *photoPath = [dirPath stringByAppendingPathComponent:[arrayCategoryDirFolderName objectAtIndex:categoryType-1]];
    
    NSString *photoPath1 = [photoPath stringByAppendingPathComponent:recordID];
    return photoPath1;
}

-(NSArray *)getListOfDirectoryOfCategoryType:(int)categroyType recordID:(NSString *)recordID
{
    if(recordID!=nil)
    {
        NSFileManager *filemgr = [NSFileManager defaultManager];
        NSArray *filelist;
        NSError *error = nil;
        
        NSString *strPath = [self funGetCategoryRecordIDDirectory:categroyType recordID:recordID];
        
        filelist = [filemgr contentsOfDirectoryAtPath:strPath error: &error];
        NSLog(@"Filelist path is %@ - %@",filelist,error);
        //NSLog(@"Album name Path Is : %@",strPath);
        
        return filelist;
    }
    return nil;
}

-(void)funCreateCategoryPhotosForRecordId:(int)categoryType recordID:(NSString *)recordID
{
    NSString *photoPath1 = [self funGetCategoryRecordIDDirectory:categoryType recordID:recordID];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:photoPath1])
    {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:photoPath1 withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
}

-(void)funCreateAppDataPlist
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
  
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"SecretPassword"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath])
    {
        NSString *path = [self createDirectoryWithPath:libraryPath andName:@"SecretPassword"];
        if (path == nil)
        {
            
        }
        else
        {
            dirPath = path;
        }
    }
    
    NSString *plistPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",AppAllDataPlistName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        self.dictAllCategoryData = [[NSMutableDictionary alloc] init];
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryBankAccount];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryCreditCard];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryLoginPassword];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryIdentity];
        [self.dictAllCategoryData setObject:tempDict forKey:CategorySecureNote];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryDrivingLicence];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryMemberShip];
        [self.dictAllCategoryData setObject:tempDict forKey:CategoryPassport];
        [self.dictAllCategoryData writeToFile:plistPath atomically:YES];

    }
    else
    {
        self.dictAllCategoryData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
}

-(NSString*)createDirectoryWithPath:(NSString*)strPath andName:(NSString*)strName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imagesPath = [strPath stringByAppendingPathComponent:strName];
    if (![fileManager fileExistsAtPath:imagesPath])
    {
        NSError *error;
        [fileManager createDirectoryAtPath:imagesPath withIntermediateDirectories:NO attributes:nil error:&error];
        if(!error)
        {
            NSURL *imageURL = [NSURL fileURLWithPath:imagesPath isDirectory:YES];
            [imageURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:NULL];
            return imagesPath;
        }
    }
    return nil;
}

#pragma mark - UDID
-(NSString *)funGenerateUDID
{
    NSUUID  *UUID = [NSUUID UUID];
    NSString* stringUUID = [UUID UUIDString];
    return stringUUID;
}

-(void)sharePopUpWithTextMessage:(NSString *)strMessage image:(UIImage *)image andURL:(NSString *)strURL onViewConrroller:(UIViewController*) viewController
{
    //NSString *text = @"Chalisa All in One - 23 Indian Gods and Goddesses Chalisa with Aduio and Text";
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",AppId]];
    NSURL *url = [NSURL URLWithString:strURL];
    
    //UIImage *image = [UIImage  imageNamed:@""];
    UIActivityViewController *controller;
    if(image!=nil)
    {
        controller=[[UIActivityViewController alloc]
                    initWithActivityItems:@[strMessage,image,url]
                    applicationActivities:nil];
    }
    else
    {
        controller=[[UIActivityViewController alloc]
                    initWithActivityItems:@[strMessage,url]
                    applicationActivities:nil];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [viewController presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        controller.popoverPresentationController.sourceView =viewController.view;
        [viewController presentViewController:controller animated:YES completion:nil];
        
    }
}

#pragma mark - Save objects
-(void)funSaveCategoryData:(int)categoryType objectKey:(NSString *)objectKey dictionary:(NSMutableDictionary *)categoryDict
{
    NSString *plistPath = [self funGetAppPlistPathString];
    
    switch (categoryType) {
        case KCategoryBankAccount:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryBankAccount];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setObject:dict forKey:CategoryBankAccount];
            }
            else
            {
                [dictBankAc setValue:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryCreditCard:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryCreditCard];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryCreditCard];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryLoginPassword:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryLoginPassword];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryLoginPassword];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryIdentity:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryIdentity];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryIdentity];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategorySecureNote:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategorySecureNote];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategorySecureNote];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryDrivingLicence:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryDrivingLicence];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryDrivingLicence];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryMemberShip:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryMemberShip];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryMemberShip];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryPassport:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryPassport];
            if (dictBankAc.allKeys.count <= 0)
            {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:categoryDict,objectKey, nil];
                [self.dictAllCategoryData setValue:dict forKey:CategoryPassport];
            }
            else
            {
                [dictBankAc setObject:categoryDict forKey:objectKey];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Fetch objects
-(NSMutableArray *)funGetDetailObject:(int)categoryType isFavArrayToReturn:(BOOL)isFavArrayToReturn
{
    NSMutableArray *objectArray;
    switch (categoryType) {
        case 1://Bank Account
            objectArray = [self funGetDetailObjectBankAccount:isFavArrayToReturn];
            break;
        case 2://Credit card
            objectArray = [self funGetDetailObjectCreditCard:isFavArrayToReturn];
            break;
        case 3://Credit card
            objectArray = [self funGetDetailObjectLogin:isFavArrayToReturn];
            break;
        case 4://Identity
            objectArray = [self funGetDetailObjectIdentity:isFavArrayToReturn];
            break;
        case 5://secure Notes
            objectArray = [self funGetDetailObjectSecureNote:isFavArrayToReturn];
            break;
        case 6://Driving Licence
            objectArray = [self funGetDetailObjectDrivingLicence:isFavArrayToReturn];
            break;
        case 7://Membership
            objectArray = [self funGetDetailObjectMemberShip:isFavArrayToReturn];
            break;
        case 8://Passport
            objectArray = [self funGetDetailObjectPassport:isFavArrayToReturn];
            break;
        default:
            break;
    }

    return objectArray;
}


/**
 return favourite objects from all categories

 @param isFavArrayToReturn true
 @return return favourite objects array
 */
-(NSMutableArray *)funGetDetailAllFavouriteObjects:(BOOL)isFavArrayToReturn
{
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];
 
    for (int i = 0 ; i <= 8 ; i++)
    {
        NSMutableArray *array = [self funGetDetailObject:i isFavArrayToReturn:isFavArrayToReturn];
        if (array != nil && array.count > 0)
        {
            [objectArray addObjectsFromArray:array];
        }
    }
    
    return objectArray;
}

/**
 funGetDetailObjectBankAccount - to get bank account custom object
 
 @return bank account custom object array
 */
-(NSMutableArray *)funGetDetailObjectBankAccount:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryBankAccount];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *bankAcObject = [[NSMutableDictionary alloc] init];
        NSLog(@"title - %@",[obj valueForKey:@"title"]);
        [bankAcObject setValue:object forKey:@"recordID"];
        [bankAcObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [bankAcObject setValue:[obj valueForKey:@"bankName"] forKey:@"bankName"];
        NSString *decACNumber = [[AppData sharedAppData] decrypt:[obj valueForKey:@"accountNumber"] withKey:[AppData sharedAppData].userAppPassword];
        if (decACNumber != nil)
        {
            [bankAcObject setValue:decACNumber forKey:@"accountNumber"];
        }
        else
        {
            [bankAcObject setValue:@"" forKey:@"accountNumber"];
        }
        [bankAcObject setValue:[obj valueForKey:@"accountHolderName"] forKey:@"accountHolderName"];
        [bankAcObject setValue:[obj valueForKey:@"accountType"] forKey:@"accountType"];
        [bankAcObject setValue:[obj valueForKey:@"userID"] forKey:@"userID"];
        [bankAcObject setValue:[obj valueForKey:@"accountPIN"] forKey:@"accountPIN"];
        [bankAcObject setValue:[obj valueForKey:@"branchCode"] forKey:@"branchCode"];
        [bankAcObject setValue:[obj valueForKey:@"branchPhone"] forKey:@"branchPhone"];
        [bankAcObject setValue:[obj valueForKey:@"branchAddress"] forKey:@"branchAddress"];
        [bankAcObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        [bankAcObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [bankAcObject setValue:[NSNumber numberWithInt:1] forKey:@"categoryType"];
        //categoryType
        
        NSLog(@"fav - %@",[obj valueForKey:@"isFavourite"]);
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:bankAcObject];
            }
        }
        else
        {
            [returnArray addObject:bankAcObject];
        }
        
        
    }
    
    return returnArray;
}

/**
 funGetDetailObjectCreditCard - to get credit card custom object
 
 @return credit card custom object array
 */
-(NSMutableArray *)funGetDetailObjectCreditCard:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryCreditCard];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *bankAcObject = [[NSMutableDictionary alloc] init];
        NSLog(@"title - %@",[obj valueForKey:@"title"]);
        [bankAcObject setValue:object forKey:@"recordID"];
        [bankAcObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [bankAcObject setValue:[obj valueForKey:@"bankName"] forKey:@"bankName"];
        [bankAcObject setValue:[obj valueForKey:@"cardHolderName"] forKey:@"cardHolderName"];
        NSString *decCardNumber = [[AppData sharedAppData] decrypt:[obj valueForKey:@"cardNumber"] withKey:[AppData sharedAppData].userAppPassword];
        if (decCardNumber != nil)
        {
            [bankAcObject setValue:decCardNumber forKey:@"cardNumber"];
        }
        else
        {
            [bankAcObject setValue:@"" forKey:@"cardNumber"];
        }
        
        [bankAcObject setValue:[obj valueForKey:@"cardType"] forKey:@"cardType"];
        [bankAcObject setValue:[obj valueForKey:@"cardPIN"] forKey:@"cardPIN"];
        [bankAcObject setValue:[obj valueForKey:@"localPhone"] forKey:@"localPhone"];
        [bankAcObject setValue:[obj valueForKey:@"tollFreePhone"] forKey:@"tollFreePhone"];
        [bankAcObject setValue:[obj valueForKey:@"website"] forKey:@"website"];
        
        [bankAcObject setValue:[obj valueForKey:@"expiryDate"] forKey:@"expiryDate"];
        [bankAcObject setValue:[obj valueForKey:@"validFrom"] forKey:@"validFrom"];
        [bankAcObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        [bankAcObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [bankAcObject setValue:[NSNumber numberWithInt:2] forKey:@"categoryType"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:bankAcObject];
            }
        }
        else
        {
            [returnArray addObject:bankAcObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectLogin - to get Login object
 
 @return login custom object array
 */
-(NSMutableArray *)funGetDetailObjectLogin:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryLoginPassword];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];
        NSLog(@"title - %@",[obj valueForKey:@"title"]);
        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [loginObject setValue:[obj valueForKey:@"url"] forKey:@"url"];
        [loginObject setValue:[obj valueForKey:@"username"] forKey:@"username"];

        [loginObject setValue:[obj valueForKey:@"password"] forKey:@"password"];
        
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:3] forKey:@"categoryType"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectIdentity - to get Identity object
 
 @return Identity custom object array
 */
-(NSMutableArray *)funGetDetailObjectIdentity:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryIdentity];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];

        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [loginObject setValue:[obj valueForKey:@"firstName"] forKey:@"firstName"];
        [loginObject setValue:[obj valueForKey:@"lastName"] forKey:@"lastName"];
        [loginObject setValue:[obj valueForKey:@"email"] forKey:@"email"];
        [loginObject setValue:[obj valueForKey:@"occupation"] forKey:@"occupation"];
        [loginObject setValue:[obj valueForKey:@"phoneNumber"] forKey:@"phoneNumber"];
        [loginObject setValue:[obj valueForKey:@"webSite"] forKey:@"webSite"];
        [loginObject setValue:[obj valueForKey:@"address"] forKey:@"address"];
        [loginObject setValue:[obj valueForKey:@"country"] forKey:@"country"];
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:4] forKey:@"categoryType"];
        [loginObject setValue:[obj valueForKey:@"birthDate"] forKey:@"birthDate"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectSecureNote - to get SecureNote object
 
 @return SecureNote custom object array
 */
-(NSMutableArray *)funGetDetailObjectSecureNote:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategorySecureNote];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];
        
        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:5] forKey:@"categoryType"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectIdentity - to get Identity object
 
 @return Identity custom object array
 */
-(NSMutableArray *)funGetDetailObjectDrivingLicence:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryDrivingLicence];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];
        /*
         title
         fullName
         address
         licenceNumber
         classType
         documentNumber
         DOB
         issueDate
         expiryDate
         note
         */
        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [loginObject setValue:[obj valueForKey:@"fullName"] forKey:@"fullName"];
        [loginObject setValue:[obj valueForKey:@"address"] forKey:@"address"];
        [loginObject setValue:[obj valueForKey:@"licenceNumber"] forKey:@"licenceNumber"];
        [loginObject setValue:[obj valueForKey:@"classType"] forKey:@"classType"];
        [loginObject setValue:[obj valueForKey:@"documentNumber"] forKey:@"documentNumber"];
        [loginObject setValue:[obj valueForKey:@"DOB"] forKey:@"DOB"];
        [loginObject setValue:[obj valueForKey:@"issueDate"] forKey:@"issueDate"];
        [loginObject setValue:[obj valueForKey:@"expiryDate"] forKey:@"expiryDate"];
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:6] forKey:@"categoryType"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectIdentity - to get Identity object
 
 @return Identity custom object array
 */
-(NSMutableArray *)funGetDetailObjectMemberShip:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryMemberShip];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];
        /*
         -title
         -groupName
         -website
         -telephone
         -memberName
         -memberSinceDate
         -expiryDate
         -memberID
         memberPassword
         -note
         */
        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        [loginObject setValue:[obj valueForKey:@"memberName"] forKey:@"memberName"];
        [loginObject setValue:[obj valueForKey:@"groupName"] forKey:@"groupName"];
        [loginObject setValue:[obj valueForKey:@"telephone"] forKey:@"telephone"];
        [loginObject setValue:[obj valueForKey:@"memberID"] forKey:@"memberID"];
        [loginObject setValue:[obj valueForKey:@"memberPassword"] forKey:@"memberPassword"];
        [loginObject setValue:[obj valueForKey:@"website"] forKey:@"website"];
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:7] forKey:@"categoryType"];
        [loginObject setValue:[obj valueForKey:@"memberSinceDate"] forKey:@"memberSinceDate"];
        [loginObject setValue:[obj valueForKey:@"expiryDate"] forKey:@"expiryDate"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}

/**
 funGetDetailObjectIdentity - to get Identity object
 
 @return Identity custom object array
 */
-(NSMutableArray *)funGetDetailObjectPassport:(BOOL)isFavArrayToReturn
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSArray *arrayList = (NSArray *)[self.dictAllCategoryData objectForKey:CategoryPassport];
    
    for (id object in arrayList)
    {
        NSMutableDictionary *obj = [arrayList valueForKey:object];
        NSMutableDictionary *loginObject = [[NSMutableDictionary alloc] init];
        
        [loginObject setValue:object forKey:@"recordID"];
        [loginObject setValue:[obj valueForKey:@"title"] forKey:@"title"];
        /*
         -title
         -passportType
         -issuingCountry
         -fullName
         -nationality
         -issuingAuthority
         -DOB
         issueDate
         expiryDate
         note
         */
        [loginObject setValue:[obj valueForKey:@"fullName"] forKey:@"fullName"];
        [loginObject setValue:[obj valueForKey:@"passportType"] forKey:@"passportType"];
        [loginObject setValue:[obj valueForKey:@"issuingCountry"] forKey:@"issuingCountry"];
        [loginObject setValue:[obj valueForKey:@"nationality"] forKey:@"nationality"];
        [loginObject setValue:[obj valueForKey:@"issuingAuthority"] forKey:@"issuingAuthority"];
        [loginObject setValue:[obj valueForKey:@"DOB"] forKey:@"DOB"];
        [loginObject setValue:[obj valueForKey:@"issueDate"] forKey:@"issueDate"];
        [loginObject setValue:[obj valueForKey:@"expiryDate"] forKey:@"expiryDate"];
        [loginObject setValue:[obj valueForKey:@"note"] forKey:@"note"];
        [loginObject setValue:[obj valueForKey:@"isFavourite"] forKey:@"isFavourite"];
        [loginObject setValue:[NSNumber numberWithInt:8] forKey:@"categoryType"];
        
        if (isFavArrayToReturn == true)
        {
            if ([[obj valueForKey:@"isFavourite"] boolValue] == true)
            {
                [returnArray addObject:loginObject];
            }
        }
        else
        {
            [returnArray addObject:loginObject];
        }
    }
    
    return returnArray;
}
#pragma mark - Delete objects
-(void)funDeleteCategoryData:(int)categoryType recordIDToDelete:(NSString *)recordIDToDelete
{
    NSString *plistPath = [self funGetAppPlistPathString];
    
    switch (categoryType) {
        case KCategoryBankAccount:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryBankAccount];
            
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryCreditCard:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryCreditCard];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryLoginPassword:
            
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryLoginPassword];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
        case KCategoryIdentity:
            
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryIdentity];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
        case KCategorySecureNote:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategorySecureNote];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryDrivingLicence:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryDrivingLicence];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryMemberShip:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryMemberShip];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
        case KCategoryPassport:
        {
            NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryPassport];
            if(dictBankAc.allKeys.count == 1)
            {
                if ([recordIDToDelete isEqualToString:dictBankAc.allKeys[0]])
                {
                    [dictBankAc removeAllObjects];
                }
            }
            else
            {
                [dictBankAc removeObjectForKey:recordIDToDelete];
            }
            [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - Encryption/Decryption methods
- (NSString *)encrypt:(NSString *)string withKey:(NSString *)Key
{
    NSString *strEncrypted = [FBEncryptorAES encryptBase64String:string
                                                       keyString:Key
                                                   separateLines:NO];
    NSLog(@"encrypted: %@", strEncrypted);
    
    return strEncrypted;
    
}

- (NSString *)decrypt:(NSString *)string withKey:(NSString *)Key
{
    NSString *strDecrypted = [FBEncryptorAES decryptBase64String:string
                                                       keyString:Key];
    
    //NSLog(@"Decrypted: %@", strDecrypted);
    
    return strDecrypted;
    
}

#pragma mark - Decrypt/Encrypt process for reset password methods
-(void)funDecryptEncryptDataForPasswordReset:(NSString *)newPasscode
{
    NSString *plistPath = [self funGetAppPlistPathString];
    
    NSMutableArray *arrayAllObjects = [self funGetDetailAllObjects];
    for(id object in arrayAllObjects)
    {
        NSNumber *categoryType = [object valueForKey:@"categoryType"];
        switch (categoryType.intValue) {
            case KCategoryBankAccount:
            {
                NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryBankAccount];
                NSString *objectKey = [object valueForKey:@"recordID"];
                NSMutableDictionary *dictObject = [dictBankAc valueForKey:objectKey];
                
                NSString *decACPIN = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"accountPIN"] withKey:[AppData sharedAppData].userAppPassword];
                if (decACPIN != nil && ![decACPIN isEqualToString:@""])
                {
                    NSString *encACPIN = [[AppData sharedAppData] encrypt:decACPIN withKey:newPasscode];
                    if (encACPIN != nil)
                    {
                        [dictObject setValue:encACPIN forKey:@"accountPIN"];
                    }
                }
                NSString *decACNumber = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"accountNumber"] withKey:[AppData sharedAppData].userAppPassword];
                if (decACNumber != nil && ![decACNumber isEqualToString:@""])
                {
                    NSString *encACNumber = [[AppData sharedAppData] encrypt:decACNumber withKey:newPasscode];
                    if (encACNumber != nil)
                    {
                        [dictObject setValue:encACNumber forKey:@"accountNumber"];
                    }
                }
                
            }
                break;
            case KCategoryCreditCard:
            {
                NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryCreditCard];
                //[dictBankAc setObject:categoryDict forKey:objectKey];
                NSString *objectKey = [object valueForKey:@"recordID"];
                NSMutableDictionary *dictObject = [dictBankAc valueForKey:objectKey];
                
                NSString *decCardPIN = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"cardPIN"] withKey:[AppData sharedAppData].userAppPassword];
                if (decCardPIN != nil && ![decCardPIN isEqualToString:@""])
                {
                    NSString *encCardPIN = [[AppData sharedAppData] encrypt:decCardPIN withKey:newPasscode];
                    [dictObject setValue:encCardPIN forKey:@"cardPIN"];
                }
                NSString *decCardNumber = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"cardNumber"] withKey:[AppData sharedAppData].userAppPassword];;
                if (decCardNumber != nil && ![decCardNumber isEqualToString:@""])
                {
                    NSString *encCardNumber = [[AppData sharedAppData] encrypt:decCardNumber withKey:newPasscode];
                    if (encCardNumber != nil)
                    {
                        [dictObject setValue:encCardNumber forKey:@"cardNumber"];
                    }
                }
            }
            case KCategoryLoginPassword:
            {
                NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryLoginPassword];
                //[dictBankAc setObject:categoryDict forKey:objectKey];
                NSString *objectKey = [object valueForKey:@"recordID"];
                NSMutableDictionary *dictObject = [dictBankAc valueForKey:objectKey];
                
                NSString *password = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"password"] withKey:[AppData sharedAppData].userAppPassword];
                if (password != nil && ![password isEqualToString:@""])
                {
                    NSString *encPassword = [[AppData sharedAppData] encrypt:password withKey:newPasscode];
                    if (encPassword != nil)
                    {
                        [dictObject setValue:encPassword forKey:@"password"];
                    }
                }
            }
            case KCategoryMemberShip:
            {
                NSMutableDictionary *dictBankAc = [self.dictAllCategoryData objectForKey:CategoryMemberShip];
                //[dictBankAc setObject:categoryDict forKey:objectKey];
                NSString *objectKey = [object valueForKey:@"recordID"];
                NSMutableDictionary *dictObject = [dictBankAc valueForKey:objectKey];
                
                
                NSString *memberPassword = [[AppData sharedAppData] decrypt:[dictObject valueForKey:@"memberPassword"] withKey:[AppData sharedAppData].userAppPassword];;
                if (memberPassword != nil && ![memberPassword isEqualToString:@""])
                {
                    NSString *encMemberPassword = [[AppData sharedAppData] encrypt:memberPassword withKey:newPasscode];
                    if (encMemberPassword != nil)
                    {
                        [dictObject setValue:encMemberPassword forKey:@"memberPassword"];
                    }
                }
            }
                
            default:
                break;
        }
    }
    
    [self.dictAllCategoryData writeToFile:plistPath atomically:YES];
}

-(NSMutableArray *)funGetDetailAllObjects
{
    return [self funGetDetailAllFavouriteObjects:false];
}

#pragma mark - Others Helpers
-(NSString *)funGetAppPlistPathString
{
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dirPath = [libraryPath stringByAppendingPathComponent:@"SecretPassword"];
    NSString *plistPath = [dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",AppAllDataPlistName]];
    
    return plistPath;
}
-(void)loadActivityView
{
    self.viewActivityLoaderBG=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.activityLoaderView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityLoaderView.frame = CGRectMake(100, 80, 30, 30);
    self.activityLoaderView.center = appdelegate.window.center;
    self.activityLoaderView.hidesWhenStopped = TRUE;
    self.activityLoaderView.hidden= YES;
    self.activityLoaderView.backgroundColor=[UIColor blackColor];
    [self.viewActivityLoaderBG addSubview:self.activityLoaderView];
}
-(void)showActivityLoaderInView:(UIView *)view
{
    if(self.viewActivityLoaderBG)
    {
        [view addSubview:self.viewActivityLoaderBG];
        [view bringSubviewToFront:self.viewActivityLoaderBG];
        self.activityLoaderView.hidden= NO;
        [self.activityLoaderView startAnimating];
    }
    else
    {
        NSLog(@"showActivityLoaderInView");
    }
}
-(void)hideActivityLoader
{
    self.activityLoaderView.hidden= YES;
    [self.activityLoaderView stopAnimating];
    [self.viewActivityLoaderBG removeFromSuperview];
    
}
-(void)hideActivityLoderAfterSomeTime
{
    if(!self.activityLoaderView.hidden)
    {
        [self hideActivityLoader];
        [self showAlertWithMessage:@"We are getting some network error, please check your network connection" andTitle:@"Sorry!"];
    }
}
-(BOOL)isNetAvailable
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if(netStatus == NotReachable)
    {
        [self showAlertWithMessage:@"Please check your Network Connection." andTitle:@"No Internet Connection!"];
        return NO;
        
    }
    else
    {
        return YES;
    }
    
}
-(void)alertForNotificationOnViewController:(UIViewController*) viewController
{
    
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:[self.dicNotificationInfo objectForKey:@"Quotes_Title"] message:[self.dicNotificationInfo objectForKey:@"Quotes_Detail"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* Done = [UIAlertAction
                           actionWithTitle:@"Done"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [alert dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    [alert addAction:Done];
    [viewController presentViewController:alert animated:YES completion:nil];
}
-(void)showAlertWithMessage:(NSString *)msg andTitle:(NSString *)strTitle
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:strTitle message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];

    
    [alert addAction:ok];
    //    [alert addAction:cancel];
    
    
    UIViewController *topViewController = appdelegate.window.rootViewController;
    while (topViewController.presentedViewController)
    {
        topViewController = topViewController.presentedViewController;
    }
    
    [topViewController presentViewController:alert animated:YES completion:nil];
}
-(void)showAlertForRateUsOnViewController:(UIViewController*) viewController
{
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Rate our App" message:@"If you Love our App, please take a moment to rate it." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Rate"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [self rateUs];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Not Now"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    //    UIViewController *topViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    //    while (topViewController.presentedViewController)
    //    {
    //        topViewController = topViewController.presentedViewController;
    //    }
    [viewController presentViewController:alert animated:YES completion:nil];
}
-(void)rateUs
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.3)
    {
        [SKStoreReviewController requestReview];
    }
    else
    {
        NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
        NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";
        NSString *templateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APP_ID&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
        
        //ios7 before
        NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@",AppId]];
        
        // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            reviewURL = [templateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@",AppId]];
        }
        // iOS 8 needs a different templateReviewURL also @see https://github.com/arashpayan/appirater/issues/182
        else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            reviewURL = [templateReviewURLiOS8 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@",AppId]];
        }
        
        // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL] options:@{} completionHandler:^(BOOL success)
         {
             if(success)
             {
                 NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                 [userdefaults setObject:[NSNumber numberWithInt:1] forKey:@"isAppRateDone"];
                 [userdefaults synchronize];
             }
             else
             {
                 
             }
         }];
    }
    
}
#pragma mark - AdMob
-(void)showAddAtBottom
{
    AppData *appData=[AppData sharedAppData];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *viewController=(UINavigationController *)[appdelegate.window rootViewController];
    CGSize adSize=appData.adMob.bannerView.frame.size;
    if(!appData.isRemoveAdPurchased)
    {
        if(appData.adMob.bannerView.superview)
        {
            [appData.adMob.bannerView removeFromSuperview];
        }
        if (@available(iOS 11.0, *))
        {
            UIEdgeInsets insets = [[UIApplication sharedApplication] keyWindow].safeAreaInsets;
            if (insets.bottom > 0)
            {
                appData.adMob.bannerView.frame =CGRectMake(0,viewController.view.frame.size.height-adSize.height - insets.bottom,adSize.width,adSize.height);
            }
            else
            {
                appData.adMob.bannerView.frame =CGRectMake(0,viewController.view.frame.size.height-adSize.height,adSize.width,adSize.height);
            }
            //
        }
        else
        {
            // Fallback on earlier versions
            appData.adMob.bannerView.frame =CGRectMake(0,viewController.view.frame.size.height-adSize.height,adSize.width,adSize.height);
        }
        [viewController.view addSubview:appData.adMob.bannerView];
        [[AppData sharedAppData] showFullScreenAdonComtroller:viewController];
    }
}
-(void)showAddOnTopOfToolBar
{
    AppData *appData=[AppData sharedAppData];
    AppDelegate *appdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    UINavigationController *viewController=(UINavigationController *)[appdelegate.window rootViewController];
    CGSize adSize=appData.adMob.bannerView.frame.size;
    if(!appData.isRemoveAdPurchased)
    {
        if(appData.adMob.bannerView.superview)
        {
            [appData.adMob.bannerView removeFromSuperview];
        }

        appData.adMob.bannerView.frame =CGRectMake(0,viewController.toolbar.frame.origin.y - adSize.height,adSize.width,adSize.height);
        [viewController.view addSubview:appData.adMob.bannerView];
        [[AppData sharedAppData] showFullScreenAdonComtroller:viewController];
    }
}
-(BOOL)showFullScreenAdonComtroller:(UIViewController*)controller
{
    if(!self.isRemoveAdPurchased)
    {
        self.admobFullScreenDislplayCount++;
        
        if(self.admobFullScreenDislplayCount%AdMobFullScreenRepeatCount==0)
        {
            if(self.adMob.interstitial.isReady)
            {
                [self.adMob showFullScreenAdonComtroller:controller];
            }
            return  YES;
        }
        else if(self.appLaunchCount%2==0)
        {
            if(self.adMob.interstitial.isReady)
            {
                [self.adMob showFullScreenAdonComtroller:controller];
            }
            return  YES;
        }
        else
        {
            return  NO;
        }
    }
    else
    {
        return NO;
    }
}
#pragma mark - Theme Helpers
-(UIColor *)funGetThemeColor
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSInteger theme = [userdefaults integerForKey:@"AppTheme"];
    UIColor *colorTheme = [UIColor colorWithRed:98/255.0 green:0/255.0 blue:238/255.0 alpha:1.0];
    switch (theme) {
        case 1:
            colorTheme = [UIColor colorWithRed:98/255.0 green:0/255.0 blue:238/255.0 alpha:1.0];
            break;
        case 2:
            colorTheme = [UIColor colorWithRed:3/255.0 green:54/255.0 blue:255/255.0 alpha:1.0];
            break;
        case 3:
            colorTheme = [UIColor colorWithRed:255/255.0 green:2/255.0 blue:0/102 alpha:1.0];
            break;
        case 4:
            colorTheme = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0/255.0 alpha:1.0];
            break;
        case 5:
            colorTheme = [UIColor colorWithRed:72/255.0 green:206/255.0 blue:107/255.0 alpha:1.0];
            break;
        case 6:
            colorTheme = [UIColor colorWithRed:255/255.0 green:17/255.0 blue:52/255.0 alpha:1.0];
            break;
        default:
            break;
    }
    return colorTheme;
}

-(UIImage *)funImageFromRGB:(UIColor *)colorRGB
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    [colorRGB setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
