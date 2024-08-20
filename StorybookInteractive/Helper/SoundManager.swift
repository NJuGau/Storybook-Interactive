//
//  SoundManager.swift
//  StorybookInteractive
//
//  Created by Nathanael Juan Gauthama on 20/08/24.
//

import AVFoundation

import Foundation
import UIKit

class SoundManager {
    
    public static var shared = SoundManager()
    
    private var backgroundSoundPlayer: AVAudioPlayer?
    private var dialogueSoundPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer? // MARK: for sound effect, I'll add corresponding function if needed
    
    //function to setup background sound
    func setupBackgroundSound(soundName: String) {
        if let soundAsset = NSDataAsset(name: soundName) {
            
            do {
                backgroundSoundPlayer = try AVAudioPlayer(data: soundAsset.data)
                
                backgroundSoundPlayer?.numberOfLoops = -1
                backgroundSoundPlayer?.volume = 0.5
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
                
                dialogueSoundPlayer?.numberOfLoops = 1
                dialogueSoundPlayer?.volume = 0.8
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
}
