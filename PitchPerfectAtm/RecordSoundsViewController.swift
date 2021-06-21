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
    
    let STOP_RECORDING_SEGUE_IDENTIFIER = "stopRecording"
    
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
            print("Failed to record")
        }
    }
    
    func toggleViews(mode : Bool){
        recordButton.isEnabled = !mode
        stopRecordingButton.isEnabled = mode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        print("View will appear");
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        print("Recording in progress!")
        toggleViews(mode: true)
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
        
        toggleViews(mode: false)
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("Recording has stopped")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: STOP_RECORDING_SEGUE_IDENTIFIER, sender: audioRecorder.url)
            print("Finished recording successfully");
        }else{
            print("Recording failed to save")
        }
        audioRecorder = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == STOP_RECORDING_SEGUE_IDENTIFIER{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
