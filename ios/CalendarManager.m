//
//  CalendarManager.m
//  calendarManager
//
//  Created by Victor Aliaga on 6/23/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import <EventKit/EventKit.h>
#import "CalendarManager.h"

@implementation CalendarManager

// To export a module named CalendarManager
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(addEvent:(NSString *)name details:(NSDictionary *)details)
{
  NSString *location = [RCTConvert NSString:details[@"location"]];
//  NSDate *time = [RCTConvert NSDate:details[@"time"]];
  
  EKEventStore *store = [EKEventStore new];
  [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
    if (!granted) { return; }
    EKEvent *event = [EKEvent eventWithEventStore:store];
    event.title = name;
    event.startDate = [NSDate date]; //today
    event.location = location;
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
    event.calendar = [store defaultCalendarForNewEvents];
    NSError *err = nil;
    [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
  }];
}

@end
