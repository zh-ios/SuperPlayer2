//
//  PrivacyController.m
//  Player
//
//  Created by hz on 2021/12/6.
//

#import "PrivacyController.h"

@interface PrivacyController ()

@end

@implementation PrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = kZHLocalizedString(@"隐私政策");
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, kNavbarHeight+15, self.view.width-15*2, kScreenHeight-kNavbarHeight-15*2)];
    textView.editable = NO;
    [self.view addSubview:textView];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor = kTextColor3;
    textView.showsVerticalScrollIndicator = NO;
    
    textView.text = kZHLocalizedString(@"本应用不会收集任何有关于你的隐私信息，你可以放心使用，确保你的隐私安全");
    
    
}


@end
