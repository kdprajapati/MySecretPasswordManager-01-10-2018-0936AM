//
//  NoteViewController.m
//  MySecretPasswordManager
//
//  Created by Karan on 03/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(funSaveNoteToCategory)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: saveButton, nil];
    
    self.noteTextView.layer.borderWidth = 1.5;
    self.noteTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if ([self.buttonText isEqualToString:@"Tap to create note"])
    {
        self.noteTextView.text = @"";
    }
    else
    {
        self.noteTextView.text = self.buttonText;
    }
}

-(void)funSaveNoteToCategory
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(funNoteTextForCategory:)])
    {
        [self.delegate funNoteTextForCategory:self.noteTextView.text];
        
        [self.navigationController popViewControllerAnimated:true];
    }
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
