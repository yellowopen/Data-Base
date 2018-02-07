//
//  CoreDataManager.h
//  NSFetchedResultsControllerDemo
//
//  Created by LZXuan on 14-9-25.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersonManger.h"
@interface CoreDataManager : NSObject
@property (nonatomic,readonly)  NSManagedObjectContext *objContext;

//单例
+(CoreDataManager *)shareManager;
//保存
- (void)saveContext;
//添加数据
- (void)insertDataWithModel:(PersonManger *)model;
//修改数据
- (void)updataModelWithPer:(NSString *)perstring andObjContent:(NSData *)content;

//删除数据
- (void)deleteModelWithPerstring:(NSString *)per;

//获取全部数据
- (NSArray *)fetchAllData;
@end
