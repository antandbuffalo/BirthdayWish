//
//  ABUtility.m
//  AkilaBirthday
//
//  Created by iNET Admin on 19/8/14.
//  Copyright (c) 2014 cognizant. All rights reserved.
//

#import "ABUtility.h"

@implementation ABUtility

+(NSDictionary *)readDataFromPlist:(NSString *)plistName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return fileContent;
}

@end
