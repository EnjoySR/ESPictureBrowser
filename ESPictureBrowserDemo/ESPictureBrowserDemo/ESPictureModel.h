//
//  ESPictureModel.h
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/16.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESPictureModel : NSObject

@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *smallPicUrl;
@property (nonatomic, copy) NSString *middlePicUrl;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *format;
@property (nonatomic, assign) CGFloat cropperPosX;
@property (nonatomic, assign) CGFloat cropperPosY;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

@end
