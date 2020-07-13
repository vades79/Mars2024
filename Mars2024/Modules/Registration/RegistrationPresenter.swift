//
//  RegistrationPresenter.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import UIKit
import RxSwift

protocol RegistrationPresenter : class {
    var router : RegistrationRouter? { get set }
    var view : RegistrationView? { get set }
    var module : RegistrationModule? { get set }
    var personRepository: PersonRepository? { get set }
    var authProvider: AuthProvider? { get set }
    
    func didLoad()
    func submit()
    func skipRegistration()
    func setPhoto(_ photo: UIImage?)
    func update(value: String, on field: PersonFieldType)
}

class RegistrationPresenterImpl : BasePresenter<RegistrationView>, RegistrationPresenter {
    weak var module : RegistrationModule?
    weak var router : RegistrationRouter?
    
    var personRepository: PersonRepository?
    var authProvider: AuthProvider?
    
    var person: Person?
    
    var disposeBag = DisposeBag()
    var formValues = [PersonFieldType: String]()
    
    override func didLoad() {
        super.didLoad()
        view?.setLoading(true)
        personRepository?
            .person(refresh: true)
            .subscribe(
                onNext: { [weak self] (person) in
                    guard let `self` = self else {
                        return
                    }
                    self.view?.setLoading(false)
                    self.person = person
                    self._updateView()
                },
                onError: { [weak self] (error) in
                    if let apiError = error as? ApiError, apiError == .objectNotFound {
                        self?.authProvider?.deauth()
                        self?.router?.logout()
                        return
                    }
                    self?.view?.setLoading(false)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    
    func submit() {
        view?.setLoading(true)
        ValidateService.validate(formValues: formValues) { (valid, errors) in
            guard valid else {
                self.view?.setLoading(false)
                self.view?.validationErrors(errors)
                return
            }
            
            let person = convertPerson(from: formValues)
            
            if person.photo != nil {
                updateUserPic(person: person) { [weak self] (person) in
                    guard let `self` = self else {
                        return
                    }
                    
                    self.updatePerson(person: person)
                }
            } else {
                updatePerson(person: person)
            }
        }
    }
    
    func skipRegistration() {
        ValidateService.validate(formValues: formValues) { (valid, errors) in
            guard valid else {
                self.view?.setLoading(false)
                self.view?.validationErrors(errors)
                return
            }
            
            let profile = convertPerson(from: formValues)
            personRepository?
                .updatePerson(person: profile)
                .subscribe(
                    onNext: { [weak self](_) in
                        self?.view?.setLoading(false)
                        self?.router?.openMain()
                    },
                    onError: { [weak self] (error) in
                        self?.view?.setLoading(false)
                        self?.view?.show(error: error)
                })
                .disposed(by: disposeBag)
            
        }
    }
    
    // MARK: - Photo
    
    private func updateUserPic(person: Person, completion: @escaping ((Person) -> Void)) {
        guard let data = person.photo?.jpegData(compressionQuality: 0.4) else {
            completion(person)
            return
        }
        
        personRepository?
            .updateUserpic(person: person, imageData: data)
            .subscribe(
                onNext: { (profile) in
                    completion(person)
                    
            }, onError: { (error) in
                print("Error update userpic: \(error.localizedDescription)")
                completion(person)
            })
            .disposed(by: disposeBag)
    }
    
    func setPhoto(_ photo: UIImage?) {
        person?.photo = photo
    }
    
    // MARK: - Person
    
    private func updatePerson(person: Person) {
        personRepository?
            .updatePerson(person: person)
            .subscribe(
                onNext: { [weak self](_) in
                    self?.view?.setLoading(false)
                    self?.router?.openMain()
                },
                onError: { [weak self] (error) in
                    self?.view?.setLoading(false)
                    self?.view?.show(error: error)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func convertPerson(from formValues: [PersonFieldType: String]) -> Person {
        guard let person = person else {
            fatalError("Person was nil")
        }
        person.givename = formValues[.givename] ?? ""
        person.familyname = formValues[.familyname] ?? ""
        person.birthDate = formValues[.birthDate]?.toDate()
        return person
    }
    
    // MARK: - Helpers
    
    private func _updateView() {
        if let person = person {
            view?.fillTextFieldsWith(person: person)
            formValues = PersonFieldType.from(person)
        }
    }
    
    func update(value: String, on field: PersonFieldType) {
        formValues[field] = value
    }
}
