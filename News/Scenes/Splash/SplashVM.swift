//
//  SplashVM.swift
//  News
//
//  Created by Sami Gündoğan on 18.05.2025.
//

import Foundation

protocol SplashVMProtocol: AnyObject {
    func splashScreen()
}

final class SplashVM: SplashVMProtocol {
    
    weak var output: SplashVMProtocol?
    weak var input: SplashVMProtocol?
    
    init() { input = self }
    
    func splashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.output?.splashScreen()
        }
    }
}
