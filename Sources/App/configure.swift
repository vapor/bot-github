import FluentPostgreSQL
import Vapor
import VaporExt

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    Environment.dotenv(filename: ".env")
    
    // Github service
    guard let githubAuthToken: String = Environment.get("GITHUB_AUTH_TOKEN") else { fatalError() }
    let githubService = GithubService(accessToken: githubAuthToken)
    services.register(githubService)
    
    // CircleCI service
    guard let circleCIAuthToken: String = Environment.get("CIRCLECI_AUTH_TOKEN") else { fatalError() }
    let circleCIService = CircleCIService(authToken: circleCIAuthToken)
    services.register(circleCIService)
    
    // Github command router
    let githubRouter = GithubCommandRouter()
    try githubRoutes(router: githubRouter)
    services.register(githubRouter)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    let postgresql = try PostgreSQLDatabase(
        config: dbConfig(environment: Environment.detect())
    )

    /// Register the configured PostgreSQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgresql, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.prepareCache(for: .psql)
    migrations.add(model: PerformanceTestResults.self, database: .psql)
    services.register(migrations)
}

fileprivate func dbConfig(environment: Environment) throws -> PostgreSQLDatabaseConfig {
    // Configure a database
    let databaseConfig: PostgreSQLDatabaseConfig
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let password: String? = Environment.get("DATABASE_PASSWORD") ?? nil
    let databaseName: String?
    let databasePort: Int
    
    switch environment {
    case .testing:
        databasePort = Environment.get("DATABASE_PORT") ?? 5433
        databaseName = "vapor-test"
    case .production:
        guard let url: String = Environment.get("DB_POSTGRESQL") else {
            throw Abort(.internalServerError, reason: "No DB_POSTGRESQL env var set")
        }
        guard let config = PostgreSQLDatabaseConfig(url: url) else {
            throw Abort(.internalServerError, reason: "Could not create PostgreSQL config from DB_POSTGRESQL env var")
        }
        return config
    case .development:
        databaseName = Environment.get("DATABASE_DB") ?? nil
        databasePort = Environment.get("DATABASE_PORT") ?? 5432
    default:
        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        databasePort = Environment.get("DATABASE_PORT") ?? 5432
    }
    
    databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname,
        port: databasePort,
        username: username,
        database: databaseName,
        password: password
    )
    
    return databaseConfig
}
