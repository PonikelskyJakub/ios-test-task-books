//
//  AppDelegate.h
//  Test App - Books
//
//  Created by Jakub on 20.12.16.
//  Copyright © 2016 Ponikelský Jakub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

