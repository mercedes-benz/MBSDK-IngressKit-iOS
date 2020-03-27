//
//  Copyright © 2019 MBition GmbH. All rights reserved.
//

import Foundation
import RealmSwift
import MBRealmKit

public class DatabaseUserService {
	
	// MARK: Typealias
	internal typealias SaveCompletion = () -> Void
	
	public typealias BusinessModelType = ResultsUserProvider.BusinessModelType
	internal typealias DatabaseModelType = ResultsUserProvider.DatabaseModelType
	
	public typealias ChangeItem = (_ properties: [PropertyChange]) -> Void
	public typealias DeletedItems = () -> Void
	public typealias InitialItem = (BusinessModelType) -> Void
	public typealias InitialProvider = (_ provider: ResultsUserProvider) -> Void
	public typealias UpdateProvider = (_ provider: ResultsUserProvider, _ deletions: [Int], _ insertions: [Int], _ modifications: [Int]) -> Void
	
	// MARK: Properties
	private static let config = DatabaseConfig()
	private static let realm = RealmLayer<DatabaseModelType>(config: DatabaseUserService.config)
	
	
	// MARK: - Public
	
	public static func cachedUser() -> BusinessModelType? {
		
		guard let ciamId = IngressKit.loginService.token?.ciamId,
			let dbUserModel = self.item(with: ciamId) else {
				return nil
			}
		
		return DatabaseModelMapper.map(dbUserModel: dbUserModel)
	}
	
	public static func delete(method: RealmConstants.RealmWriteMethod) {
		
		switch method {
		case .async:
			guard let results = self.realm.all() else {
				return
			}
			
			self.realm.delete(results: results, method: .cascade, completion: nil)
			
		case .sync:
			self.realm.deleteAll()
		}
	}

	public static func fetch(initial: @escaping InitialProvider, update: @escaping UpdateProvider, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {

		let results = self.realm.all()
		return self.realm.observe(results: results, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (results) in
			initial(ResultsUserProvider(results: results))
		}, update: { (results, deletions, insertions, modifications) in
			update(ResultsUserProvider(results: results),
				   deletions,
				   insertions,
				   modifications)
		})
	}

	public static func item(with ciamId: String, initial: @escaping InitialItem, change: @escaping ChangeItem, deleted: DeletedItems?, error: RealmConstants.ErrorCompletion?) -> NotificationToken? {

		let item: DatabaseModelType? = self.item(with: ciamId)
		return self.realm.observe(item: item, error: { (observeError) in
			RealmLayer.handle(observeError: observeError, completion: error)
		}, initial: { (item) in
			initial(DatabaseModelMapper.map(dbUserModel: item))
		}, change: { (properties) in
			change(properties)
		}, deleted: {
			deleted?()
		})
	}

	
	// MARK: - Helper
	
	static func item(with ciamId: String) -> DatabaseModelType? {
		return self.realm.item(with: ciamId)
	}
	
	static func save(userModel: BusinessModelType, completion: @escaping SaveCompletion) {
		
		let object: DatabaseModelType = DatabaseModelMapper.map(userModel: userModel)
		self.realm.save(object: object,
						update: true,
						method: .async) {
							completion()
		}
	}
	
	static func update(adaptionValues: UserAdaptionValuesModel) {
		
		guard let ciamId = self.cachedUser()?.ciamId,
			let dbUser = self.item(with: ciamId) else {
				return
		}
		
		self.realm.edit(item: dbUser, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let adaptionValuesTupel = DatabaseModelMapper.map(userAdaptionValues: adaptionValues, dbUserAdaptionValues: item.adaptionValues ?? DBUserAdaptionValuesModel())
				item.adaptionValues = adaptionValuesTupel.model
			}
			editCompletion()
		}, completion: nil)
	}
	
	static func update(imageData: Data?, for ciamId: String?) {
		
		guard let ciamId = ciamId,
			let dbUser = self.item(with: ciamId),
			dbUser.profileImageData != imageData else {
				return
			}
		
		self.realm.edit(item: dbUser, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				item.profileImageData = imageData
			}
			editCompletion()
		}, completion: nil)
	}
	
	static func update(unitPreference: UserUnitPreferenceModel) {
		
		guard let ciamId = self.cachedUser()?.ciamId,
			let dbUser = self.item(with: ciamId) else {
				return
			}
		
		self.realm.edit(item: dbUser, method: .async, editBlock: { (_, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let userUnitPreferenceTupel = DatabaseModelMapper.map(userUnitPreferenceModel: unitPreference, dbUnitPreferenceModel: item.unitPreference ?? DBUserUnitPreferenceModel())
				item.unitPreference = userUnitPreferenceTupel.model
			}
			editCompletion()
		}, completion: nil)
	}
	
	static func update(userModel: BusinessModelType, completion: @escaping SaveCompletion) {
		
		guard let dbUser = self.item(with: userModel.ciamId) else {
			
			self.save(userModel: userModel, completion: completion)
			return
		}
		
		self.realm.edit(item: dbUser, method: .async, editBlock: { (realm, item, editCompletion) in
			
			if item.isInvalidated == false {
				
				let newItem = DatabaseModelMapper.map(userModel: userModel, dbUserModel: item)
				realm.add(newItem, update: .all)
			}
			editCompletion()
		}, completion: completion)
	}
}
