import Foundation
import CoreData
import SnackKit

protocol ILocation : IRepositoryBase {

    var _context:NSManagedObjectContext!

    func Create(location:UserLocation) -> bool
    func FindLocation()->UserLocation
    func FindAllLocations()->[UserLocation]
    func Remove(locationID:int) -> Bool
}

class LocationRepo : ILocation , RepositoryBase {


}