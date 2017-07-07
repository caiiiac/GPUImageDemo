# GPUImage之美颜相机

### 相关类
* `GPUImageStillCamera`是GPUImageVideoCamera的子类,两者的作用都是提供来自摄像头的图像数据,区别如下:
 * GPUImageStillCamera - 摄像头-照相(今天要用到的就是这个)
 * GPUImageVideoCamera - 摄像头-视频流

* `GPUImageFilter`的作用是添加各种滤镜
* `GPUImageView `一般作为预览层,用于显示GPUImage采集到的图像

### 整个事件响应链
`GPUImageStillCamera` -> `GPUImageFilter` -> `GPUImageView`
### 实现过程
懒加载摄像头,滤镜相关对象
```
//高清前置摄像头
fileprivate lazy var camera : GPUImageStillCamera = GPUImageStillCamera(sessionPreset: AVCaptureSessionPresetHigh, cameraPosition: .front)
//美白滤镜
fileprivate lazy var filter = GPUImageBrightnessFilter()
```
设置摄像头,滤镜相关属性
```
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
```
实现拍照按钮点击事件,保存图片到图库
```
camera.capturePhotoAsImageProcessedUp(toFilter: filter) { (image, error) in     
        //保存图片
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)    
        self.camera.stopCapture()
}
```
> 注意事项

* 必须使用真机调试
* 在info.plist中设置调起相机,图库的相关权限
 * Privacy - Camera Usage Description
 * Privacy - Photo Library Usage Description