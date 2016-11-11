//
//  DownScanner.swift
//  Down
//
//  Created by Ruud Puts on 11/11/16.
//  Copyright © 2016 Ruud Puts. All rights reserved.
//

import AVFoundation

public class DownScanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    public var previewLayer: AVCaptureVideoPreviewLayer?
    
    open func scan(hostView: UIView) {
        guard initialize() else {
            return;
        }
        
        preparePreviewLayer(for: hostView)
        captureSession?.startRunning()
    }
    
    private func initialize() -> Bool {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            print("DownScanner: Initialized")
            
            return true
        } catch {
            print("DownScanner: Error while starting DownScanner: \(error)")
        }
        
        return false
    }
    
    private func preparePreviewLayer(for view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.frame = view.bounds;
        view.layer.addSublayer(previewLayer!)
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        NSLog("HIII")
        guard metadataObjects != nil && metadataObjects.count > 0 else {
            print("DownScanner: No QR/barcode is detected")
            return
        }
        
        let metadata = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        if let scannedText = metadata.stringValue {
            print("DownScanner: Scanned text '\(scannedText)'")
        }
        else {
            print("DownScanner: No text found")
        }
    }
    
}
