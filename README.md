# CRZScrollview
# [CRZWeakTarget weakTarget:self] 弱化target，防止timer循环引用
self.timer=[NSTimer timerWithTimeInterval:self.intervalTime target:[CRZWeakTarget weakTarget:self] selector:@selector(timerTick) userInfo:nil repeats:YES];
