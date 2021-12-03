//
//  ProgramScrollView.swift
//  Translator
//
//  Created by Леонид Лукашевич on 03.12.2021.
//

import Foundation
import AppKit

class ProgramScrollView: NSScrollView, StandartSubject {
    
    var observer: StandartObserver?
    private var point: CGPoint?
    
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        
        point = self.documentVisibleRect.origin
        notifyObject()
    }
    
    func addObserver(observer: StandartObserver) {
        self.observer = observer
    }
    
    func removeObserver(observer: StandartObserver) {
        self.observer = nil
    }
    
    func notifyObject() {
        guard let observer = observer,
              let point = self.point else { return }
        observer.valueChanged(point: point)
    }
}

protocol StandartObserver: AnyObject {
    func valueChanged(point: CGPoint)
}

protocol StandartSubject: AnyObject {
    func addObserver(observer: StandartObserver)
    func removeObserver(observer: StandartObserver)
    func notifyObject()
}
