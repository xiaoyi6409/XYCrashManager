//
//  SlideAdressTool.m
//  XYGenericFramework
//
//  Created by xiaoyi on 2017/8/18.
//  Copyright © 2017年 xiaoyi. All rights reserved.
//

#import "SlideAdressTool.h"
#import <mach-o/dyld.h>

@implementation SlideAdressTool


//MARK: - 获取偏移量地址
long  calculate(void){
    long slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}


@end
