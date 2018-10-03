//
//  NoteViewController.h
//  MySecretPasswordManager
//
//  Created by Karan on 03/10/18.
//  Copyright © 2018 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate <NSObject>

-(void)funNoteTextForCategory:(NSString *)text;

@end

@interface NoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) NSString *buttonText;

@property (nonatomic,weak) id delegate;

@end
