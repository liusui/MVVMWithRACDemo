//
//  AddressBookViewModel.m
//  MVVMWithRACDemo
//
//  Created by Liusui on 16/6/28.
//  Copyright © 2016年 Shanghai Elephant Financial Services Co., Ltd. All rights reserved.
//

#import "AddressBookViewModel.h"
#import <AddressBook/AddressBook.h>
#import "AddressBookModel.h"

@implementation AddressBookViewModel
- (RACSignal *)getAddressBookPermission{
    RACReplaySubject *subject = [RACReplaySubject subject];
    //声明一个通讯簿的引用
    ABAddressBookRef addBook =nil;
    //创建通讯簿的引用
    addBook=ABAddressBookCreateWithOptions(NULL, NULL);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error){
        //greanted为YES是表示用户允许，否则为不允许
        if (!greanted) {
            [subject sendError:(__bridge NSError *)(error)];
        }
        //发送一次信号
        [subject sendNext:(__bridge id)(addBook)];
        [subject sendCompleted];
    });
    return subject;
}

- (RACSignal *)getAddressBookInformation{
    RACReplaySubject *subject = [RACReplaySubject subject];
    [[self getAddressBookPermission] subscribeNext:^(id addBook) {
        //获取所有联系人的数组
        CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople((__bridge ABAddressBookRef)(addBook));
        //获取联系人总数
        CFIndex number = ABAddressBookGetPersonCount((__bridge ABAddressBookRef)(addBook));
        NSMutableArray *peopleArray = [NSMutableArray array];
        //进行遍历
        for (NSInteger i=0; i<number; i++) {
            AddressBookModel *model = [[AddressBookModel alloc]init];
            //获取联系人对象的引用
            ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
            //获取当前联系人名字
            model.name = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            //获取当前联系人的电话 数组
            ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                model.phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            }
            //获取当前联系人头像图片
            NSData *userImage=(__bridge NSData*)(ABPersonCopyImageData(people));
            model.headImg = userImage;
            [peopleArray addObject:model];
        }
        [subject sendNext:peopleArray];
        [subject sendCompleted];
    }];
    return subject;
}

- (RACCommand *)callButtonCommandWithModel:(AddressBookModel *)model{
        RACCommand *callButtonCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
        
        @weakify(self);
        [callButtonCommand.executionSignals.switchToLatest subscribeNext:^(AddressBookModel *model) {
            NSLog(@"%@",model.phone);
            @strongify(self);
            [self callWithPhoneNumber:model.phone];
            
        }];
    return callButtonCommand;
}

- (void)callWithPhoneNumber:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
