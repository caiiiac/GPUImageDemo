# GPUImage之直播APP的实时美颜滤镜

### 相关类
* `GPUImageVideoCamera`作为GPUImageOutput的子类,主要用来提供来自摄像头的图像数据
* `GPUImageFilter`各种滤镜效果
* `GPUImageFilterGroup`将多种滤镜添加到组中,实现多滤镜效果
* `GPUImageView `一般作为预览层,用于显示GPUImage采集到的图像

### 整个事件响应链
`GPUImageVideoCamera` -> `GPUImageFilterGroup` -> `GPUImageView`

### 实现过程
懒加载相关类
```
//视频源
fileprivate lazy var camera : GPUImageVideoCamera? = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)

//预览图层
fileprivate lazy var preview : GPUImageView = GPUImageView(frame: self.view.bounds)

//初始化滤镜
let bilateralFilter = GPUImageBilateralFilter()     //磨皮
let exposureFilter = GPUImageExposureFilter()       //曝光
let brightnessFilter = GPUImageBrightnessFilter()   //美白
let satureationFilter = GPUImageSaturationFilter()  //饱和
```
创建滤镜组GPUImageFilterGroup
```
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
```
设置GPUImageVideoCamera相关属性并将GPUImageFilterGroup添加到响应链
```
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
}
```

> 注意事项

* 必须使用真机调试
* 在info.plist中设置调起相机,图库,麦克风的相关权限
 * Privacy - Camera Usage Description
 * Privacy - Photo Library Usage Description
 * Privacy - Microphone Usage Description

[Demo地址](https://github.com/caiiiac/GPUImageDemo)

> Demo扩展说明:

* 可切换前后镜头
* 滤镜的开关和相关数值可以通过点击Edit按钮调整
* Stop,Play按钮用于保存录制的视频并播放,需要先Stop再Play
