//
//  FrameHandler.swift
//  RPS_ML_Multiplayer
//
//  Created by Jakub Ruranski on 05/07/2023.
//

import Foundation
import AVFoundation
import CoreImage
import Vision

class FrameHandler: NSObject, ObservableObject{
    @Published var frame: CGImage?
    @Published var shouldStopCamera = false
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue", qos: .userInteractive)
    private let context = CIContext()
    
    
    // Vision
    
    private var request = VNDetectHumanHandPoseRequest()
    private var handPoseClassifier: RPS_ML_trained?
    //private var drawingBoxesView: DrawingBoxesView?
    @Published var result: String = ""
    
    // label prediction smoothing
    private var lastLabel: String? = nil
    private var lastLabelCount: Int = 0
    private let changeThreshold = 4  // Change this value to increase or decrease the smoothing
    
    // ----- Vision
    
    
    
    
    override init() {
        super.init()
        setupRequest()
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
            
        default:
            permissionGranted = false
        }
    }
    
    
    func requestPermission() {
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            self.permissionGranted = granted
        }
        
    }
    
    
    private func getDevice() -> AVCaptureDevice? {
        // First try the back wide angle camera
        if let device = AVCaptureDevice.default(.builtInUltraWideCamera, for: .video, position: .back) {
            return device
        }
        // If the back wide angle camera is not available, try the front one
        else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        }
        // If the wide angle cameras are not available, try the default camera
        else if let device = AVCaptureDevice.default(for: .video) {
            return device
        }
        return nil
    }

    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else {return}
        guard let videoDevice = getDevice() else {return}
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        guard captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
    
    
    
}



extension FrameHandler:  AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else {return}
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage?
    {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
//        let handler = VNImageRequestHandler(cvPixelBuffer: imageBuffer)
//        if let request = request  {
//            print("performing request")
//            try? handler.perform([request])
//        }
        handleSampleBuffer(sampleBuffer)
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
        
        return cgImage
    }
    
}

// MARK: Vision

extension FrameHandler {
    
    private func setupRequest() {
        let configuaration = MLModelConfiguration()
        print("setting the model")
        guard let classifier = try? RPS_ML_trained(configuration: configuaration) else {
            print("Failed to load model")
            return
        }
        
        handPoseClassifier = classifier
                
//        guard let visionModel = try? VNCoreMLModel(for: model) else {
//            print("Failed to create vision model")
//
//            return
//
//        }
        
//        print("model set creating request")
//        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
//        request?.imageCropAndScaleOption = .centerCrop
    }
    
   

    private func handleSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        
        do {
            try handler.perform([request])
            
            // this only if a hand is detected inside the frame
            guard let observation = request.results?.first else {
                return
            }
            
            let handPoint = try observation.recognizedPoints(.all)
            do {
                guard let handPoseClassifier = handPoseClassifier else {return}
                let output: RPS_ML_trainedOutput = try handPoseClassifier.prediction(poses: buildInputAttribute(recognizedPoints: handPoint))
                
                print(output.label)
                print(output.labelProbabilities)
                
                DispatchQueue.main.async {
                    // Update the lastLabel and its count
                    if self.lastLabel == output.label {
                        self.lastLabelCount += 1
                    } else {
                        self.lastLabel = output.label
                        self.lastLabelCount = 1
                    }
                    
                    // Only update the result if the prediction has been the same for a certain number of times
                    if !self.shouldStopCamera { // check whether the camera ml recognition is enabled
                        if self.lastLabelCount >= self.changeThreshold {
                            self.result = output.label
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
            captureSession.stopRunning()
            fatalError(error.localizedDescription)
        }
    }
    
    
    private func buildInputAttribute(recognizedPoints: [VNHumanHandPoseObservation.JointName : VNRecognizedPoint]) -> MLMultiArray {
           let attributeArray = buildRow(recognizedPoint: recognizedPoints[.wrist]) +
               buildRow(recognizedPoint: recognizedPoints[.thumbCMC]) +
               buildRow(recognizedPoint: recognizedPoints[.thumbMP]) +
               buildRow(recognizedPoint: recognizedPoints[.thumbIP]) +
               buildRow(recognizedPoint: recognizedPoints[.thumbTip]) +
               buildRow(recognizedPoint: recognizedPoints[.indexMCP]) +
               buildRow(recognizedPoint: recognizedPoints[.indexPIP]) +
               buildRow(recognizedPoint: recognizedPoints[.indexDIP]) +
               buildRow(recognizedPoint: recognizedPoints[.indexTip]) +
               buildRow(recognizedPoint: recognizedPoints[.middleMCP]) +
               buildRow(recognizedPoint: recognizedPoints[.middlePIP]) +
               buildRow(recognizedPoint: recognizedPoints[.middleDIP]) +
               buildRow(recognizedPoint: recognizedPoints[.middleTip]) +
               buildRow(recognizedPoint: recognizedPoints[.ringMCP]) +
               buildRow(recognizedPoint: recognizedPoints[.ringPIP]) +
               buildRow(recognizedPoint: recognizedPoints[.ringDIP]) +
               buildRow(recognizedPoint: recognizedPoints[.ringTip]) +
               buildRow(recognizedPoint: recognizedPoints[.littleMCP]) +
               buildRow(recognizedPoint: recognizedPoints[.littlePIP]) +
               buildRow(recognizedPoint: recognizedPoints[.littleDIP]) +
               buildRow(recognizedPoint: recognizedPoints[.littleTip])
           
           let attributeBuffer = UnsafePointer(attributeArray)
           let mlArray = try! MLMultiArray(shape: [1, 3, 21], dataType: MLMultiArrayDataType.float)
           
           mlArray.dataPointer.initializeMemory(as: Float.self, from: attributeBuffer, count: attributeArray.count)
           
           return mlArray
       }
       
       private func buildRow(recognizedPoint: VNRecognizedPoint?) -> [Float] {
           if let recognizedPoint = recognizedPoint {
               return [Float(recognizedPoint.x), Float(recognizedPoint.y), Float(recognizedPoint.confidence)]
           } else {
               return [0.0, 0.0, 0.0]
           }
       }
    
    
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let prediction = (request.results as? [VNRecognizedObjectObservation])?.first {
            DispatchQueue.main.async {
                self.result = prediction.labels.first?.description ?? "Error"
                print(self.result)
            }
        }
    }
    
}

