//
//  ZoomablePhotoView.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 30.07.15.
//

import UIKit

/// Used to wrap a single slideshow item and allow zooming on it
open class ImageSlideshowItem: UIScrollView, UIScrollViewDelegate {
    
    
    let userDevice = DeviceResize(testDeviceModel: DeviceType.IPHONE_7,userDeviceModel: (Float(ScreenSize.SCREEN_WIDTH),Float(ScreenSize.SCREEN_HEIGHT)))
    
    // test에 내꺼 넣고 user은 저렇게 가도 된다
    
    var heightRatio: CGFloat = 0.0
    var widthRatio: CGFloat = 0.0
    
    open let imageView = UIImageView()
    
    /// Input Source for the item
    open let image: InputSource
    
    /// Guesture recognizer to detect double tap to zoom
    open var gestureRecognizer: UITapGestureRecognizer?
    
    /// Holds if the zoom feature is enabled
    open let zoomEnabled: Bool
    
    /// If set to true image is initially zoomed in
    open var zoomInInitially = false
    
    fileprivate var lastFrame = CGRect.zero
    fileprivate var imageReleased = false
    
    // MARK: - Life cycle
    
    /**
     Initializes a new ImageSlideshowItem
     - parameter image: Input Source to load the image
     - parameter zoomEnabled: holds if it should be possible to zoom-in the image
     */
    init(image: InputSource, zoomEnabled: Bool) {
        self.zoomEnabled = zoomEnabled
        self.image = image
        
        super.init(frame: CGRect.null)
        
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        setPictoCenter()
        
        // scroll view configuration
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        addSubview(imageView)
        minimumZoomScale = 1.0
        maximumZoomScale = calculateMaximumScale()
        
        // tap gesture recognizer
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSlideshowItem.tapZoom))
        tapRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(tapRecognizer)
        gestureRecognizer = tapRecognizer
     
        heightRatio = userDevice.userDeviceHeight()
        widthRatio = userDevice.userDeviceWidth()
        
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if !zoomEnabled {
            
            
            imageView.frame.size.width = 257 * widthRatio
            imageView.frame.size.height = 257 * heightRatio
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = imageView.frame.size.height/2
            imageView.clipsToBounds = true
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1
        } else if !isZoomed() {
            imageView.frame.size = calculatePictureSize()
            setPictoCenter()
        }
        
        if isFullScreen() {
            clearContentInsets()
        } else {
            setPictoCenter()
        }
        
        // if self.frame was changed and zoomInInitially enabled, zoom in
        if lastFrame != frame && zoomInInitially {
            setZoomScale(maximumZoomScale, animated: false)
        }
        
        lastFrame = self.frame
        
        contentSize = imageView.frame.size
        maximumZoomScale = calculateMaximumScale()
    }
    
    /// Request to load Image Source to Image View
    func loadImage() {
        if self.imageView.image == nil {
            imageReleased = false
            image.load(to: self.imageView) { image in
                // set image to nil if there was a release request during the image load
                self.imageView.image = self.imageReleased ? nil : image
            }
        }
    }
    
    func releaseImage() {
        imageReleased = true
        self.imageView.image = nil
    }
    
    // MARK: - Image zoom & size
    
    func isZoomed() -> Bool {
        return self.zoomScale != self.minimumZoomScale
    }
    
    func zoomOut() {
        self.setZoomScale(minimumZoomScale, animated: false)
    }
    
    func tapZoom() {
        if isZoomed() {
            self.setZoomScale(minimumZoomScale, animated: true)
        } else {
            self.setZoomScale(maximumZoomScale, animated: true)
        }
    }
    
    fileprivate func screenSize() -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    fileprivate func calculatePictureFrame() {
        let boundsSize: CGSize = bounds.size
        var frameToCenter: CGRect = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        imageView.frame = frameToCenter
    }
    
    fileprivate func calculatePictureSize() -> CGSize {
        if let image = imageView.image {
            let picSize = image.size
            let picRatio = picSize.width / picSize.height
            let screenRatio = screenSize().width / screenSize().height
            
            if (picRatio > screenRatio){
                return CGSize(width: screenSize().width, height: screenSize().width / picSize.width * picSize.height)
            } else {
                return CGSize(width: screenSize().height / picSize.height * picSize.width, height: screenSize().height)
            }
        } else {
            return CGSize(width: screenSize().width, height: screenSize().height)
        }
    }
    
    fileprivate func calculateMaximumScale() -> CGFloat {
        // maximum scale is fixed to 2.0 for now. This may be overriden to perform a more sophisticated computation
        return 2.0
    }
    
    fileprivate func setPictoCenter(){
        var intendHorizon = (screenSize().width - imageView.frame.width ) / 2
        var intendVertical = (screenSize().height - imageView.frame.height ) / 2
        intendHorizon = intendHorizon > 0 ? intendHorizon : 0
        intendVertical = intendVertical > 0 ? intendVertical : 0
        contentInset = UIEdgeInsets(top: intendVertical, left: intendHorizon, bottom: intendVertical, right: intendHorizon)
    }
    
    private func isFullScreen() -> Bool {
        return imageView.frame.width >= screenSize().width && imageView.frame.height >= screenSize().height
    }
    
    func clearContentInsets() {
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: UIScrollViewDelegate
    
    open func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setPictoCenter()
    }
    
    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomEnabled ? imageView : nil;
    }
    
}


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

struct DeviceType
{
    static let IPHONE_4 = (width:Float(320.0), height:Float(480.0))
    static let IPHONE_5 = (width:Float(320.0), height:Float(568.0))
    static let IPHONE_SE = (width:Float(320.0), height:Float(568.0))
    static let IPHONE_6 = (width: Float(375.0), height:Float(667.0))
    static let IPHONE_6_P = (width: Float(414.0), height:Float(736.0))
    static let IPHONE_7 = (width: Float(375.0), height:Float(667.0))
    static let IPHONE_7_P = (width: Float(414.0), height:Float(736.0))
}



class DeviceResize {
    
    var testDevice : (width: Float, height: Float) = (width: 0,height: 0)
    var userDevice : (width: Float, height: Float) = (width: 0,height: 0)
    
    
    init(testDeviceModel: (width: Float, height: Float),userDeviceModel: (width: Float, height: Float)){
        
        testDevice = modelName(model :testDeviceModel)!
        userDevice = modelName(model :userDeviceModel)!
        
    }
    
    func modelName(model :(width: Float,height:Float)) -> (width: Float, height: Float)?{
        let modelNameList : [(width: Float, height: Float)] = [
            DeviceType.IPHONE_4,
            DeviceType.IPHONE_5,
            DeviceType.IPHONE_SE,
            DeviceType.IPHONE_6,
            DeviceType.IPHONE_6_P,
            DeviceType.IPHONE_7,
            DeviceType.IPHONE_7_P,
            ]
        for modelName in modelNameList {
            if modelName.height == model.height{
                return modelName
            }
        }
        return nil
    }
    
    func userDeviceHeight() -> CGFloat{
        
        let heightRatio = CGFloat(self.userDevice.height / self.testDevice.height)
        
        return heightRatio
    }
    
    func userDeviceWidth() -> CGFloat{
        let widthRatio = CGFloat(self.userDevice.width / self.testDevice.width)
        
        return widthRatio
    }
}


