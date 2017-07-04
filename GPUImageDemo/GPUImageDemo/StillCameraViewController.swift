//
//  StillCameraViewController.swift
//  GPUImageDemo
//
//  Created by 唐三彩 on 2017/7/4.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import GPUImage


class StillCameraViewController: UIViewController {

    @IBOutlet weak var imageVIew: UIImageView!
    
    //高清前置摄像头
    fileprivate lazy var camera : GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)
    
    //美白/曝光滤镜
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //摄像头竖屏显示
        camera.outputImageOrientation = .portrait
        
        //设置滤镜曝光度
        filter.brightness = 0.3
        //添加滤镜
        camera.addTarget(filter)
        
        //创建GPUImageView,用于显示实时画面
        let showView = GPUImageView(frame: view.bounds)
        view.insertSubview(showView, at: 0)
        filter.addTarget(showView)
        
        
        //开始捕捉画面
        camera.startCapture()
        
    }

    
    /// 拍照事件,保存图片到图库
    ///
    /// - Parameter sender: UIButton
    @IBAction func takePhoto(_ sender: UIButton) {
        camera.capturePhotoAsImageProcessedUp(toFilter: filter) { (image, error) in
            
            //保存图片
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            self.imageVIew.image = image
            
            self.camera.stopCapture()
        }
    }

}
