//
//  ViewController.m
//  webView的功能
//
//  Created by ybk on 15/12/29.
//  Copyright © 2015年 ybk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>{
    
    UIWebView * webView;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /**
     * 修改了info.plist  NSAppTransportSecurity NSAllowsArbitraryLoads 要不会因为安全问题报错
     */
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- 64)];
    
    NSURL * url = [NSURL URLWithString:@"http://mt1.fangwudiya.com/game/september2016_second"];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    [self webViewDidFinishLoad:webView];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLeft setTitle:@"返回" forState:UIControlStateNormal];
    
    [btnLeft setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    btnLeft.frame = CGRectMake(10, 25, 60, 30);
    
    [btnLeft addTarget:self action:@selector(btnLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLeft];
    
    UIButton * btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnRight setTitle:@"响应" forState:UIControlStateNormal];
    
    [btnRight setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    btnRight.frame = CGRectMake(self.view.frame.size.width - 80, 25, 60, 30);
    
    [btnRight addTarget:self action:@selector(btnRight:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnRight];
}

#pragma **显示webview的代码**
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //获取webview的title
    //    document.getElementById("icon"); 通过标签唯一标识符获得元素,得到的就是具体的元素(标签)!
    //    document.getElementsByTagName(标签名); 通过标签名获得元素,得到的是所有同名的元素(标签)数组!
    //    document.getElementsByClassName(类名-class 属性值); 通过类名获得拥有相同类名的元素(标签)数组!
    //    document.getElementsByName(name属性值); 通过 name属性值获得拥有相同name属性值的元素(标签)数组!
    
    //    NSLog(@"title NAME == %@",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('app_share_title').value"]);
        
    //    NSLog(@"app_share_enable  ==%@===",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_enable').value"]);
    //    
    //    NSLog(@"app_share_url ==%@===",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_url').value"]);
    //    
    //    NSLog(@"app_share_desc  ==%@===",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_desc').value"]);
    //    
    //     NSLog(@"app_share_title  ==%@===",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_title').value"]);
    //    
    //     NSLog(@"app_share_img  ==%@===",[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('app_share_img').value"]);
    
    //获取
    NSString * js_result = [webView stringByEvaluatingJavaScriptFromString:@"document.title='搞一搞';"];
    
    NSLog(@"js_result  == \n %@  \n",js_result);
    
    [self ShowHTMLSource];
    
}

#pragma mark **打印HTML页面代码**

- (void)ShowHTMLSource{
    
    //html 头 ; innerHTML是标签名 ;[0]是第0行
    NSString * jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    
    NSString * HTMLSource = [webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    
    NSLog(@"HTMLSource ==\n %@  \n",HTMLSource);
    
}


#pragma **能返回到浏览的上一个页面**
- (void)btnLeft:(UIButton *)button{
    
    if ([webView canGoBack]) {
        
        [webView goBack];
        
    }else{
        
        button.enabled = YES;
        
    }
    
}

#pragma **点击界面的按钮 调用H5界面代码**
- (void)btnRight:(UIButton *)button{

    /**
     *  js函数调用
     */
    [webView stringByEvaluatingJavaScriptFromString:@"function()"];
    
    
    /**
     *  自定义js函数
     */
    NSString * jsString = @"function sayHello(){ \
                                                alert('🌹互相伤害🌹')\
                                                } \
                                                sayHello()";

    [webView stringByEvaluatingJavaScriptFromString:jsString];

    /**
     *  JS代码       http://www.w3school.com.cn/jsref/dom_obj_style.asp
     * position     把元素放置在static, relative, absolute 或 fixed 的位置
     * zIndex       设置元素的堆叠次序
     * marginTop    设置元素的顶边距 ( 距上一行底部距离 )
     * innerHTML    innerHTML 属性设置或返回表格行的开始和结束标签之间的 HTML。
     * document.body.appendChild(pname)  将加的标签追加到页面最底部
     */
    
    NSString * njsString = @" var   pname = document.getElementsByClassName('sep2016-h')[0];    \
                                    pname.style.position = 'relative';                          \
                                    pname.style.zIndex = '10000';                               \
                                    pname.style.marginTop = '0';                                \
                                    pname.innerHTML = '杰哥牛逼';                                \
                                    document.body.appendChild(pname);";
    
    [webView stringByEvaluatingJavaScriptFromString:njsString];
    
    [self ShowHTMLSource];

}

#pragma **捕获到将要加载url**
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSURL * url = [request URL];
    
    if ([[url scheme] isEqualToString:@"alert"]) {
        //拦截请求，弹出自定义对话框
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"test" message:[url host] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return NO;
        
    }else if([[url scheme] isEqualToString:@"tel"]){
        //拦截拨打电话请求
        BOOL result = [[UIApplication sharedApplication] openURL:url];
        
        if (!result) {
            
            NSLog(@"您的设备不支持打电话");
            
        } else {
            
            NSLog(@"电话打了");
            
        }
        
        return NO;
    }
 
    return YES;
}

#pragma **将本地的html文件加载到webview上**
- (void)loadHtml{
    
    NSString *readmePath = [[NSBundle mainBundle] pathForResource:@"iOS6" ofType:@"html"];
    
    NSString * htmlStr = [NSString stringWithContentsOfFile:readmePath encoding:NSUTF8StringEncoding error:nil];
    
    [webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:readmePath]];
}

#pragma **将本地的html字符串加载到webview上**
- (void)loadHTMLNSString{
    
    NSMutableString *html = [NSMutableString string];
    
    [html appendString:@"<html>"];
    
    [html appendString:@"<head>"];
    
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    
    [html appendString:@"</head>"];
    
    [html appendString:@"<body>"];
    
    [html appendString:@"<p>加工制造业让东莞市有了“世界工厂”的称号。但近一年来，“熄火”、“衰落”和“危机”成为外界加在东莞身上的标签。</p><p>目前，广东东莞、深圳等地的加工制造业很多工厂订单流失，不得不关停或将生产线向东南亚、非洲等地转移。媒体称之为东莞遭遇新一轮“工厂倒闭潮”。</p><p>但弥漫在东莞空气中的，并非都是悲观的气息。东莞市长袁宝成说，一些企业的倒闭，是属于市场经济中优胜劣汰，并不能说明制造业整体遭遇了危机。</p><p>相关专家认为，东莞一些以加工制造业为主的工厂倒闭的同时，一些高科技、大品牌公司也在崛起。一边是倒闭潮，一边是转型潮，两者并存。这是中国产业升级必须要经历的过程。</p><p>关闭东莞的工厂一年多后，37岁的任远前不久将深圳的工厂也关闭了。</p><p>几个月来，任远把自己名下的房子、车子变卖维持运转。但他发现，卖再多的房子和车也解决不了问题。最终，任远选择彻底告别手机制造业。</p><p>“我的遭遇和高民一样。”任远说，今年1月，“兆信通讯”董事长高民留下遗书自杀，引起社会轰动。高民的几位供货商拖欠上千万货款，成为压倒他的最后一根稻草。</p><p>10年前，东莞攒几台模具机就能开工厂。当时还是打工仔的任远抓住机遇，在东莞开了第一家手机屏幕组装厂。</p><p>经过数年的发展，任远的工厂年产值2亿多元，用工最高规模有上千人。2009年，他在深圳又开了一家同样的工厂，主要生产手机屏幕和屏幕光源。两个厂为他实现了财务自由。</p><p>但从2012年开始，手机制造业开始走下坡路。除了国际上一线手机品牌被淘汰外，手机配件制造业的竞争也越来越白热化。</p><p>与任远类似的案例近一两年不断上演。东莞当地流传的说法是，近一年以来，至少有4000家企业关门。而以电子行业为首的生产制造业企业成批量倒闭，媒体称之为东莞第二轮“倒闭潮”。</p><p><strong>屏幕工厂利润三年减少9成</strong></p><p>任远是河南人，2003年他到东莞打工，进入一家手机屏幕加工厂。在熟悉了业务流程后，2005年任远成立了自己的手机屏幕厂。</p><p>当时正是触屏手机发展的高潮期，各种手机都在更换手机屏，也涌现了很多智能手机品牌。任远开始为三星、诺基亚、</p><p><br></p>"];
    
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [webView loadHTMLString:html baseURL:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
