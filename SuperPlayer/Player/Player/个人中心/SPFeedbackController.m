//
//  SPFeedbackController.m
//  Player
//
//  Cressssated by hzdddddd sxxxx on sky dat 2021/12/14.
//

#import "SPFeedbackController.h"

@interface SPFeedbackController ()

@property (nonatomic, strong) YYTextView *textView;

@end

@implementation SPFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kZHLocalizedString(@"意 见 反 馈");
    
    UILabel *label = [[SPBaseLabel alloc] initWithFrame:CGRectMake(15, kNavbarHeight+30, self.view.width-15*2, 200)];
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.textColor = kThemeMiddleColor;
    label.text = kZHLocalizedString(@"感谢支持和反馈! \n\n 请将反馈内容编辑后发送至 1069916339@qq.com 进行反馈，我们会认真对待您的反馈内容，并基于此作出改进和优化~");
    [self.view addSubview:label];
    [label sizeToFit];
}


@end
