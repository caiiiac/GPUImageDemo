//
//  VideoCameraViewController.swift
//  GPUImageDemo
//
//  Created by 唐三彩 on 2017/7/5.
//  Copyright © 2017年 唐三彩. All rights reserved.
//

import UIKit
import GPUImage


class VideoCameraViewController: UIViewController {

    //MARK: - lazy
    //视频源
    private lazy var camera : GPUImageVideoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)

    //预览图层
    private lazy var preview : GPUImageView = GPUImageView(frame: self.view.bounds)
    
    //初始化滤镜
    let bilateralFilter = GPUImageBilateralFilter()     //磨皮
    let exposureFilter = GPUImageExposureFilter()       //曝光
    let brightnessFilter = GPUImageBrightnessFilter()   //美白
    let satureationFilter = GPUImageSaturationFilter()  //饱和
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupCamera() {
        //设置camera方向
        camera.outputImageOrientation = .portrait
        camera.horizontallyMirrorFrontFacingCamera = true
        
        //添加预览图层
        view.insertSubview(preview, at: 0)
        
        //获取滤镜组
        let filterGroup = getGroupFilters()
        
        
        //设置GPUImage的响应链
        camera.addTarget(filterGroup)
        filterGroup.addTarget(preview)
        
        //开始采集视频
        camera.startCapture()
        
        camera.delegate = self
    }
    
    //创建滤镜组
    private func getGroupFilters() -> GPUImageFilterGroup {
        let filterGroup = GPUImageFilterGroup()
        
        //设置滤镜链接关系
        bilateralFilter.addTarget(brightnessFilter)
        brightnessFilter.addTarget(exposureFilter)
        exposureFilter.addTarget(satureationFilter)
        
        //设置group起始点 终点
        filterGroup.initialFilters = [bilateralFilter]
        filterGroup.terminalFilter = satureationFilter
        
        return filterGroup
    }
}


//MARK: - GPUImageVideoCameraDelegate

extension VideoCameraViewController : GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集到画面")
    }
}
