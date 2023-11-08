//
//  Keys.swift
//  Easy Contacts Backup
//
//  Created by Renzo Delgado on 19/09/22.
//

import Contacts 
import ContactsUI

enum CNContactKeys {
    static let keysToFetch: [CNKeyDescriptor] = {
        [CNContactIdentifierKey, CNContactTypeKey, CNContactPropertyAttribute,
         CNContactNamePrefixKey, CNContactGivenNameKey, CNContactMiddleNameKey,
         CNContactFamilyNameKey, CNContactPreviousFamilyNameKey, CNContactNameSuffixKey,
         CNContactNicknameKey, CNContactPhoneticGivenNameKey, CNContactPhoneticMiddleNameKey,
         CNContactPhoneticFamilyNameKey, CNContactJobTitleKey, CNContactDepartmentNameKey,
         CNContactOrganizationNameKey, CNContactPhoneticOrganizationNameKey, CNContactPostalAddressesKey,
         CNContactEmailAddressesKey, CNContactUrlAddressesKey, CNContactInstantMessageAddressesKey,
         CNContactPhoneNumbersKey, CNContactSocialProfilesKey, CNContactBirthdayKey, CNContactDatesKey,
         CNContactImageDataKey, CNContactThumbnailImageDataKey, CNContactImageDataAvailableKey,
         CNContactRelationsKey, CNGroupNameKey, CNGroupIdentifierKey, CNContainerNameKey,
         CNContainerTypeKey, CNInstantMessageAddressServiceKey, CNInstantMessageAddressUsernameKey,
         CNSocialProfileServiceKey, CNSocialProfileURLStringKey, CNSocialProfileUsernameKey,
         CNSocialProfileUserIdentifierKey,
         CNContactVCardSerialization.descriptorForRequiredKeys(),
         CNContactViewController.descriptorForRequiredKeys()]  as? [CNKeyDescriptor] ?? []
    }()
}
