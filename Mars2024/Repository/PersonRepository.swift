//
//  PersonRepository.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import RxSwift

protocol PersonRepository {
    
    init(gateway: PersonGateway, authProvider: AuthProvider, personStorage: PersonStorage)
    
    func person(refresh: Bool) -> Observable<Person>
    
    func touchPerson() -> Observable<Person>
    
    func updatePerson(person: Person) -> Observable<Person>
    
    func updateUserpic(person: Person, imageData: Data?) -> Observable<Person>
}

class PersonRepositoryImpl: PersonRepository {
    
    let gateway: PersonGateway
    let authProvider: AuthProvider
    let personStorage: PersonStorage
    
    required init(gateway: PersonGateway, authProvider: AuthProvider, personStorage: PersonStorage) {
        self.gateway = gateway
        self.authProvider = authProvider
        self.personStorage = personStorage
    }
    
    func person(refresh: Bool) -> Observable<Person> {
        let presavedPerson = self.personStorage.read()
        
        if let person = presavedPerson, !refresh {
            return Observable.just(person)
        }
        
        guard authProvider.isAuth, let token = authProvider.token else {
            return Observable.error(PersonError.unauthorized)
        }
        
        return gateway.loadPerson(token: token).map ({ (person) in
            self.personStorage.write(person)
            return person
        })
    }
    
    func touchPerson() -> Observable<Person> {
        guard let token = authProvider.token else {
            return Observable.error(PersonError.unauthorized)
        }
        return Observable.create { (observer) -> Disposable in
            
            var createDisposable: Disposable?
            let loadDisposable = self.gateway
                .loadPerson(token: token)
                .subscribe(
                    onNext: { (person) in
                        self.personStorage.write(person)
                        observer.onNext(person)
                        observer.onCompleted()
                },
                    onError: { (error) in
                        switch error {
                        case ApiError.objectNotFound:
                            let person = Person()
                            person.id = token
                            createDisposable = self.gateway
                                .createPerson(person: person)
                                .subscribe(
                                    onNext: { (person) in
                                        self.personStorage.write(person)
                                        observer.onNext(person)
                                        observer.onCompleted()
                                    },
                                    onError: { (error) in
                                        observer.onError(error)
                                    })
                        default:
                            observer.onError(error)
                        }
                })
            
            return Disposables.create {
                loadDisposable.dispose()
                createDisposable?.dispose()
            }
        }
    }
    
    func updatePerson(person: Person) -> Observable<Person> {
        guard authProvider.isAuth, let token = authProvider.token else {
            return Observable.error(PersonError.unauthorized)
        }
        guard person.id == token else {
            return Observable.error(PersonError.accessDenied)
        }
        
        return gateway.updatePerson(person: person).map { (_) in
            self.personStorage.write(person)
            return person
        }
    }
    
    func updateUserpic(person: Person, imageData: Data?) -> Observable<Person> {
        
        guard authProvider.isAuth, let token = authProvider.token else {
            return Observable.error(PersonError.unauthorized)
        }
        
        return Observable.create { (observer) -> Disposable in
            
            var uploadSubscriver: Disposable?
            var updateSubscriber: Disposable?
            
            let personBlock = { (person: Person) in
                updateSubscriber = self.gateway
                    .updatePerson(person: person)
                    .subscribe(
                        onNext: { (_) in
                            self.personStorage.write(person)
                            observer.onNext( person )
                            observer.onCompleted()
                        },
                        onError: { (error) in
                            observer.onError(error)
                        })
            }
            
            // Upload new avatar
            if let data = imageData {
                uploadSubscriver = self.gateway
                    .replaceUserpic(id: token, imageData: data)
                    .subscribe(
                        onNext: { (url) in
                            person.photoUrl = url
                            personBlock(person)
                            
                        },
                        onError: { (error) in
                            observer.onError(error)
                        })
            } else {
                // Remove avatar
                uploadSubscriver = self.gateway
                    .removeUserpic(id: token)
                    .subscribe(
                        onNext: { (_) in
                            person.photoUrl = nil
                            personBlock(person)
                        },
                        onError: { (error) in
                            observer.onError(error)
                        })
            }
         
            return Disposables.create {
                updateSubscriber?.dispose()
                uploadSubscriver?.dispose()
            }
        }
    }
}

