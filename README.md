# CRZScrollview
# 使用方式
pod 'CRZScrollview','~0.0.1'
# 防止循环引用
[CRZWeakTarget weakTarget:self] 弱化target，防止timer循环引用

self.timer=[NSTimer timerWithTimeInterval:self.intervalTime target:[CRZWeakTarget weakTarget:self] selector:@selector(timerTick) userInfo:nil repeats:YES];
#  使用方式
ImageUrls:NSURL的数组

CRZScrollview *scrollView = [[CRZScrollview alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) ImageUrls:@[url,ur2,ur3] IntervalTime:2];
 scrollView.delegate = self;
 [self.view addSubview:scrollView];
# 代理方法

-(void)CRZScrollview:(CRZScrollview *)scrollview selected:(NSInteger)index
