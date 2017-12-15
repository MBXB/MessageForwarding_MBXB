//
//  Person.m
//  消息转发机制Demo
//
//  Created by Oboe_b on 2017/12/14.
//  Copyright © 2017年 MBXB-bifujian. All rights reserved.
//人的一生唯有学习和锻炼不可辜负
//博客http://www.2bjs.com
//微博https://weibo.com/u/6342211709
//技术交流q群150731459
//微信搜索iOS编程实战


#import "Person.h"
#import "Mbxb.h"
#import <objc/message.h>

@implementation Person
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"sel = %@",NSStringFromSelector(sel));
    //判断没有实现方法, 那么我们就是动态添加一个方法
//    if (sel == @selector(run:)) {
//        class_addMethod(self, sel, (IMP)newRun, "v@:@:");
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}
//函数
void newRun(id self,SEL sel,NSString *str) {
    NSLog(@"---runok---%@",str);
}
//消息转发重定向
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"aSelector = %@",NSStringFromSelector(aSelector));
    return [super forwardingTargetForSelector:aSelector];
//    return [[Mbxb alloc]init];
}
//方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE(""){
    //转化字符
    NSString *sel = NSStringFromSelector(aSelector);
    //判断, 手动生成签名
    if([sel isEqualToString:@"run"]){
       return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else{
       return [super methodSignatureForSelector:aSelector];
    }
}
//拿到方法签名配发消息
- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE(""){
    NSLog(@"---%@---",anInvocation);
    //取到消息
    SEL seletor = [anInvocation selector];
    //转发
    Mbxb *bxb = [[Mbxb alloc]init];
    if([bxb respondsToSelector:seletor]){
        //调用对象,进行转发
        [anInvocation invokeWithTarget:bxb];
    }else{
        return [super forwardInvocation:anInvocation];
    }
}
//抛出异常
- (void)doesNotRecognizeSelector:(SEL)aSelector{
    NSString *selStr = NSStringFromSelector(aSelector);
    NSLog(@"%@不存在",selStr);
}
@end
