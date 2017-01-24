//
//  AudioManager.swift
//  CircleOfChance
//
//  Created by Mac on 1/9/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioManager {
    public var backgroundMusicPlayer: AVAudioPlayer?
    public var soundEffectPlayer: AVAudioPlayer?
    
    public var SoundisPlaying: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("sound")
        }
        set(value){
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: "sound")
        }
    }
    
    public var BackgroundisPlaying: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("music")
        }
        set(value){
            NSUserDefaults.standardUserDefaults().setBool(value, forKey: "music")
        }
    }
    
    public class func sharedInstance() -> AudioManager {
        return AudioManagerInstance
    }
    
    init() {
        let sess = AVAudioSession.sharedInstance()
        if sess.otherAudioPlaying {
            _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
            _ = try? sess.setActive(true, withOptions: [])
        }
        
        if let boolexist = NSUserDefaults.standardUserDefaults().objectForKey("sound")   where
            boolexist is Bool {
                print("EXIST")
            }
        else {
            SoundisPlaying = true
        }
        
        if let boolexist = NSUserDefaults.standardUserDefaults().objectForKey("music")  where
            boolexist is Bool {
                print("Exist")
            }
        else {
            BackgroundisPlaying = true
            playBackgroundMusic("bgMusic.wav")
        }
    }
    
    public func playSoundEffect(filename: String) {
        if SoundisPlaying != false {
            let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(filename)")
                return
            }
            
            var error: NSError? = nil
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOfURL: url!)
            } catch let error1 as NSError {
                error = error1
                soundEffectPlayer = nil
            }
            if let player = soundEffectPlayer {
                player.numberOfLoops = 0
                player.prepareToPlay()
                player.play()
            } else {
                print("Could not create audio player: \(error!)")
            }
        }
    }
    
    
    public func playBackgroundMusic(filename: String) {
        if BackgroundisPlaying != false{
            let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(filename)")
                return
            }
            
            var error: NSError? = nil
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: url!)
            } catch let error1 as NSError {
                error = error1
                backgroundMusicPlayer = nil
            }
            if let player = backgroundMusicPlayer {
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            } else {
                print("Could not create audio player: \(error!)")
            }
        }
    }
    
    public func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.playing {
                player.pause()
            }
        }
    }
    
    public func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.playing {
                player.play()
            }
        }
    }
    public func playerExist() -> Bool {
        return backgroundMusicPlayer != nil
    }
}

private let AudioManagerInstance = AudioManager()
