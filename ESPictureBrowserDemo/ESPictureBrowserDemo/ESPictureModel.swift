//
//  ESPictureModel.swift
//  ESPictureBrowserDemo
//
//  Created by EnjoySR on 2016/10/15.
//  Copyright © 2016年 EnjoySR. All rights reserved.
//

import UIKit

class ESPictureModel: NSObject {
    
    var thumbnailUrl: String?
    var middlePicUrl: String?
    var picUrl: String?
    var format: String?
    var cropperPosX: CGFloat = 0.0
    var cropperPosY: CGFloat = 0.0
    var width: Int = 0
    var height: Int = 0
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }

}
