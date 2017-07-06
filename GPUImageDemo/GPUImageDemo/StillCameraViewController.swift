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
    
    //高清前置摄像头
    fileprivate lazy var camera : GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)
    
    //美白滤镜
    fileprivate lazy var filter = GPUImageBrightnessFilter()
    private lazy var isPause : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupCamera()
    }

    //设置摄像头
    private func setupCamera() {
        //摄像头竖屏显示
        camera.outputImageOrientation = .portrait
        
        //设置滤镜亮度
        filter.brightness = 0.2
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
        
        guard isPause else {
            camera.capturePhotoAsImageProcessedUp(toFilter: filter) { (image, error) in
                
                //保存图片
                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                
                self.camera.pauseCapture()
                self.isPause = true
            }
            return
        }
        
        camera.resumeCameraCapture()
        isPause = false
        
    }

}
