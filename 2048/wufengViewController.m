//
//  wufengViewController.m
//  2048
//
//  Created by geekgroup on 16-5-20.
//  Copyright (c) 2016年 huangjian. All rights reserved.
//

#import "wufengViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface wufengViewController ()
{
    AVAudioPlayer *_music;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *label2048;
@property (weak, nonatomic) IBOutlet UILabel *labelscore;
@property (weak, nonatomic) IBOutlet UILabel *labelbest;
@property (weak, nonatomic) IBOutlet UILabel *labeljoin;
- (IBAction)newgame:(UIButton *)sender;

@property (strong,nonatomic)NSArray *array;
@property (strong,nonatomic)NSArray *array1;
@property (strong,nonatomic)NSString *strr;


@end
int square[4][4]={0};
int score=0;
int flag=0;

@implementation wufengViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //获取文件里的内容
    NSString *path=@"/Users/geekgroup/Desktop/a.txt";
    NSFileHandle *readHandle=[NSFileHandle fileHandleForReadingAtPath:path];
    
    NSData *data= [readHandle readDataToEndOfFile];
    _strr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [readHandle closeFile];
    _labelbest.text=[NSString stringWithFormat:@"BEST\n%@",_strr];
   
    //手势识别
	UISwipeGestureRecognizer *LeftRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Left)];
    UISwipeGestureRecognizer *RightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Right)];
    UISwipeGestureRecognizer *upRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Up)];
    UISwipeGestureRecognizer *downRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(Down)];
    
    [LeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [RightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];

    [_imageview addGestureRecognizer:LeftRecognizer];
    [_imageview addGestureRecognizer:RightRecognizer];
    [_imageview addGestureRecognizer:upRecognizer];
    [_imageview addGestureRecognizer:downRecognizer];
    
    self.view.backgroundColor=[UIColor colorWithRed:249/255.0 green:248/255.0 blue:239/255.0 alpha:1];
    _label2048.textColor=[UIColor colorWithRed:134/255.0 green:128/255.0 blue:120/255.0 alpha:1];
    _label2048.backgroundColor=[UIColor colorWithRed:249/255.0 green:248/255.0 blue:239/255.0 alpha:1];
    _labelscore.backgroundColor=[UIColor colorWithRed:195/255.0 green:186/255.0 blue:175/255.0 alpha:1];
    _labelscore.textColor=[UIColor colorWithRed:134/255.0 green:128/255.0 blue:120/255.0 alpha:1];
    _labelbest.backgroundColor=[UIColor colorWithRed:195/255.0 green:186/255.0 blue:175/255.0 alpha:1];
    _labelbest.textColor=[UIColor colorWithRed:134/255.0 green:128/255.0 blue:120/255.0 alpha:1];
    _labeljoin.textColor=[UIColor colorWithRed:134/255.0 green:128/255.0 blue:120/255.0 alpha:1];
    _labeljoin.backgroundColor=[UIColor colorWithRed:249/255.0 green:248/255.0 blue:239/255.0 alpha:1];
    
    [self addBlock];
    [self addBlock];
}
//移动音乐
-(void)music
{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"move.wav" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:path];
    _music=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_music play];
}
//左移
-(void)Left
{
    
    if (flag==0) {
        
    [self music];
    int arr[4][4];
    //遍历二维数组
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            //另一个二维数组接收移动前的二维数组
            arr[i][j] = square[i][j];
        }
    }
    
    for (int i=0; i<4; i++)
    {
        int count=0;
        int record[4]={0};
        for (int j=0; j<4; j++)
        {
            //判断数组元素是否大于0
            if (square[i][j]>0)
            {
             //遍历后面的元素
                for (int index=j+1; index<4; index++)
                {
                    if (square[i][index]==0)
                        continue;
                    
                    if (square[i][index]==square[i][j])
                    {
                       
                        square[i][j]*=2;
                        score+=square[i][index]*2;
                        NSString *str=[NSString stringWithFormat:@"SCORE\n %i",score];
                        _labelscore.text=str;
                        square[i][index]=0;
                        //根据tag值删除视图
                        [[_imageview viewWithTag:i*4+index] removeFromSuperview];
                        [[_imageview viewWithTag:i*4+j] removeFromSuperview];
                        //添加新的label
                        UILabel *label=[[UILabel alloc]init];
                        label.frame=CGRectMake(18+69*j, 17+69*i, 58, 58);
                        label.font=[UIFont boldSystemFontOfSize:35];
                        label.text=[NSString stringWithFormat:@"%d",square[i][j]];
                        [self  setLabelColorAndText:label];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.tag=i*4+j;
                        label.adjustsFontSizeToFitWidth=YES;
                       
                        [_imageview addSubview:label];
   
                        break;
                    }
                    else
                        break;
                }
                
                
                
            }
 
        }
        //遍历每行元素
        for (int n=0; n<4; n++)
        {
            
            if (square[i][n]>0)
            {
                //将大于0的存进一维数组
                record[count]=square[i][n];
                square[i][n]=0;
                count++;
                
                [[_imageview viewWithTag:i*4+n] removeFromSuperview];
                
            }
            
            
        }
        //遍历大于0的数组元素个数
        for (int m=0; m<count; m++) {
            //从左到右依次赋值
            square[i][m]=record[m];
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(18+69*m, 17+69*i, 58, 58);
            label.font=[UIFont boldSystemFontOfSize:35];
            label.text=[NSString stringWithFormat:@"%d",record[m]];
            [self  setLabelColorAndText:label];
            label.textAlignment=NSTextAlignmentCenter;
            label.tag=i*4+m;
            label.adjustsFontSizeToFitWidth=YES;
            
            [_imageview addSubview:label];
            
            
        }
        

    }
    int num = 0;
   //遍历数组 判断与移动前数组是否相同，相同表示没有移动
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if (arr[i][j] == square[i][j]) {
                num++;
                
            }
           
        }
    }
    //判断数组是否充满
    if (num != 16) {
        [self addBlock];
    }
    [self file1];
    
    //判断结束
    [self performSelector:@selector(checkEnd) withObject:self afterDelay:1];
     
    }
    
}
-(void)Right
{
    if (flag==0) {
    [self music];
    int arr[4][4];
    
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            arr[i][j] = square[i][j];
        }
    }
    
    
    
    for (int i=0; i<4; i++)
    {
        int count=0;
        int record[4]={0};
        for (int j=3; j>=0; j--)
        {
            if (square[i][j]>0)
            {
                
                for (int index=j-1; index>=0; index--)
                {
                    if (square[i][index]==0)
                        continue;
                    
                    if (square[i][index]==square[i][j])
                    {
                        
                        square[i][j]*=2;
                        score+=square[i][index]*2;
                        NSString *str=[NSString stringWithFormat:@"SCORE\n %i",score];
                        _labelscore.text=str;
                        square[i][index]=0;
                        [[_imageview viewWithTag:i*4+index] removeFromSuperview];
                        [[_imageview viewWithTag:i*4+j] removeFromSuperview];
                        UILabel *label=[[UILabel alloc]init];
                        label.frame=CGRectMake(18+69*j, 17+69*i, 58, 58);
                        label.font=[UIFont boldSystemFontOfSize:35];
                        label.text=[NSString stringWithFormat:@"%d",square[i][j]];
                        [self  setLabelColorAndText:label];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.tag=i*4+j;
                        label.adjustsFontSizeToFitWidth=YES;
                        
                        [_imageview addSubview:label];
                        
                        break;
                    }
                    else
                        break;
                }
                
                
                
            }
            
        }
        for (int n=3; n>=0; n--)
        {
            
            if (square[i][n]>0)
            {
                record[count]=square[i][n];
                square[i][n]=0;
                count++;
                [[_imageview viewWithTag:i*4+n] removeFromSuperview];
                
            }
            
            
        }
       
        for (int m=0; m<count; m++) {
            
            square[i][3-m]=record[m];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(18+69*(3-m), 17+69*i, 58, 58);
            label.font=[UIFont boldSystemFontOfSize:35];
            label.text=[NSString stringWithFormat:@"%d",record[m]];
            [self  setLabelColorAndText:label];
            label.textAlignment=NSTextAlignmentCenter;
            label.tag=i*4+3-m;
            label.adjustsFontSizeToFitWidth=YES;
            
            [_imageview addSubview:label];
            
            
        }
        
    }
    int num = 0;
   
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if (arr[i][j] == square[i][j]) {
                num++;
            }
            

        }
    }
    
    if (num != 16) {
        [self addBlock];
    }
    [self file1];
   
   
    [self performSelector:@selector(checkEnd) withObject:self afterDelay:1];
    }
}


-(void)Up
{
    if (flag==0)
    {
    [self music];
    int arr[4][4];
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            arr[i][j] = square[i][j];
        }
    }
    
    
    for (int j=0; j<4; j++)
    {
        int count=0;
        int record[4]={0};
        for (int i=0; i<4; i++)
        {
            if (square[i][j]>0)
            {
                
                for (int index=i+1; index<4; index++)
                {
                    if (square[index][j]==0)
                        continue;
                    
                    if (square[index][j]==square[i][j])
                    {
                        
                        square[i][j]*=2;
                        score+=square[index][j]*2;
                        NSString *str=[NSString stringWithFormat:@"SCORE\n %i",score];
                        _labelscore.text=str;
                        square[index][j]=0;
                        [[_imageview viewWithTag:(index)*4+j] removeFromSuperview];
                        [[_imageview viewWithTag:i*4+j] removeFromSuperview];
                        UILabel *label=[[UILabel alloc]init];
                        label.frame=CGRectMake(18+69*j, 17+69*i, 58, 58);
                        label.font=[UIFont boldSystemFontOfSize:35];
                        label.text=[NSString stringWithFormat:@"%d",square[i][j]];
                        [self  setLabelColorAndText:label];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.tag=i*4+j;
                        label.adjustsFontSizeToFitWidth=YES;
                        
                        [_imageview addSubview:label];
                        
                        break;
                    }
                    else
                        break;
                }
                
                
                
            }
            
        }
        for (int n=0; n<4; n++)
        {
            
            if (square[n][j]>0)
            {
                record[count]=square[n][j];
                square[n][j]=0;
                count++;
                [[_imageview viewWithTag:n*4+j] removeFromSuperview];
                
            }
            
            
        }
        for (int m=0; m<count; m++) {
            
            square[m][j]=record[m];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(18+69*j, 17+69*m, 58, 58);
            label.font=[UIFont boldSystemFontOfSize:35];
            label.text=[NSString stringWithFormat:@"%d",record[m]];
            [self  setLabelColorAndText:label];
            label.textAlignment=NSTextAlignmentCenter;
            label.tag=m*4+j;
            label.adjustsFontSizeToFitWidth=YES;
            
            [_imageview addSubview:label];
            
            
        }
        
        
    }
    
    int num = 0;
   
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if (arr[i][j] == square[i][j]) {
                num++;
                
            }
            
        }
    }
    
    if (num != 16) {
        [self addBlock];
    }
    
    [self file1];
    [self performSelector:@selector(checkEnd) withObject:self afterDelay:1];
        
    }
}

-(void)Down
{
    if (flag==0) {
        
    
    [self music];
    int arr[4][4];
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            arr[i][j] = square[i][j];
        }
    }
    for (int j=0; j<4; j++)
    {
        int count=0;
        int record[4]={0};
        for (int i=3; i>=0; i--)
        {
            if (square[i][j]>0)
            {
                
                for (int index=i-1; index>=0; index--)
                {
                    if (square[index][j]==0)
                        continue;
                    
                    if (square[index][j]==square[i][j])
                    {
                        
                        square[i][j]*=2;
                        score+=square[index][j]*2;
                        NSString *str=[NSString stringWithFormat:@"SCORE\n %i",score];
                        _labelscore.text=str;
                        square[index][j]=0;
                        [[_imageview viewWithTag:(index)*4+j] removeFromSuperview];
                        [[_imageview viewWithTag:i*4+j] removeFromSuperview];
                        UILabel *label=[[UILabel alloc]init];
                        label.frame=CGRectMake(18+69*j, 17+69*i, 58, 58);
                        label.font=[UIFont boldSystemFontOfSize:35];
                        label.text=[NSString stringWithFormat:@"%d",square[i][j]];
                        [self  setLabelColorAndText:label];
                        label.textAlignment=NSTextAlignmentCenter;
                        label.tag=i*4+j;
                        label.adjustsFontSizeToFitWidth=YES;
                        
                        [_imageview addSubview:label];
                        
                        break;
                    }
                    else
                        break;
                }
                
                
                
            }
            
        }
        for (int n=3; n>=0; n--)
        {
            
            if (square[n][j]>0)
            {
                record[count]=square[n][j];
                square[n][j]=0;
                count++;
                [[_imageview viewWithTag:n*4+j] removeFromSuperview];
                
            }
            
            
        }
        
        for (int m=0; m<count; m++) {
            
            square[3-m][j]=record[m];
            
            UILabel *label=[[UILabel alloc]init];
            label.frame=CGRectMake(18+69*j, 17+69*(3-m), 58, 58);
            label.font=[UIFont boldSystemFontOfSize:35];
            label.text=[NSString stringWithFormat:@"%d",record[m]];
            [self  setLabelColorAndText:label];
            label.textAlignment=NSTextAlignmentCenter;
            label.tag=(3-m)*4+j;
            label.adjustsFontSizeToFitWidth=YES;
            
            [_imageview addSubview:label];
            
            
        }
        
    }
    
    int num = 0;
       for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if (arr[i][j] == square[i][j]) {
                 num++;
                
            }
           
        }
    }
    
    if (num != 16) {
        [self addBlock];
    }
    [self file1];
    
    [self performSelector:@selector(checkEnd) withObject:self afterDelay:1];
    }
    
}
//判断单元格
-(int)BlockCount
{
    int count=0;
    for (int i=0; i<4; i++)
        for (int j=0; j<4; j++) {
            if (square[i][j]>0) {
                count++;
            }
        }
    return count;
}

//随机产生单元格
-(void)addBlock
{
    int x=arc4random()%4;
    int y=arc4random()%4;
    
    if ([self BlockCount]<16)
    {
        
        while (square[x][y]>0)
        {
            x=arc4random()%4;
            y=arc4random()%4;
        }
        square[x][y]=(arc4random()%2+1)*2;
        UILabel *label=[[UILabel alloc]init];
        label.center=CGPointMake( 47.5+69*y, 46.5+69*x);
        label.font=[UIFont boldSystemFontOfSize:35];
        label.text=[NSString stringWithFormat:@"%i",square[x][y]];
        [self  setLabelColorAndText:label];
        label.textAlignment=NSTextAlignmentCenter;
        
        label.adjustsFontSizeToFitWidth=YES;
        label.tag=x*4+y;
        label.layer.masksToBounds=YES;

        [_imageview addSubview:label];
        [UIView animateWithDuration:0.4 animations:^{
            label.bounds=CGRectMake(0, 0, 58, 58);
        }];
        
    }
    
}

//文件操作
-(void)file1
{
    NSString *path=@"/Users/geekgroup/Desktop/a.txt";
    NSFileHandle *read=[NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data=[read readDataToEndOfFile];
    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (score>[str intValue]) {
        _labelbest.text=[NSString stringWithFormat:@"BEST\n%d",score];
        NSFileHandle *write=[NSFileHandle fileHandleForWritingAtPath:path];
        NSData *data1=[[NSString stringWithFormat:@"%d",score] dataUsingEncoding:NSUTF8StringEncoding];
        [write writeData:data1];
        [write closeFile];
    }
    [read closeFile];
}
//重新开始游戏按钮
- (IBAction)newgame:(UIButton *)sender {
    
    flag=0;
    NSString *path=[[NSBundle mainBundle]pathForResource:@"点击按钮.aiff" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:path];
    _music=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_music play];

    //遍历二维数组，删除所有视图
    for (int i=0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if (square[i][j]>0) {
                [[_imageview viewWithTag:i*4+j] removeFromSuperview];
                square[i][j]=0;
            }
        }
    }
    [self addBlock];
    [self addBlock];
    [self file1];

    _labelscore.text=@"SCORE\n0";
    score=0;
    
}

-(int)isEnd
{
    int index=1;

    //镜像判断是否还能移动
    for (int i=0; i<3; i++) {
        for (int j=0; j<3; j++) {
            
                if (square[i][j]==square[i+1][j]||square[i][j]==square[i][j+1]||square[3-i][3-j] == square[2-i][3-j] || square[3-i][3-j] == square[3-i][2-j]) {
                   index=0;
                }
            
            
        }
        
    }
    return index;
}

//判断是否结束
-(void)checkEnd
{
    if ([self BlockCount]==16)
    {
        if ([self isEnd])
        {
            flag=1;
            NSString *path=[[NSBundle mainBundle]pathForResource:@"失败.aiff" ofType:nil];
            NSURL *url=[NSURL fileURLWithPath:path];
            _music=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [_music play];
            NSString *str=[NSString stringWithFormat:@"得分: %d",score];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:str message:@"Game Over!!\n重新开始请点击NEW GAME!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
            if (score>[_strr intValue]) {
                _labelbest.text=[NSString stringWithFormat:@"BEST\n%d",score];
                
                
            }
           
            score=0;
            _labelscore.text=@"SCORE\n0";
            
           
            
        }
    }
    
}

//字体设置
-(void)setLabelColorAndText:(UILabel *)label
{
    int labelValue=label.text.intValue;
    switch (labelValue)
    {
        case 2:
            label.backgroundColor=[UIColor colorWithRed:235/255.0 green:227/255.0 blue:218/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:116/255.0 green:109/255.0 blue:104/255.0 alpha:1];
            break;
        case 4:
            label.backgroundColor=[UIColor colorWithRed:232/255.0 green:223/255.0 blue:199/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:116/255.0 green:109/255.0 blue:104/255.0 alpha:1];
            break;
        case 8:
            label.backgroundColor=[UIColor colorWithRed:225/255.0 green:174/255.0 blue:123/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 16:
            label.backgroundColor=[UIColor colorWithRed:222/255.0 green:148/255.0 blue:101/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 32:
            label.backgroundColor=[UIColor colorWithRed:217/255.0 green:123/255.0 blue:97/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 64:
            label.backgroundColor=[UIColor colorWithRed:204/255.0 green:88/255.0 blue:59/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 128:
            label.backgroundColor=[UIColor colorWithRed:234/255.0 green:214/255.0 blue:112/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 256:
            label.backgroundColor=[UIColor colorWithRed:228/255.0 green:204/255.0 blue:104/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];break;
        case 512:
            label.backgroundColor=[UIColor colorWithRed:217/255.0 green:191/255.0 blue:61/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];break;
        case 1024:
            label.backgroundColor=[UIColor colorWithRed:215/255.0 green:183/255.0 blue:48/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        case 2048:
            label.backgroundColor=[UIColor colorWithRed:225/255.0 green:196/255.0 blue:47/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];break;
        case 4096:
            label.backgroundColor=[UIColor colorWithRed:208/255.0 green:61/255.0 blue:63/255.0 alpha:1];
            label.textColor=[UIColor colorWithRed:247/255.0 green:249/255.0 blue:238/255.0 alpha:1];
            break;
        default:
            break;
    }
    
}

@end
