# Configuring Your Repo To Work With This Bot
All examples in this file will use the `vapor/routing` repo as an example. Replace `routing` with the repository
name you're currently configuring.

## Tests
It is highly reccomended that you move your performance tests to a separate test case. This will make filtering and
running only performance tests from CI easier later.

The directory structure will likely look something like this:
```swift
Tests
├── LinuxMain.swift
└── RoutingKitTests
    ├── RouterPerformanceTests.swift
    └── RouterTests.swift
```

## CircleCI
A few changes will need to be made to your `circle.yml` file.

### Example `circle.yml`
```yaml
version: 2

jobs:
  linux:
    docker:
      - image: vapor/swift:5.0
    steps:
      - checkout
      - run: swift build
      - run:
          name: swift test
          command: swift test --filter "RountingKitTests.RouterTests"
  linux-release:
    docker:
      - image: vapor/swift:5.0
    steps:
      - checkout
      - run: swift build -c release
  linux-performance:
    docker:
      - image: vapor/swift:5.0
    steps:
      - checkout
      - run:
          name: swift test
          command: swift test -c release --filter "RoutingKitTests.RouterPerformanceTests"

workflows:
  version: 2
  tests:
    jobs:
      - linux
      - linux-release
notify:
  webhooks:
    - url: https://bot-gh.vapor.codes/circle
```

### Steps

1. Add the webhook to the bottom of the file.
```yml
notify:
  webhooks:
    - url: https://bot-gh.vapor.codes/circle
```
2. Create a job called `linux-performance`, but don't add it to the workflow
3. `linux-performance` should be run with `-c release`, and use the filter flag to select only performance tests
4. Any other jobs that run `swift test`, should filter to ensure they don't select performance tests
5. `linux-performance`'s test step should be titled `swift test`

## Github
On Github, you'll have to set up a couple webhooks. You can find webhook setup by navigating to the settings
page for your repo, and then selecting the webhooks tab on the left.

1. Payload URL: https://bot-gh.vapor.codes/comment  
Check "Let me select individual events"  
Uncheck "Pushes"
Check "Issue comments"  
Hit Save  
This is the webhook that will be reporting new comments to the bot and will help it listen for commands  

2. Payload URL: https://bot-gh.vapor.codes/pullRequestActivity  
Check "Let me select individual events"  
Uncheck "Pushes"  
Check "Pull requests"  
Hit Save  
This is the webhook that will be reporting merges to the bot which will help it track the master branch's   
performance over time  



With that, you should be good to go!
