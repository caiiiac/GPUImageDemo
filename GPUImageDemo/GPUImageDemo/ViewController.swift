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

    //高斯模糊
    @IBAction func didSelectedGaussianBlurFilter(_ sender: UIBarButtonItem) {
        let filter = GPUImageGaussianBlurFilter()
        
//        filter.texelSpacingMultiplier = 15
        filter.blurRadiusInPixels = 5
        imageView.image = processImage(filter)
    }

    //素描
    @IBAction func didSelectedSketchFilter(_ sender: UIBarButtonItem) {
        let filter = GPUImageSketchFilter()
        imageView.image = processImage(filter)
    }
    
    //怀旧
    @IBAction func didSelectedSepiaFilter(_ sender: UIBarButtonItem) {
        let filter = GPUImageSepiaFilter()
        imageView.image = processImage(filter)
    }
    
    //复原
    @IBAction func didSelectedRecovery(_ sender: UIBarButtonItem) {
        imageView.image = image
    }
    
    private func processImage(_ filter : GPUImageFilter) -> UIImage? {
        // 如果是对图像进行处理GPUImagePicture
        let picProcess = GPUImagePicture(image: image)
        
        // 添加需要处理的滤镜
        picProcess?.addTarget(filter)
        
        // 处理图片
        filter.useNextFrameForImageCapture()
        picProcess?.processImage()
        
        // 取出最新的图片
        return filter.imageFromCurrentFramebuffer()
    }
}

