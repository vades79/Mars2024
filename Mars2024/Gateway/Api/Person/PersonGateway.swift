//
//  PersonGateway.swift
//  Mars2024
//
//  Created by Vladislav Mityuklyaev on 11.07.2020.
//  Copyright © 2020 Vladislav Mityuklyaev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import RxSwift

protocol PersonGateway {
    
    func loadPerson(token: String) -> Observable<Person>
    
    func createPerson(person: Person) -> Observable<Person>
    
    func deletePerson(id: String) -> Observable<Void>
    
    func updatePerson(person: Person) -> Observable<Void>

    func removeUserpic(id: String) -> Observable<Void>

    func replaceUserpic(id: String, imageData: Data) -> Observable<URL>
}

class PersonGatewayImpl: PersonGateway {
    
    func loadPerson(token: String) -> Observable<Person> {
        return Observable.create { (observer) in
            Firestore
                .firestore()
                .personCollection()
                .document(token)
                .getDocument { (snapshot, error) in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    guard let document = snapshot?.data() else {
                        observer.onError(ApiError.objectNotFound)
                        return
                    }
                    guard let dto = PersonDto(JSON: document) else {
                        observer.onError(ApiError.badResponse)
                        return
                    }
                    
                    let person = dto.toModel(id: snapshot!.documentID)
                    
                    observer.onNext(person)
            }
            
            return Disposables.create {}
        }
    }
    
    func createPerson(person: Person) -> Observable<Person> {
        return Observable.create { (observer) -> Disposable in
            let dto = PersonDto.fromModel(person)
            
//            var createDisposable: Disposable?
            var updateDisposable: Disposable?
            
            guard let id = person.id else {
                observer.onError(ApiError.badRequest)
                return Disposables.create()
            }
            
            Firestore
                .firestore()
                .personCollection()
                .document(id)
                .setData(dto.toJSON()) { (error) in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    guard let id = person.id, !id.isEmpty else {
                        observer.onError(ApiError.badRequest)
                        return
                    }

                    observer.onNext(person)
//                    createDisposable = self.loadPerson(token: id)
//                        .subscribe(
//                            onNext: { (person) in
//                                updateDisposable = self.updatePerson(person: person)
//                                    .subscribe(
//                                        onNext: { _ in
//                                            observer.onNext(person)
//                                            observer.onCompleted()
//                                    },
//                                        onError: { (error) in
//                                            observer.onError(error)
//                                    })
//                            },
//                            onError: { (error) in
//                                observer.onError(error)
//                            })
            }
            
            return Disposables.create {
//                createDisposable?.dispose()
                updateDisposable?.dispose()
            }
        }
    }
    
    func updatePerson(person: Person) -> Observable<Void> {
        let dto = PersonDto.fromModel(person)
        guard let id = person.id, !id.isEmpty else {
            return Observable.error(ApiError.badRequest)
        }
        return Observable.create { (observer) -> Disposable in
            Firestore
                .firestore()
                .personCollection()
                .document(id)
                .setData(dto.toJSON()) { (error) in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    
                    observer.onNext(())
                    observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func deletePerson(id: String) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            Firestore
                .firestore()
                .personCollection()
                .document(id)
                .delete { (error) in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }

                    observer.onNext(())
                    observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func removeUserpic(id: String) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            let storagePath = Storage.storage().userImagesPathJPEG(id: id)
            
            storagePath.delete { (error) in
                guard error == nil else {
                    let nsError = error! as NSError
                    switch nsError.code {
                    case StorageErrorCode.objectNotFound.rawValue:
                        observer.onNext(())
                        observer.onCompleted()
                    default:
                        observer.onError(error!)
                    }
                    return
                }
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func replaceUserpic(id: String, imageData: Data) -> Observable<URL> {
        return Observable.create { (observer) -> Disposable in
            
            let storagePath = Storage.storage().userImagesPathJPEG(id: id)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = storagePath.putData(imageData, metadata: metadata) { (metadata, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                guard let _ = metadata else {
                    observer.onError(ApiError.badResponse)
                    return
                }
                
                storagePath.downloadURL { (url, error) in
                    guard error == nil else {
                        observer.onError(error!)
                        return
                    }
                    guard let strongUrl = url else {
                        observer.onError(ApiError.badResponse)
                        return
                    }
                    observer.onNext(strongUrl)
                    observer.onCompleted()
                }
            }
            return Disposables.create {
                uploadTask.cancel()
            }
        }
    }
}
