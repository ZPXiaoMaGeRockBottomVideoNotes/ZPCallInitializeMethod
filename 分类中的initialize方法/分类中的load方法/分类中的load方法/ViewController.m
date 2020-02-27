//
//  ViewController.m
//  分类中的load方法
//
//  Created by 赵鹏 on 2019/5/13.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
 ·+initialize类方法会在该类第一次接收到消息的时候进行调用，即对该类调用objc_msgSend函数发送消息的时候进行调用，也就是说在用到该类的时候才会调用这个方法了，不用的时候则不会调用该方法；
 ·一个类的+initialize类方法只会被调用一次；
 ·想在该类在第一次使用的时候做一些事情的话就要重写该类的+initialize类方法；
 
 ·initialize类方法的调用原理：
 其实和《day05》中的《Category》Demo中所述的分类的实现原理相似。当原类和分类中都实现了initialize类方法的时候，在程序编译完成的时候，分类中的initialize类方法会存放在struct _category_t结构体中，然后在程序运行的时候，利用Runtime运行时机制，系统会把结构体中的实例方法和类方法全都合并到原类的class对象和meat-class对象中，当第一次使用objc_msgSend函数给原类发消息的时候，系统会根据原类的class对象里面的isa指针找到原类的meat-class对象，在这个meat-class对象里面的类方法列表中首先找到的是它的分类的initialize类方法，然后进行调用，整个调用过程结束。
 
 ·initialize类方法的调用顺序：
 initialize类方法的调用顺序其实和《day05》中的《Category》Demo中所述的原类和分类的调用顺序的原则大致相同：
 1、当原类只有一个分类的时候，并且原类和分类中都实现了initialize类方法，当原类的class对象第一次接收到消息的时候，不管原类和分类的编译顺序如何，都会只执行分类中的initialize类方法，然后整个调用过程结束；
 2、当一个原类有多个分类的时候，并且原类和这些分类中都实现了initialize类方法，当原类的class对象第一次接收到消息的时候，系统的调用顺序符合下面的两个原则：
 ① 不管原类是先编译的还是后编译的，永远只执行分类中的initialize类方法，然后整个调用过程结束；
 ② 系统总是只执行后编译的分类里面的initialize类方法，然后整个调用过程结束。
 从上述的内容中可以看出，如果分类中实现了initialize类方法，则会覆盖原类的initialize类方法。
 3、对于有父子关系的两个类系统（父类以及这个父类的分类，子类以及这个子类的分类）而言，并且这两个系统的所有的类都实现了initialize类方法的情况下，当子类的class对象第一次接收到消息的时候，系统先会调用它的父类系统的initialize类方法，再根据这个父类系统中的分类的个数判断是根据上面的1原则还是2原则，再决定调用哪个分类中的initialize类方法。然后开始调用子类系统的initialize类方法，跟前面的一样，先根据子类系统中的分类的个数判断是根据上面的1原则还是2原则，再决定调用哪个分类中的initialize类方法，然后整个调用过程结束；
 4、对于有父子关系的两个类系统（父类以及这个父类的分类，子类以及这个子类的分类）而言，父类系统的所有的类中都实现了initialize类方法，但是子类系统的所有的类中都没有实现initialize类方法的情况下，当子类的class对象第一次接收到消息的时候，从结果上看，系统会多次（两次）调用父类系统中的initialize类方法。
 原因如下：当子类的class对象第一次接收到消息的时候，系统会先调用它的父类系统中的initialize类方法（第一次调用）。然后系统会尝试调用子类系统里面的initialize类方法，系统会根据子类的class对象里面的isa指针找到它的meat-class对象，在这个meat-class对象里面寻找initialize类方法，因为子类系统的所有类（原类、分类）都没有实现initialize类方法，所以系统会根据这个meat-class对象里面的superClass指针找到这个子类的父类的meat-class对象，因为父类系统中实现了initialize类方法，所以系统会再次调用该方法（第二次调用）。需要注意的是，虽说父类系统里面的initialize类方法被调用了两次，但并不代表父类被初始化了两次。
 
 ·+initialize类方法与+load类方法的区别：
 1、调用方式的区别：调用+initialize类方法的时候是通过Runtime的消息发送(objc_msgSend)机制进行调用的，而调用+load类方法的时候通过指针直接找到+load类方法实现的存储地址，从而进行调用的，所以不管是分类、子类、父类，每个类都会调用+load类方法；
 2、调用时间的区别：
 （1）+initialize类方法是该类第一次接收到消息的时候才会被调用的，并且每个类只会被调用一次。但是在子类没有实现+initialize类方法的时候，它的父类的+initialize类方法可能会被调用多次；
 （2）+load类方法是在Runtime加载类、分类的时候才会被调用的。即便这个类不被使用的话，只要程序开始加载了，+load类方法就会被调用。并且+load类方法在程序运行的过程中只会被调用一次。
 */

#import "ViewController.h"
#import "ZPPerson.h"
#import "ZPStudent.h"
#import "ZPTeacher.h"
#include <objc/message.h>"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self test];
}

- (void)test
{
    [ZPPerson alloc];
}

@end
