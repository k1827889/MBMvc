//
// Created by <a href="mailto:wentong@taobao.com">文通</a> on 12-12-8 下午3:48.
//


#import "TBMBDemoView.h"
#import "TBMBBind.h"
#import "TBMBViewController.h"


@interface TBMBDemoView () <UITextFieldDelegate>
@end

@implementation TBMBDemoView {
@private
    UIButton *button;
}

- (void)loadView {
    [super loadView];
    button = [[UIButton alloc] initWithFrame:CGRectMake(50, 40, 200, 30)];
    [button addTarget:self action:@selector(requestStatic:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    button.tag = 1;
    [self addSubview:button];

    UIButton *buttonTwo = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 200, 30)];
    TBMBBindObjectStrong(tbKeyPath(self, viewDO.buttonTitle2), buttonTwo, ^(UIButton *host, id old, id new) {
        [host setTitle:new forState:UIControlStateNormal];
    }
    );
    [buttonTwo addTarget:self action:@selector(requestInstance:) forControlEvents:UIControlEventTouchUpInside];
    buttonTwo.backgroundColor = [UIColor redColor];
    buttonTwo.tag = 2;
    [self addSubview:buttonTwo];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 120, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    textField.tag = 3;
    textField.delegate = self;
    TBMBBindPropertyStrong(self, viewDO.text, textField, text);
    [self addSubview:textField];

    UIButton *buttonNav = [[UIButton alloc] initWithFrame:CGRectMake(50, 160, 200, 30)];
    [buttonNav setTitle:@"测试并发" forState:UIControlStateNormal];
    [buttonNav addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    buttonNav.backgroundColor = [UIColor redColor];
    buttonNav.tag = 4;
    [self addSubview:buttonNav];

    UIButton *buttonPrev = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 200, 30)];
    [buttonPrev setTitle:@"不会发生什么" forState:UIControlStateNormal];
    [buttonPrev addTarget:self action:@selector(prev:) forControlEvents:UIControlEventTouchUpInside];
    buttonPrev.backgroundColor = [UIColor redColor];
    buttonPrev.tag = 5;


    UITextField *textFieldSync = [[UITextField alloc] initWithFrame:CGRectMake(50, 240, 200, 30)];
    textFieldSync.backgroundColor = [UIColor blueColor];
    textFieldSync.tag = 6;
    textFieldSync.delegate = self;
    [self addSubview:textFieldSync];


    UITextView *textViewLog = [[UITextView alloc] initWithFrame:CGRectMake(50, 280, 200, 190)];
    textViewLog.backgroundColor = [UIColor blueColor];
    TBMBBindPropertyStrong(self, viewDO.log, textViewLog, text);
    [self addSubview:textViewLog];

    [self addSubview:buttonPrev];
}


- (void)prev:(id)prev {
    [self.delegate prev];
}

- (void)next:(id)next {
    [self.delegate next];
}

- (void)requestInstance
        :(id)requestInstance {
    self.viewDO.requestInstance = YES;
}

- (void)requestStatic:(id)requestStatic {
    self.viewDO.requestStatic = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 3) {
        self.viewDO.text = textField.text;
    }
}

- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string {
    if (textField.tag == 6) {
        NSMutableString *text = [NSMutableString stringWithString:textField.text];
        if (range.location >= text.length) {
            [text appendString:string];
        } else {
            [text replaceCharactersInRange:range withString:string];
        }
        self.viewDO.text = text;
    }
    return YES;
}

//这类方法会被自动注册到Bind上哦,屌吧
TBMBWhenThisKeyPathChange(viewDO, text){
    NSLog(@"Text Change:%@", new);
}

TBMBWhenThisKeyPathChange(viewDO, buttonTitle1){
    [button setTitle:new forState:UIControlStateNormal];
}

@end