//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Nathan Weller on 5/17/15.
//  Copyright (c) 2015 Nathan Weller. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    
    
    @IBOutlet weak var recordinglabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var infoLabel: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
        recordButton.enabled=true
        // hide the stopButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled=false
        if recordinglabel.hidden==true {
            recordinglabel.hidden=false
            stopButton.hidden=false
            infoLabel.hidden=true
            pauseButton.hidden=false
        }
        else {
            recordinglabel.hidden=true
        }
        println("in recordAudio")
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio=RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //recordedAudio.filePathUrl = recorder.url
            //recordedAudio.title = recorder.url.lastPathComponent
            //two lines above no longer needed thanks to initiator on line 82
            //move to scene 2 (segue) :
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            println("Recording was not successful")
            recordButton.enabled=true
            stopButton.hidden=true
        }
        
            
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "stopRecording") {
        let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
        let data = sender as! RecordedAudio
        playSoundsVC.receivedAudio = data
    }
    }
    @IBAction func pauseRecording(sender: AnyObject) {
        audioRecorder.pause()
        resumeButton.hidden=false
        recordinglabel.hidden=true
        pauseButton.hidden=true
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeButton.hidden=true
        recordinglabel.hidden=false
    }
    
    
    @IBAction func stopRecording(sender: UIButton) {
        if recordinglabel.hidden==false{
            recordinglabel.hidden=true
            stopButton.hidden=true
            infoLabel.hidden=false
        }
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

