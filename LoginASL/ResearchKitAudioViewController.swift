
import UIKit
import AVFoundation

class ResearchKitAudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var PlayBTN: UIButton!
    @IBOutlet weak var RecordBTN: UIButton!
    
    var soundRecorder : AVAudioRecorder!
    var SoundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRecorder(){
        
        
        var recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0 ] as [String : Any]
        
        var error : NSError?
        
        //soundRecorder = AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [NSObject : AnyObject], error: &error)
        soundRecorder = try? AVAudioRecorder(url: getFileURL() as URL, settings: recordSettings as [String : Any])
        
        if let err = error{
            
            NSLog("SOmething Wrong")
        }
        
        else {
            
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            
        }
        
    }
    
    
    
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as! [String]
        
        return paths[0]
        
    }
    
    func getFileURL() -> NSURL{
        let path  = getCacheDirectory() + "/" + fileName
        let filePath = NSURL(fileURLWithPath: path)
        return filePath
    }
    

    @IBAction func Record(sender: UIButton) {
        if sender.titleLabel?.text == "Record"{
            
            soundRecorder.record()
            sender.setTitle("Stop", for: .normal)
            PlayBTN.isEnabled = false
            
        }
        else{
        
            soundRecorder.stop()
            sender.setTitle("Record", for: .normal)
            PlayBTN.isEnabled = true
        }
       
    }

    @IBAction func PlaySound(sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            
            RecordBTN.isEnabled = false
            sender.setTitle("Stop", for: .normal)
            
            preparePlayer()
            let audioFile = try? Data(contentsOf: getFileURL() as URL, options:NSData.ReadingOptions.mappedIfSafe)
            //let base64String = audioFile?.base64EncodedStringWithOptions(.allZeros)
            let encodedStr = audioFile?.base64EncodedString() ?? "sad"
            print("STR: " + encodedStr)
            SoundPlayer.play()
            
        }
        else{
            
            SoundPlayer.stop()
            sender.setTitle("Play", for: .normal)
            RecordBTN.isEnabled = true
        }
        
    }
    
    func preparePlayer(){
        
        var error : NSError?
            //SoundPlayer = AVAudioPlayer(contentsOfURL: getFileURL(), error: &error)
         SoundPlayer = try? AVAudioPlayer(contentsOf: getFileURL() as URL)
        if let err = error{
            
            NSLog("sjkaldfhjakds")
        }
        else{
            
            SoundPlayer.delegate = self
            SoundPlayer.prepareToPlay()
        }
    
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        PlayBTN.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        RecordBTN.isEnabled = true
        PlayBTN.setTitle("Play", for: .normal)
    }
    
}

