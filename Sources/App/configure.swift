import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentSQLiteProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Github service
    guard let githubAuthToken = Environment.get("GITHUB_AUTH_TOKEN") else { fatalError() }
    let githubService = GithubService(accessToken: githubAuthToken)
    services.register(githubService)
    
    // CircleCI service
    guard let circleCIAuthToken = Environment.get("CIRCLECI_AUTH_TOKEN") else { fatalError() }
    let circleCIService = CircleCIService(authToken: circleCIAuthToken)
    services.register(circleCIService)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.prepareCache(for: .sqlite)
    services.register(migrations)
}
