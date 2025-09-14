//
//  Localization.swift
//  News
//
//  Created by Sami Gündoğan on 14.09.2025.
//

import Foundation

func L(_ key: String) -> String {
    let lang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    guard let path = Bundle.main.path(forResource: lang, ofType: "lproj"),
          let bundle = Bundle(path: path) else { return key }
    return NSLocalizedString(key, bundle: bundle, comment: "")
}
