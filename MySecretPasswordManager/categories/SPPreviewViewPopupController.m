//
//  SPPreviewViewPopupController.m
//  MySecretPasswordManager
//
//  Created by Nilesh on 5/9/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "SPPreviewViewPopupController.h"
#import "CoreDataStackManager.h"
#import "AppData.h"

@interface SPPreviewViewPopupController ()

@end

@implementation SPPreviewViewPopupController
{
    NSMutableArray *previewItemsArray;
    NSString *textViewPreview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.previewTableView.delegate = self;
    self.previewTableView.dataSource = self;
    self.previewTableView.separatorColor = [UIColor clearColor];
    
    [self funGetPreviewStringAndFillArray];
    
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.cornerRadius = 6;
    self.previewTableView.layer.cornerRadius = 6;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self funGetPreviewStringAndFillArray];
}

-(void)funGetPreviewStringAndFillArray
{
    NSString *previewString = [[CoreDataStackManager sharedManager] funGetPreviewString:self.previewObject categoryType:self.categoryType];
    
    if (previewString != nil)
    {
        textViewPreview = previewString;
    }
    else
    {
        textViewPreview = @"Can not create Preview.";
    }
    
    NSMutableArray *arrStrings = [[previewString componentsSeparatedByString:@"\n"] mutableCopy];
    NSLog(@"arrStrings - %@",arrStrings);
    
    previewItemsArray = [[NSMutableArray alloc] init];
    if (arrStrings.count > 0)
    {
        self.previewTitle.text = [arrStrings objectAtIndex:0];
        
        if (self.categoryType == KCategorySecureNote)
        {
            [arrStrings removeObjectAtIndex:0];
        }
        else
        {
            [arrStrings removeObjectAtIndex:1];
            [arrStrings removeObjectAtIndex:0];
        }
        [arrStrings objectAtIndex:0];
        previewItemsArray = arrStrings;
    }
    
    
}
- (IBAction)funSharePreview:(id)sender
{
    NSArray *activityItems = [NSArray arrayWithObjects:textViewPreview, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma  mark :- tableview data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return previewItemsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *stringPreview = [previewItemsArray objectAtIndex:indexPath.row];
    if (stringPreview != nil && stringPreview.length > 0)
    {
        return 30;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self.previewTableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
//    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *stringPreview = [previewItemsArray objectAtIndex:indexPath.row];
    if (stringPreview != nil && stringPreview.length > 0)
    {
        cell.textLabel.text = [previewItemsArray objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        cell.textLabel.minimumScaleFactor = 7.0;
        return cell;
    }
    
    
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma  mark :- tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
