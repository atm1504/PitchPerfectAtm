//
//  ViewController.swift
//  PitchPerfectAtm
//
//  Created by Amartya Mondal on 18/06/21.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled=false
        print("ViewDidLoad")
        // Do any additional setup after loading the view.
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
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text="Tap to record";
        // Why is the ui overlapping??
        recordButton.isEnabled=true
        stopRecordingButton.isEnabled=false
        print("Recording has stopped");
    }
    
}

