//
//  ValidateService.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 12.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation

class ValidateService {
    class func validate(formValues: [PersonFieldType: String], _ completion: ((Bool, [PersonFieldType: RegistrationFieldError]) -> Void)) {
        
        var commonValid = true
        var errors = [PersonFieldType: RegistrationFieldError]()
        
        let validationFields = PersonFieldType.allCases
        
        for field in validationFields {
            if formValues[field] == nil && !field.isRequired() {
                continue
            }
            
            guard let value = formValues[field] else {
                commonValid = false
                errors[field] = .required
                continue
            }
            
            switch field {
            case .givename, .familyname:
                let (valid, error) = validateLiteral(value)
                commonValid = commonValid && valid
                errors[field] = error

            case .birthDate:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormatterType.default.rawValue
                let date = dateFormatter.date(from: value)!
                let legalAge = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
                if date.timeIntervalSince(legalAge) > 0 {
                    commonValid = false
                    errors[field] = .illegalAge
                }
                
            }
        }
        completion(commonValid, errors)
    }
    
    class func validateLiteral(_ value: String?) -> (Bool, RegistrationFieldError?) {
        guard let value = value, !value.isEmpty else {
            return (false, .required)
        }
        guard value.count > 2 else {
            return (false, .lessThenCharacters(count: 2))
        }
        let regex = try! NSRegularExpression(pattern: "\\w+", options: .caseInsensitive)
        let matches = regex.matches(in: value, options: [], range: NSRange(location: 0, length: value.count))
        guard !matches.isEmpty else {
            return (false, .notAlphabetic)
        }
        return  (true, nil)
    }
}
