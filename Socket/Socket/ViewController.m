//
//  ViewController.m
//  Socket
//
//  Created by Angelo on 2017/1/7.
//  Copyright © 2017年 Angelo. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket/SRWebSocket.h>

@interface ViewController ()<SRWebSocketDelegate>{
    SRWebSocket *_webSocket;
}

@property(nonatomic , strong)UITextField *textField;

@property(nonatomic , strong)UIButton *sendBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake(10, 20, 300, 30);
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"send" forState:UIControlStateNormal];
    _sendBtn.frame = CGRectMake(20, 60, 100, 30);
    [_sendBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(ag_sendAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
}

- (void)ag_reConnectWithUrl:(NSString*)urlStr{
    _webSocket.delegate = nil;
    [_webSocket close];
    //初始化SRWebSocket ,设置代理
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _webSocket.delegate = self;
    NSLog(@"opening connection");
    //开始链接
    [_webSocket open];
}

- (void)ag_close{
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self ag_reConnectWithUrl:@"ws://echo.websocket.org"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self ag_close];
}


//代理
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    //连接成功
    [webSocket send:@"发送消息"];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    //发生错误
    
    NSLog(@"%@",error);
    webSocket = nil;//socket 置空
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    //收到消息
    NSLog(@"-----%@",message);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    //关闭
    webSocket = nil;
}


- (void)ag_sendAction{
    [_webSocket send:_textField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
