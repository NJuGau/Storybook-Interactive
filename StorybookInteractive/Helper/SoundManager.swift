//
//  SoundManager.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 20/08/24.
//

import AVFoundation

import Foundation
import UIKit

protocol SoundDelegate: NSObject, AVAudioPlayerDelegate {
    func audioDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
}

class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    public static var shared = SoundManager()
    var delegate: SoundDelegate?
    
    private var backgroundSoundPlayer: AVAudioPlayer?
    private var dialogueSoundPlayer: AVAudioPlayer?
    
    //adjust volume here
    private var backgroundVolume: Float = 0.5
    private var dialogueVolume: Float = 0.8
    
    //function to setup background sound
    func setupBackgroundSound(soundName: String) {
        if let soundAsset = NSDataAsset(name: soundName) {
            
            do {
                backgroundSoundPlayer = try AVAudioPlayer(data: soundAsset.data)
                
                backgroundSoundPlayer?.numberOfLoops = -1
                backgroundSoundPlayer?.volume = backgroundVolume
            } catch {
                print("Error initializing background sound: \(error.localizedDescription)")
            }
        } else {
            print("No sound found for: \(soundName)")
        }
    }
    
    //function to play background sound
    func playBackgroundSound() {
        if let backgroundPlayer = backgroundSoundPlayer {
            backgroundPlayer.play()
        }
    }
    
    //function to stop background sound
    func stopBackgroundSound() {
        backgroundSoundPlayer?.stop()
    }
    
    //function to setup dialogue / interactive sound
    func setupDialogueSound(soundName: String) {
        if let soundAsset = NSDataAsset(name: soundName) {
            
            do {
                dialogueSoundPlayer = try AVAudioPlayer(data: soundAsset.data)
                
                dialogueSoundPlayer?.numberOfLoops = 0
                dialogueSoundPlayer?.volume = dialogueVolume
                dialogueSoundPlayer?.delegate = self
            } catch {
                print("Error initializing background sound: \(error.localizedDescription)")
            }
        } else {
            print("No sound found for: \(soundName)")
        }
    }
    
    
    //function to play dialogue / interactive sound
    func playDialogueSound() {
        if let dialoguePlayer = dialogueSoundPlayer {
            dialoguePlayer.play()
        }
    }
    
    //function to stop dialogue / interactive sound
    func stopDialogueSound() {
        dialogueSoundPlayer?.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == dialogueSoundPlayer {
            delegate?.audioDidFinishPlaying(player, successfully: flag)
        }
    }
}
