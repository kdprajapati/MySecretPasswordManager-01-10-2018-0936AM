//
//  MPassCodeViewController.h
//  MySecretPasswordManager
//
//  Created by Dev on 05/12/17.
//  Copyright © 2017 nil. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasscodeDelegate <NSObject>

-(void)funSuccessPassCode;

@end

@interface MPassCodeViewController : UIViewController
{
    enum PasscodeTypeEnum
    {
        FirstTimePasscode,//0
        ReEnterPasscode,//1
        EnterPasscode,//2
        EnterPasscodeToResetPasscode,//3
        EnterNewPasscodeToReset,//4
        ReEnterToResetPasscode//5
    } PasscodeType;
}

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;
@property (weak, nonatomic) IBOutlet UIButton *fiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eightBtn;
@property (weak, nonatomic) IBOutlet UIButton *nineBtn;
@property (weak, nonatomic) IBOutlet UIButton *zeroBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;



@property (weak, nonatomic) IBOutlet UIImageView *dotOne;
@property (weak, nonatomic) IBOutlet UIImageView *dotTwo;
@property (weak, nonatomic) IBOutlet UIImageView *dotThree;
@property (weak, nonatomic) IBOutlet UIImageView *dotFour;

@property (nonatomic, weak, nullable) id <PasscodeDelegate> delegate;

@property (nonatomic, assign) int passcodeModeType;
@property(nonatomic, strong) NSString *passCodeStr;

@property(nonatomic, strong) NSString *passCodeToReEnter;

@property (weak, nonatomic) IBOutlet UILabel *labelTitlePasscode;

@end
