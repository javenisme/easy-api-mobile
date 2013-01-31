//
//  common.m
//  Gaopeng
//
//  Created by Javen Yang on 11-10-12.
//  Copyright 2011年 GP. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "common.h"
#import "ApiConfig.h"

NSNumber * parseNSNumberFromString(NSString * string){
    
    if (nil == string || [string isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:string];
    [f release];
    
    return myNumber;
}

NSDate* parseDateFromNSNumber(NSNumber* number){
    
    if (nil == number || ![number isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:[number longValue]];
}

BOOL parseBoolFromString(NSString* boolValue){
    
    if (nil == boolValue) {
        return NO;
    }
    
    static NSString* boolTrue = @"true";
    //static NSString* boolFalse = @"false";
    
    if (NSOrderedSame == [boolTrue caseInsensitiveCompare:boolValue]) {
        return YES;
    }
    
    return NO;
}


NSString* prepareStaticHttpPath(NSString* path){
 
    NSRange range = [path rangeOfString:@"http://"];
    
    // absolute path ,return directly
    if (range.length > 0) {
        return path;
    }
    
    // add static prefix
    return [[ApiConfig getApiStaticUrlPrefix] stringByAppendingFormat:@"%@",path];
}


NSString* extractFileNameFromPath(NSString* path){
    return [path lastPathComponent];
}


NSString* getTmpDownloadFilePath(NSString* filePath){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:extractFileNameFromPath(filePath)];
}

NSString* getCacheFilePath(NSString* cacheKey){
    return [NSTemporaryDirectory() stringByAppendingPathComponent:cacheKey];
}

NSString* md5(NSString* input)
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

NSString* trimString (NSString* input) {
    NSMutableString *mStr = [input mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)mStr);   
    NSString *result = [mStr copy];   
    [mStr release];
    return [result autorelease];
}

BOOL isNull(id object) {
    return (nil == object || [object isKindOfClass:[NSNull class]]);
}

id defaultNilObject(id object) {
    
    if (isNull(object)) {
        return nil;
    }
    
    return object;
}

BOOL isEmpty(NSString* str) {
    
    if (isNull(str)) {
        return YES;
    }
    
    return [trimString(str) length] <= 0;
}

NSString* defaultEmptyString(id object) {
    
    if (isNull(object)) {
        return @"";
    }
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    if ([object respondsToSelector:@selector(stringValue)]) {
        return [object stringValue];
    }
    
    return @"";
}


BOOL validateEmail(NSString* email) {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

BOOL validateMobile(NSString* mobile) {
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

