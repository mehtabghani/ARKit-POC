//
//  TouchHandler.swift
//  ARTestApp
//
//  Created by Mehtab on 23/04/2018.
//  Copyright © 2018 Mehtab. All rights reserved.
//

import Foundation

class TouchHandler {
    let timerInterval:Double = 0.1
    var _maneuvering: Timer?
    var _event: (() -> Void)?
    
    
    func startTimer() {
        _maneuvering = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(move), userInfo: nil, repeats: true)
    }
    
    func cancelTimer () {
        _maneuvering?.invalidate()
    }
    
    @objc func move() {

        guard let event = self._event else {
            return
        }
        
        event()
        
        print("moving")
    }
    
    func onTouchBegan(event: @escaping ()->Void) {
        _event = event
        self.startTimer()
    }
    
    func onTouchEnd(event: ()->Void) {
        cancelTimer()
        print("moving stoped")
        event()
    }
    
}
