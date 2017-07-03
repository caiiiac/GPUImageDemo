//
//  ViewController.swift
//  GPUImageDemo
//
//  Created by 唐三彩 on 2017/7/3.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private lazy var image : UIImage = UIImage(named: "test")!
    
    override func viewDidLoad() {

    }

    @IBAction func didSelectedGaussianBlurFilter(_ sender: UIBarButtonItem) {
        let filter = GPUImageGaussianBlurFilter()
        // 纹理
        filter.texelSpacingMultiplier = 5
        imageView.image = processImage(filter)
    }

    @IBAction func didSelectedSketchFilter(_ sender: UIBarButtonItem) {
        let filter = GPUImageSketchFilter()
        imageView.image = processImage(filter)
    }
    
    
    private func processImage(_ filter : GPUImageFilter) -> UIImage? {
        // 2.1.如果是对图像进行处理GPUImagePicture
        let picProcess = GPUImagePicture(image: image)
        
        // 2.2.添加需要处理的滤镜
        picProcess?.addTarget(filter)
        
        // 2.3.处理图片
        filter.useNextFrameForImageCapture()
        picProcess?.processImage()
        
        // 2.4.取出最新的图片
        return filter.imageFromCurrentFramebuffer()
    }
}

