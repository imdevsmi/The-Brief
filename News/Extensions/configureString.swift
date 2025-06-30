//
//  configureString.swift
//  News
//
//  Created by Sami Gündoğan on 4.06.2025.
//

import Foundation

extension String {
    
    func timeAgoSinceDate() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return nil }

        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: date, to: now)

        let week = components.weekOfYear ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0

        switch true {
        case week > 0:
            return "\(week)w ago"
        case day > 0:
            return "\(day)d ago"
        case hour > 0 && minute > 0:
            return "\(hour)h \(minute)m ago"
        case hour > 0:
            return "\(hour)h ago"
        case minute > 0:
            return "\(minute)m ago"
        default:
            return "Just now"
        }
    }
    
    func formattedHourAndMinute() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
