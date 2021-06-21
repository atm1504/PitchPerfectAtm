//
//  RecordSoundsViewController.swift
//  PitchPerfectAtm
//
//  Created by Amartya Mondal on 18/06/21.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
        print("ViewDidLoad")
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Permitted")
                    } else {
                        // failed to record!
                        print("Not Permitted")
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("View will appear");
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        print("Recordingn in progress!")
        // Handle the states of the buttons
        recordButton.isEnabled=false
        stopRecordingButton.isEnabled=true
        recordingLabel.text="Recording in progress";
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        do {
            audioRecorder = try AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.isMeteringEnabled = true
            
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
        } catch {
            //finishRecording(success: false)
            print("Recording failed")
        }
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text="Tap to record"
        recordButton.isEnabled=true
        stopRecordingButton.isEnabled=false
        
        audioRecorder.stop()
        audioRecorder = nil
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("Recording has stopped")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording");
    }
    
}

