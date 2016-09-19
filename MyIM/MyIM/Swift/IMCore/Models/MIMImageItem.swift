//
//  MIMImageItem.swift
//  MyIM
//
//  Created by Jonathan on 16/5/31.
//  Copyright © 2016年 Jonathan. All rights reserved.
//

import Foundation
import UIKit
class MIMImageItem {
    var thumbUrl: String? //缩略图
    var url: String?      //原图地址
    var placeHolderImage: UIImage? //占位图或者用于发送图片
    var imageSize: CGSize? //图片大小
    
    init(thumbUrl: String, url: String, placeHolderImage: UIImage){
        self.thumbUrl = thumbUrl
        self.url = url
        self.placeHolderImage = placeHolderImage
    }
    
    init(thumbUrl: String, url: String, placeHolderImage: UIImage, imageSize: CGSize){
        self.thumbUrl = thumbUrl
        self.url = url
        self.placeHolderImage = placeHolderImage
        self.imageSize  = imageSize
    }
    
    //获得上传图片的尺寸
    class func getUploadSizeWithOriginSize(imageSize: CGSize) -> CGSize{
        let ratio           = imageSize.height / imageSize.width; //高宽比
        let maxWidth : CGFloat       = 1080.0;
        let maxHeight: CGFloat       = 1920.0;
        if (ratio <= 1) {//宽大于高
            if(imageSize.width < maxWidth){ //图片宽小于最大宽
                return imageSize;
            }
            return CGSize(width: maxWidth, height: maxWidth * ratio);
        }
        else{ //高大于宽
            if(imageSize.height < maxHeight){ //图片高小于最大高
                return imageSize;
            }
            return CGSize(width: maxHeight / ratio,height: maxHeight);
        }
    }
    
    
    //获得缩略图尺寸
    class func getMessageThumbImageSize(imageSize: CGSize) -> CGSize{
        let ratio           = imageSize.height / imageSize.width; //高宽比
        let maxWidth:CGFloat        = 540.0;
        let maxHeight:CGFloat       = 540.0;
        if (ratio <= 1) {//宽大于高
        if(imageSize.width < maxWidth){ //图片宽小于最大宽
            return imageSize;
        }
            return CGSize(width: maxWidth, height: maxWidth * ratio);
        }
        else{ //高大于宽
            if(imageSize.height < maxHeight){ //图片高小于最大高
                return CGSize(width: imageSize.width, height: imageSize.height);
            }
            return CGSize(width: maxHeight / ratio, height: maxHeight);
        }
    }
    
}