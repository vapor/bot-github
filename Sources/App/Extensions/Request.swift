import Vapor

public extension Request {
    func cacheContains<D: Database & KeyedCacheSupporting>(
        key: String,
        databaseIdentifier: DatabaseIdentifier<D>
        ) throws -> Future<Bool> {
        return try self
            .keyedCache(for: databaseIdentifier)
            .get(key, as: Bool.self)
            .map { val -> Bool in
                return val != nil
        }
    }
}
