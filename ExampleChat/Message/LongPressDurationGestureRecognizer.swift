//
//  LongPressDurationGestureRecognizer.swift
//  ExampleChat
//
//  Created by Mac user on 20/08/21.
//

import Foundation
import UIKit

class LongPressDurationGestureRecognizer : UIGestureRecognizer {
        private var startTime : Date?
        private var _duration = 0.0
        public var duration : Double {
            get {
                return _duration
            }
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            startTime = Date() // now
            state = .began
            //state = .possible, if you would like the recongnizer not to fire any callback until it has ended
        }
    
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            _duration = Date().timeIntervalSince(self.startTime!)
            print("duration was \(duration) seconds")
            state = .ended
            //state = .recognized, if you would like the recongnizer not to fire any callback until it has ended
        }
 }
