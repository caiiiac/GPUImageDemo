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

    @IBOutlet weak var beautyViewBottomCons: NSLayoutConstraint!
    
    //MARK: - lazy
    //视频源
    fileprivate lazy var camera : GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)

    //预览图层
    fileprivate lazy var preview : GPUImageView = GPUImageView(frame: self.view.bounds)
    
    //初始化滤镜
    let bilateralFilter = GPUImageBilateralFilter()     //磨皮
    let exposureFilter = GPUImageExposureFilter()       //曝光
    let brightnessFilter = GPUImageBrightnessFilter()   //美白
    let satureationFilter = GPUImageSaturationFilter()  //饱和
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    private func setupCamera() {
        //设置camera方向
        camera?.outputImageOrientation = .portrait
        camera?.horizontallyMirrorFrontFacingCamera = true
        
        //添加预览图层
        view.insertSubview(preview, at: 0)
        
        //获取滤镜组
        let filterGroup = getGroupFilters()
        
        
        //设置GPUImage的响应链
        camera?.addTarget(filterGroup)
        filterGroup.addTarget(preview)
        
        //开始采集视频
        camera?.startCapture()
        
        camera?.delegate = self
    }
    
    //创建滤镜组
    fileprivate func getGroupFilters() -> GPUImageFilterGroup {
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

//MARK: - 事件方法
extension VideoCameraViewController {
    //切换镜头
    @IBAction func rotateCamera(_ sender: UIBarButtonItem) {
        camera?.rotateCamera()
    }
    
    //开启关闭滤镜
    @IBAction func switchBeautyEffect(_ sender: UISwitch) {
        if sender.isOn {
            camera?.removeAllTargets()
            let groups = getGroupFilters()
            camera?.addTarget(groups)
            groups.addTarget(preview)
        } else {
            camera?.removeAllTargets()
            camera?.addTarget(preview)
        }
    }
    
    //显示滤镜调整View
    @IBAction func adjustBeautyEffect(_ sender: UIBarButtonItem) {
        adjustBeautyView(constant: 0)
    }
    //完成隐藏
    @IBAction func finishedBeautyEffect(_ sender: UIButton) {
        adjustBeautyView(constant: 250)
    }
    
    private func adjustBeautyView(constant : CGFloat) {
        beautyViewBottomCons.constant = constant
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    //饱和值
    @IBAction func changeSatureation(_ sender: UISlider) {
        satureationFilter.saturation = CGFloat(sender.value * 2)
    }
    
    //美白值
    @IBAction func changeBrightness(_ sender: UISlider) {
        // - 0.5 --> 0.5
        brightnessFilter.brightness = CGFloat(sender.value) - 0.5
    }
    
    //曝光度
    @IBAction func changeExposure(_ sender: UISlider) {
        // - 2 ~ 2
        exposureFilter.exposure = CGFloat(sender.value) * 4 - 2
    }
    //磨皮
    @IBAction func changeBilateral(_ sender: UISlider) {
        bilateralFilter.distanceNormalizationFactor = CGFloat(sender.value) * 8
    }
}

//MARK: - GPUImageVideoCameraDelegate

extension VideoCameraViewController : GPUImageVideoCameraDelegate {
    func willOutputSampleBuffer(_ sampleBuffer: CMSampleBuffer!) {
        print("采集到画面")
    }
}
