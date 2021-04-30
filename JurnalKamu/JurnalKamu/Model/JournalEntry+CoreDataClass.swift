//
//  JournalEntry+CoreDataClass.swift
//  JurnalKamu
//
//  Created by Adhella Subalie on 11/04/21.
//
//

import Foundation
import CoreData

@objc(JournalEntry)
public class JournalEntry: NSManagedObject {
    
    func getDay(date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func getDayIntervalFromToday()->Int{
//        let today = Date()
//        let date = self.dateCreated!
//        var interval = today - date
//
//        if interval != 0{
//            interval /= 86400
//        }

//        return Int(interval)
        return daysBetween(start: self.getDay(date: self.dateCreated!), end: self.getDay(date: Date()))

    }
    
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }

    func getSectionTitle(isDate:Bool)->String{
        if isDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: self.dateCreated!)
        }
        let interval = self.getDayIntervalFromToday()

        if interval == 0{
            return "Hari Ini"
        }
        return "\(interval) hari yang lalu"
    }
}
