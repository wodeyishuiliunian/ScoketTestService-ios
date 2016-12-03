//
//  ViewController.h
//  ScoketTestFuwu
//
//  Created by 三米 on 16/12/2.
//  Copyright © 2016年 pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property(nonatomic, strong)IBOutlet UITextField * portText;
@property(nonatomic, strong)IBOutlet UITextField * sengMsgText;
@property(nonatomic, strong)IBOutlet UITextView  * readMsgText;

@end

