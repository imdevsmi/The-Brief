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
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear], from: date, to: now)

        if let week = components.weekOfYear, week > 0 {
            return "\(week)w ago"
        } else if let day = components.day, day > 0 {
            return "\(day)d ago"
        } else if let hour = components.hour, hour > 0 {
            let minute = components.minute ?? 0
            return minute > 0 ? "\(hour)h \(minute)m ago" : "\(hour)h ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        } else {
            return "Just now"
        }
    }

    func formattedHourAndMinute() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: self) else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
