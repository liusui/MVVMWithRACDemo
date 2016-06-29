//
//  AddressBookCell.m
//  MVVMWithRACDemo
//
//  Created by Liusui on 16/6/28.
//  Copyright © 2016年 Shanghai Elephant Financial Services Co., Ltd. All rights reserved.
//

#import "AddressBookCell.h"
#import "AddressBookModel.h"

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindWithViewModel:(AddressBookModel *)model{
    self.name.text = model.name;
    self.phoneLabel.text = model.phone;
    self.headImg.image = [UIImage imageWithData:model.headImg];
}

@end
