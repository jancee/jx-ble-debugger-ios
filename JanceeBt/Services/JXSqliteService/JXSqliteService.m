//
//  JXSqliteService.m
//  Zaplites Basic
//
//  Created by jancee wang on 2016/11/7.
//  Copyright © 2016年 Jingxi Wang. All rights reserved.
//

#import "JXSqliteService.h"

@implementation JXSqliteService

static JXSqliteService  *Instance;
static FMDatabase       *db;

#pragma mark base
+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^ {
    Instance = [[JXSqliteService alloc] init];
    [Instance openOrCreateDB];
  });
  return Instance;
}

- (void)dealloc {
  [db close];
}

- (void)openOrCreateDB {
  NSString *sqlPath = [PathTools getFullSandboxPathWithPath:Sqlite_File_Name];
  db                = [FMDatabase databaseWithPath:sqlPath];
  [db open];
}


/**
 */
- (id)querySingle:(NSString*)sql {
  FMResultSet *result = [db executeQuery:sql];
  if ([result next]) {
    return [result objectForColumnIndex:0];
  }
  return nil;
}

/**
 */
- (NSArray*)queryMany:(NSString*)sql {
  FMResultSet *result = [db executeQuery:sql];
  NSMutableArray *resultArray = [[NSMutableArray alloc] init];
  while ([result next]) {
    [resultArray addObject:[result objectForColumnIndex:0]];
  }
  return [resultArray copy];
}

@end
