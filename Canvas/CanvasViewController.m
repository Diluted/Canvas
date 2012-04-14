//
//  CanvasViewController.m
//  Canvas
//
//  Created by 陆 泽夫 on 12-4-12.
//  Copyright (c) 2012年 SES. All rights reserved.
//

#import "CanvasViewController.h"
@interface CanvasViewController ()

@property (nonatomic,strong) NSArray* canvasArray;
@property (nonatomic,strong) Canvas* currentCanvas;
@property (nonatomic,strong) CanvasSetting* canvasSetting;
//color setting for canvas
@property (nonatomic,strong) UIColor* colorForCanvas;
//important pointers
@property (nonatomic) float currentCanvasIndex;
@end

@implementation CanvasViewController

@synthesize canvasArray = _canvasArray;
@synthesize currentCanvas = _currentCanvas;
@synthesize canvasSetting = _canvasSetting;
//color setting for canvas
@synthesize colorForCanvas = _colorForCanvas;
//important pointers
@synthesize currentCanvasIndex = _currentCanvasIndex;

- (NSArray*)canvasArray
{
    if (_canvasArray == nil) {
        _canvasArray = [[NSArray alloc]init];
        for (int i = 0; i < 10; i++) {
            Canvas *newCanvas = [[Canvas alloc]initWithFrame:self.view.bounds];
            newCanvas.backgroundColor = [UIColor whiteColor];
            newCanvas.tag = i + 1;
            _canvasArray = [_canvasArray arrayByAddingObject:newCanvas];
        }
    }
    return _canvasArray;
}

- (Canvas*)currentCanvas
{
    if (_currentCanvas == nil) {
        _currentCanvas = [[Canvas alloc]initWithFrame:self.view.bounds];
    }
    _currentCanvas = [self.canvasArray objectAtIndex:self.currentCanvasIndex];
    return _currentCanvas;
}

- (CanvasSetting*)canvasSetting
{
    if (_canvasSetting == nil) {
        _canvasSetting = [[CanvasSetting alloc]initWithFrame:CGRectMake(64, 0, 896, 128)];
    }
    return _canvasSetting;
}

- (UIColor*)colorForCanvas
{
    if (_colorForCanvas == nil) {
        _colorForCanvas = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return _colorForCanvas;
}

- (void)setCanvasSetting:(CanvasSetting *)canvasSetting{
    _canvasSetting = canvasSetting;
    canvasSetting.canvasSettingDelegate = self;
}

- (void)achieveNewColor
{
    self.colorForCanvas = self.canvasSetting.changedColor;
    if (self.currentCanvasIndex < self.canvasArray.count - 1) {
        self.currentCanvasIndex -= 1;
    }else{
        self.currentCanvasIndex += self.canvasArray.count - 1;
    }
    self.currentCanvas.colorForStroke = self.colorForCanvas;
    if (self.currentCanvasIndex < self.canvasArray.count - 1) {
        self.currentCanvasIndex += 1;
    }else{
        self.currentCanvasIndex -= self.canvasArray.count - 1;
    }
}

- (void)refreshSettings
{
    //test canvassetting
    [self.view addSubview:self.canvasSetting];
}

- (void)createLeftThumbnailWith:(Canvas*)canvas
{
    UIImageView* newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height / 4, self.view.bounds.size.width / 4, self.view.bounds.size.height / 2)];
    newImageView.backgroundColor = [UIColor whiteColor];
    newImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.currentCanvas.unchangableImage.image.CGImage, CGRectMake(0,0,0.5*self.currentCanvas.unchangableImage.image.size.width,self.currentCanvas.unchangableImage.image.size.height))];
    [self.view addSubview:newImageView];
}

- (void)createRightThumbnailWith:(Canvas*)canvas
{
    UIImageView* newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width / 4 * 3, self.view.bounds.size.height / 4, self.view.bounds.size.width / 4, self.view.bounds.size.height / 2)];
    newImageView.backgroundColor = [UIColor whiteColor];
    newImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.currentCanvas.unchangableImage.image.CGImage, CGRectMake(0.5*self.currentCanvas.unchangableImage.image.size.width,0,0.5*self.currentCanvas.unchangableImage.image.size.width,self.currentCanvas.unchangableImage.image.size.height))];
    [self.view addSubview:newImageView];
}

- (IBAction)testButtonPressed {
    if (self.currentCanvasIndex > 0) {
        NSMutableArray* buffer = [[NSMutableArray alloc]initWithArray:self.canvasArray];
        [buffer replaceObjectAtIndex:self.currentCanvasIndex - 1 withObject:self.currentCanvas];
        self.canvasArray = buffer.copy;
    }else{
        NSMutableArray* buffer = [[NSMutableArray alloc]initWithArray:self.canvasArray];
        [buffer replaceObjectAtIndex:self.currentCanvasIndex + self.canvasArray.count - 1 withObject:self.currentCanvas];
        self.canvasArray = buffer.copy;
    }
    
    [self refreshSettings];
    [self.view addSubview:self.currentCanvas];
    self.currentCanvas.frame = CGRectMake(self.view.bounds.size.width / 4, self.view.bounds.size.height / 4, self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.currentCanvas.colorForStroke = self.colorForCanvas;
    
    [self createLeftThumbnailWith:self.currentCanvas];
    [self createRightThumbnailWith:self.currentCanvas];
    
    if (self.currentCanvasIndex < self.canvasArray.count - 1) {
        self.currentCanvasIndex += 1;
    }else{
        self.currentCanvasIndex -= self.canvasArray.count - 1;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

