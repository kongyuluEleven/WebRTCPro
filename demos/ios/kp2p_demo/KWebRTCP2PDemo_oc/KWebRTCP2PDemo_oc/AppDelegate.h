//
//  AppDelegate.h
//  KWebRTCP2PDemo_oc
//
//  Created by kongyulu on 2020/7/11.
//  Copyright © 2020 wondershare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

