//
//  AddressBookViewModel.h
//  MVVMWithRACDemo
//
//  Created by Liusui on 16/6/28.
//  Copyright © 2016年 Shanghai Elephant Financial Services Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@class AddressBookModel;
@interface AddressBookViewModel : NSObject
- (RACSignal *)getAddressBookInformation;
- (RACCommand *)callButtonCommandWithModel:(AddressBookModel *)model;

@end
