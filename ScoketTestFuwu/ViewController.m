//
//  ViewController.m
//  ScoketTestFuwu
//
//  Created by 三米 on 16/12/2.
//  Copyright © 2016年 pang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket * socket;
}
@property(nonatomic,strong)GCDAsyncSocket * clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
// 和服务器进行链接
- (IBAction)connect:(UIButton *)sender
{
    socket =[[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
    
    //2、打开监听端口
    
    NSError*error=nil;
    
    BOOL result = [socket acceptOnPort:[self.portText.text integerValue] error:&error];
    
    // 3. 判断端口号是否开放成功
    if (result) {
        [self addText:@"端口开放成功"];
    } else {
        [self addText:@"端口开放失败"];
    }

}
-(IBAction)disconnect:(id)sender
{
    [self.clientSocket disconnect];
}
#pragma mark - GCDAsyncSocketDelegate

// 当客户端链接服务器端的socket, 为客户端单生成一个newSocket

- (void)socket:(GCDAsyncSocket*)sock didAcceptNewSocket:(GCDAsyncSocket*)newSocket

{
    
    [self addText:@"链接成功"];
    //IP: newSocket.connectedHost
    //端口号: newSocket.connectedPort
    [self addText:[NSString stringWithFormat:@"链接地址:%@", newSocket.connectedHost]];
    [self addText:[NSString stringWithFormat:@"端口号:%hu", newSocket.connectedPort]];
    
    self.clientSocket= newSocket;
    [newSocket readDataWithTimeout:-1 tag:0];
}
-(IBAction)clearMsg:(id)sender
{
    self.readMsgText.text = @"";
}
// 发送
- (IBAction)sendMessage:(UIButton *)sender
{
    NSData *data = [self.sengMsgText.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
//    [self.clientSocket readDataWithTimeout:-1 tag:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    NSLog(@"%s",__func__);
//    [self.clientSocket readDataWithTimeout:-1 tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self addText:message];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
// textView填写内容
- (void)addText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.readMsgText.text = [self.readMsgText.text stringByAppendingFormat:@"%@\n", text];
    });
}
@end
