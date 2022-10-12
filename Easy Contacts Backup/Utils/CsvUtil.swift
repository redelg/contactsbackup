//
//  CsvUtil.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 20/09/22.
//

import Contacts
import Foundation

struct CsvUtil {
    
    static func getColumns(_ contacts: [CNContact]) -> ([String], [String], [String], [String]) {
        var columns = [String]()
        
        columns.append("First Name")
        columns.append("Last Name")
        
        var phoneColumns = [String]()
        var emailColumns = [String]()
        var urlColumns = [String]()
        for contact in contacts {
            phoneColumns.append(contentsOf: getPhoneNumber(contact))
            emailColumns.append(contentsOf: getEmails(contact))
            urlColumns.append(contentsOf: getUrls(contact))
        }
        let phoneColumnSet = Set(phoneColumns)
        columns.append(contentsOf: phoneColumnSet)
        let emailSet = Set(emailColumns)
        columns.append(contentsOf: emailSet)
        let urlSet = Set(urlColumns)
        columns.append(contentsOf: urlSet)
        
        columns.append("Company")
        columns.append("Address")
        columns.append("Birthday")
        
        return (columns, Array(phoneColumnSet), Array(emailSet), Array(urlSet))
    }
    
    static func getCsvString(_ contacts: [CNContact]) -> String {
        let (columns, phoneColumns, emailColumns, urlColumns) = getColumns(contacts)
        var csvString = columns.joined(separator: ",") + "\n"
        
        for contact in contacts {
            var row = [String]()
            
            row.append(contact.givenName)
            row.append(contact.familyName)
            row.append(contentsOf: getPhoneNumberRow(contact, phoneColumns))
            row.append(contentsOf: getEmailRow(contact, emailColumns))
            row.append(contentsOf: getUrlRow(contact, urlColumns))
            row.append(contact.organizationName)
            row.append(getAddress(contact))
            row.append(getBirthDay(contact))

            csvString += row.joined(separator: ",") + "\n"
        }
        
        return csvString
    }
    
    // MARK: ROWS
    
    private static func getAddress(_ contact: CNContact) -> String {
        var fullAddess = [String]()
        
        let address = contact.postalAddresses.count > 0 ? "\(contact.postalAddresses[0].value.street)" : ""
        fullAddess.append(address)
        
        let city = contact.postalAddresses.count > 0 ? "\(contact.postalAddresses[0].value.city)" : ""
        fullAddess.append(city)
        
        let state = contact.postalAddresses.count > 0 ? "\(contact.postalAddresses[0].value.state)" : ""
        fullAddess.append(state)
        
        let zipCode = contact.postalAddresses.count > 0 ? "\(contact.postalAddresses[0].value.postalCode)" : ""
        fullAddess.append(zipCode)
        
        let country = contact.postalAddresses.count > 0 ? "\(contact.postalAddresses[0].value.country)" : ""
        fullAddess.append(country)
        
        return fullAddess.isEmpty ? "" : "\"\(fullAddess.filter { $0 != "" }.joined(separator: ","))\""
    }
    
    private static func getBirthDay(_ contact: CNContact) -> String {
        var birthDayString = ""
        
        if let date = contact.birthday?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            birthDayString = formatter.string(from: date)
        }
        
        return birthDayString
    }
    
    private static func getPhoneNumberRow(_ contact: CNContact, _ phoneColumns: [String]) -> [String] {
        var phoneRow = [String]()
        var phoneDict: [String: String] = [:]
        for phoneNumber in contact.phoneNumbers {
            if let label = phoneNumber.label {
                phoneDict["Phone Number (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))"] = phoneNumber.value.stringValue
            }
        }
        for phoneColumn in phoneColumns {
            phoneRow.append(phoneDict[phoneColumn] ?? "")
        }
        return phoneRow
    }
    
    private static func getEmailRow(_ contact: CNContact, _ emailColumns: [String]) -> [String] {
        var emailRow = [String]()
        var emailDict: [String: String] = [:]
        for email in contact.emailAddresses {
            if let label = email.label {
                emailDict["Email (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))"] = email.value as String
            }
        }
        for emailColumn in emailColumns {
            emailRow.append(emailDict[emailColumn] ?? "")
        }
        return emailRow
    }
    
    private static func getUrlRow(_ contact: CNContact, _ urlColumns: [String]) -> [String] {
        var urlRow = [String]()
        var urlDict: [String: String] = [:]
        for url in contact.urlAddresses {
            if let label = url.label {
                urlDict["Url (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))"] = url.value as String
            }
        }
        for urlColumn in urlColumns {
            urlRow.append(urlDict[urlColumn] ?? "")
        }
        return urlRow
    }
    
    // MARK: HEADERS
    
    private static func getPhoneNumber(_ contact: CNContact) -> [String] {
        var headers = Set<String>()
        for phoneNumber in contact.phoneNumbers {
            if let label = phoneNumber.label {
                headers.insert("Phone Number (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))")
            }
        }
        return Array(headers)
    }
    
    private static func getEmails(_ contact: CNContact) -> [String] {
        var headers = Set<String>()
        for email in contact.emailAddresses {
            if let label = email.label {
                headers.insert("Email (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))")
            }
        }
        return Array(headers)
    }
    
    private static func getUrls(_ contact: CNContact) -> [String] {
        var headers = Set<String>()
        for urls in contact.urlAddresses {
            if let label = urls.label {
                headers.insert("Url (\(CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)))")
            }
        }
        return Array(headers)
    }
    
}
