//
//  Gesture.swift
//  ExampleChat
//
//  Created by Mac user on 21/08/21.
//

import Foundation
import UIKit

//protocol GesutreDelegate {
//
//    func onStart()
//    func onEnd()
//}
//
//
//class iGesutreRecognizer: UIGestureRecognizer {
//    var gestureDelegate: GesutreDelegate?
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
//        print("touchesBegan")
//        gestureDelegate?.onStart()
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
//        print("touchesEnded")
//        gestureDelegate?.onEnd()
//    }
//}


class ButtonGestureRecognizer: UIGestureRecognizer {

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    //
    state = .began
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    //
    state = .ended
  }
}
