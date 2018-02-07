//
//  CoreDataManager.m
//  NSFetchedResultsControllerDemo
//
//  Created by LZXuan on 14-9-25.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import "CoreDataManager.h"
#import "PersonManger.h"
@implementation CoreDataManager
{
    NSManagedObjectContext *_objContext;//用于操作coreData数据
    NSManagedObjectModel *_objModel;//用于转化coreData文件
    NSPersistentStoreCoordinator *_storeCoordinator; //存储协调器
}

+ (CoreDataManager *)shareManager {
    static CoreDataManager *manager = nil;
    @synchronized(self ){
        if (manager == nil) {
            manager = [[CoreDataManager alloc] init];
        }
    }
    return manager;
}
- (id)init {
    if (self = [super init]) {
        //mergedModelFromBundles: 搜索工程中所有的.xcdatamodeld文件，并加载所有的实体到一个NSManagedObjectModel  实例中。这样托管对象模型知道所有当前工程中用到的托管对象的定义
        _objModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        //创建协调器
        _storeCoordinator  = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_objModel];
        //将coreData数据映射到数据库
        NSString *dataPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Person.sqlite"];
        NSLog(@"dataPath:%@",dataPath);
        NSError *error = nil;
        NSPersistentStore *store = [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:&error];
        if (!store) {
            
            NSLog(@"error:%@",error);
            //断言
            [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];//错误信息本地化描述
            //[NSException raise:@"添加数据库失败" format:@"%@",[error localizedDescription]];
        }
        //创建上下文托管对象
        _objContext = [[NSManagedObjectContext alloc] init];
        _objContext.persistentStoreCoordinator = _storeCoordinator;
    }
    return self;
}
//保存数据
- (void)saveContext {
    
    NSError *error =nil;
    //
    if (![_objContext save:&error]) {
        NSLog(@"save_error:%@",[error localizedDescription]);
    }
    NSLog(@"保存数据成功");
}
//添加数据
- (void)insertDataWithModel:(PersonManger *)model {
    
//    if ([model isKindOfClass:[PersonManger class]]) {
        NSLog(@"myPerson is %@",[model class]);
        //保存数据
        [self saveContext];
        NSLog(@"增加数据成功");
//    }
}
//修改数据根据名字修改数据
- (void)updataModelWithPer:(NSString *)perstring andObjContent:(NSData *)content {
    
        //创建查询请求
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        //设置谓词
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like %@",[NSString stringWithFormat:@"%@",perstring]];
        request.predicate = pre;
        //设置查询的模型
        request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:_objContext];
        
        //查询结果
        NSArray *rs = [_objContext executeFetchRequest:request error:nil];
        //有可能是多个相同的数据 如果是一个数据那么
#if 1
        PersonManger *person = [rs lastObject];
        person.name = perstring;
        person.content = content;
#else
        //否则遍历数组
        //默认是正序遍历
        /*
        [rs enumerateObjectsUsingBlock:^(Person * obj, NSUInteger idx, BOOL *stop) {
            obj.name = pChange.name;
            obj.age = pChange.age;
            *stop = YES;//停止遍历
        }];*/
#endif
        
        //回写保存数据
        [self saveContext];
        NSLog(@"修改数据成功");
    
}

//删除数据 根据名字删除
- (void)deleteModelWithPerstring:(NSString *)perstring {

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置谓词
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name like %@",[NSString stringWithFormat:@"*%@*",perstring]];
    //匹配*perString*任意包含perString的字符串
    request.predicate = pre;
    NSLog(@"NSPredicate:%@",pre);
    //设置查询的模型
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:_objContext];
    
    //查询结果 不考虑找到多个
    NSArray *rs = [_objContext executeFetchRequest:request error:nil];
//    if (rs) {
//        Person *person = [rs lastObject];
//        [_objContext deleteObject:person];
//        //删除成功
//        NSLog(@"删除成功");
//    }
    //考虑多个
    for (PersonManger *person in rs ) {
        [_objContext deleteObject:person];
        NSLog(@"删除成功");
    }
   
    
}

//获取全部数据
- (NSArray *)fetchAllData {
    //查找到所有的 数据
    //也可以设置排序
#if 1
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    // 设置排序（按照age降序）
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"content" ascending:NO];
    //同样也可以先根据年龄排序 如果有相等的那么在根据名字排序
//    NSSortDescriptor *name = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sort];

#else
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *person = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:_objContext];
    request.entity = person;
//    request.predicate = [NSPredicate predicateWithFormat:@"name like %@","小黄"];
#endif
    
    NSError *error = nil;
    NSArray *arr = [_objContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
    }
    return arr;
}


@end
