//
//  PersonManger.h
//  CoreDemo
//
//  Created by Mac on 2018/1/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PersonManger : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSData *content;

@end
