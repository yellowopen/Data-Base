//
//  ViewController.m
//  CoreDemo
//
//  Created by Mac on 2018/1/23.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"
#import "PersonManger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view, typically from a nib.
    
//    Person1 *addPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[[CoreDataManager shareManager]objContext]];
//    NSLog(@"addPerson is :%@",[addPerson class]);
//
//    addPerson.name = self.nameTextField.text;
//    addPerson.fName = [addPerson.name substringToIndex:1];
//    NSLog(@"fName:%@",addPerson.fName);
//    addPerson.age = [NSNumber numberWithInt:[self.ageTextF.text intValue]];
//    [[CoreDataManager shareManager] insertDataWithModel:addPerson];
    PersonManger *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[[CoreDataManager shareManager]objContext]];
    person.name = @"7";
    person.content = [[NSData data]init];
    [[CoreDataManager shareManager] insertDataWithModel:person];
    
    NSArray * arr =  [[CoreDataManager shareManager]fetchAllData];
    [arr enumerateObjectsUsingBlock:^(PersonManger *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",obj.name);
    }];
    
//    [arr enumerateObjectsUsingBlock:^(Person1 * obj, NSUInteger idx, BOOL *stop) {
//        if ([obj.name isEqualToString:@"张三"]) {
//            [content addObject:obj];
//        }
//    }];
    
//    [CoreDataManager shareManager] ;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
