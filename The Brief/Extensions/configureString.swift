//
//  configureString.swift
//  The Brief
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
            return String(format: L("time_week_ago"), week)
        case day > 0:
            return String(format: L("time_day_ago"), day)
        case hour > 0 && minute > 0:
            return String(format: L("time_hour_minute_ago"), hour, minute)
        case hour > 0:
            return String(format: L("time_hour_ago"), hour)
        case minute > 0:
            return String(format: L("time_minute_ago"), minute)
        default:
            return L("time_just_now")
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
