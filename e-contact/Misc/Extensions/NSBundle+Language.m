//
//  NSBundle+Language.m
//  e-contact
//
//  Created by Igor Muzyka on 6/13/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

static const char kBundleKey = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

__attribute__((constructor)) static void changingBundleClass() {
    object_setClass([NSBundle mainBundle],[BundleEx class]);
}

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language {
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end