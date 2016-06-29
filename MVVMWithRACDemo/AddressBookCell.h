//
//  AddressBookCell.h
//  MVVMWithRACDemo
//
//  Created by Liusui on 16/6/28.
//  Copyright © 2016年 Shanghai Elephant Financial Services Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@class AddressBookModel;
@interface AddressBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

- (void)bindWithViewModel:(AddressBookModel *)model;

@end
