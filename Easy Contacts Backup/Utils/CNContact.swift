//
//  CNContact.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 24/09/22.
//

import Foundation
import Contacts

extension CNContact {
    
    func toNewContact() -> CNContact {
        let newContact = CNMutableContact()
        newContact.contactType = contactType
        newContact.namePrefix = namePrefix
        newContact.givenName = givenName
        newContact.middleName = middleName
        newContact.familyName = familyName
        newContact.previousFamilyName = previousFamilyName
        newContact.nameSuffix = nameSuffix
        newContact.nickname = nickname
        newContact.organizationName = organizationName
        newContact.departmentName = departmentName
        newContact.jobTitle = jobTitle
        newContact.phoneticGivenName = phoneticGivenName
        newContact.phoneticMiddleName = phoneticMiddleName
        newContact.phoneticFamilyName = phoneticFamilyName
        newContact.phoneticOrganizationName = phoneticOrganizationName
        newContact.imageData = imageData
        newContact.phoneNumbers = phoneNumbers
        newContact.emailAddresses = emailAddresses
        newContact.postalAddresses = postalAddresses
        newContact.urlAddresses = urlAddresses
        newContact.contactRelations = contactRelations
        newContact.socialProfiles = socialProfiles
        newContact.instantMessageAddresses = instantMessageAddresses
        newContact.birthday = birthday
        return newContact
    }
    
}
