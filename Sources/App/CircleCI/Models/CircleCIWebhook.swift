import Vapor

public struct CircleCIWebhookBackingPayload: Content {
    let buildNumber: Int
    let reponame: String
    let username: String
    
    fileprivate enum CodingKeys: String, CodingKey {
        case buildNumber = "build_num"
        case reponame
        case username
    }
}

public struct CircleCIWebhook: Content {
    public let payload: CircleCIWebhookBackingPayload
    
    public var buildNumber: Int {
        return payload.buildNumber
    }
    
    public var repoName: String {
        return payload.reponame
    }
    
    public var username: String {
        return payload.username
    }
}

//{
//    "payload": {
//        "compare": "https://github.com/vapor/routing/commit/0f5def6f03e7",
//        "previous_successful_build": {
//            "build_num": 579,
//            "status": "success",
//            "build_time_millis": 34911
//        },
//        "build_parameters": {
//            "CIRCLE_JOB": "linux"
//        },
//        "oss": true,
//        "all_commit_details_truncated": false,
//        "committer_date": "2019-02-20T18:34:42-08:00",
//        "steps": [
//        {
//        "name": "Spin up Environment",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "Spin up Environment",
//        "bash_command": null,
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-21T02:35:26.064Z",
//        "type": "test",
//        "allocation_id": "5c6e0e53ae715e0009d6561b-0-build/7F7CA9BE",
//        "output_url": "https://circle-production-action-output.s3.amazonaws.com/7623ba10009d1d5255e0e6c5-1394d284-04d3-4628-bbe2-da90b333e171-0-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T023530Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=bc274c7a103c862a88f07a9b2e19bee5a0e51d2d63d5a9bddab01fd14fc57631",
//        "start_time": "2019-02-21T02:35:01.055Z",
//        "background": false,
//        "exit_code": null,
//        "insignificant": false,
//        "canceled": null,
//        "step": 0,
//        "run_time_millis": 25009,
//        "has_output": true
//        }
//        ]
//        },
//        {
//        "name": "Checkout code",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "Checkout code",
//        "bash_command": "#!/bin/sh\nset -e\n\n# Workaround old docker images with incorrect $HOME\n# check https://github.com/docker/docker/issues/2968 for details\nif [ \"${HOME}\" = \"/\" ]\nthen\n  export HOME=$(getent passwd $(id -un) | cut -d: -f6)\nfi\n\nmkdir -p ~/.ssh\n\necho 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\nbitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\n' >> ~/.ssh/known_hosts\n\n(umask 077; touch ~/.ssh/id_rsa)\nchmod 0600 ~/.ssh/id_rsa\n(cat <<EOF > ~/.ssh/id_rsa\n$CHECKOUT_KEY\nEOF\n)\n\n# use git+ssh instead of https\ngit config --global url.\"ssh://git@github.com\".insteadOf \"https://github.com\" || true\ngit config --global gc.auto 0 || true\n\nif [ -e /root/project/.git ]\nthen\n  cd /root/project\n  git remote set-url origin \"$CIRCLE_REPOSITORY_URL\" || true\nelse\n  mkdir -p /root/project\n  cd /root/project\n  git clone \"$CIRCLE_REPOSITORY_URL\" .\nfi\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git fetch --force origin \"refs/tags/${CIRCLE_TAG}\"\nelse\n  git fetch --force origin \"circleWebhook:remotes/origin/circleWebhook\"\nfi\n\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q \"$CIRCLE_TAG\"\nelif [ -n \"$CIRCLE_BRANCH\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q -B \"$CIRCLE_BRANCH\"\nfi\n\ngit reset --hard \"$CIRCLE_SHA1\"",
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-21T02:35:27.152Z",
//        "type": "test",
//        "allocation_id": "5c6e0e53ae715e0009d6561b-0-build/7F7CA9BE",
//        "output_url": "https://circle-production-action-output.s3.amazonaws.com/0a23ba10009d1d52e6e0e6c5-1394d284-04d3-4628-bbe2-da90b333e171-101-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T023530Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=dd95ef945cefbc1879db681dfeaa3300c6465da04c4f2beae75efed29e8c4edd",
//        "start_time": "2019-02-21T02:35:26.126Z",
//        "background": false,
//        "exit_code": 0,
//        "insignificant": false,
//        "canceled": null,
//        "step": 101,
//        "run_time_millis": 1026,
//        "has_output": true
//        }
//        ]
//        },
//        {
//        "name": "swift build",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "swift build",
//        "bash_command": "#!/bin/bash -eo pipefail\nswift build",
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-21T02:35:30.128Z",
//        "type": "test",
//        "allocation_id": "5c6e0e53ae715e0009d6561b-0-build/7F7CA9BE",
//        "output_url": "https://circle-production-action-output.s3.amazonaws.com/1a23ba10009d1d52f6e0e6c5-1394d284-04d3-4628-bbe2-da90b333e171-102-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T023530Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=75163d83292727d3ae69a5a55c5451a347a590218ec8e224c6ee62977d2f77f6",
//        "start_time": "2019-02-21T02:35:27.157Z",
//        "background": false,
//        "exit_code": 0,
//        "insignificant": false,
//        "canceled": null,
//        "step": 102,
//        "run_time_millis": 2971,
//        "has_output": true
//        }
//        ]
//        },
//        {
//        "name": "swift test",
//        "actions": [
//        {
//        "truncated": false,
//        "index": 0,
//        "parallel": true,
//        "failed": null,
//        "infrastructure_fail": null,
//        "name": "swift test",
//        "bash_command": "#!/bin/bash -eo pipefail\nswift test",
//        "status": "success",
//        "timedout": null,
//        "continue": null,
//        "end_time": "2019-02-21T02:35:30.706Z",
//        "type": "test",
//        "allocation_id": "5c6e0e53ae715e0009d6561b-0-build/7F7CA9BE",
//        "start_time": "2019-02-21T02:35:30.133Z",
//        "background": false,
//        "exit_code": 0,
//        "insignificant": false,
//        "canceled": null,
//        "step": 103,
//        "run_time_millis": 573,
//        "has_output": true
//        }
//        ]
//        }
//        ],
//        "body": "",
//        "usage_queued_at": "2019-02-21T02:34:59.889Z",
//        "context_ids": [],
//        "fail_reason": null,
//        "retry_of": null,
//        "reponame": "routing",
//        "ssh_users": [],
//        "build_url": "https://circleci.com/gh/vapor/routing/580",
//        "parallel": 1,
//        "failed": false,
//        "branch": "circleWebhook",
//        "username": "vapor",
//        "author_date": "2019-02-20T18:34:42-08:00",
//        "why": "github",
//        "user": {
//            "is_user": true,
//            "login": "twof",
//            "avatar_url": "https://avatars2.githubusercontent.com/u/5561501?v=4",
//            "name": "Alex Reilly",
//            "vcs_type": "github",
//            "id": 5561501
//        },
//        "vcs_revision": "0f5def6f03e7652e2fe9fcf8526a0aa799fb2d32",
//        "workflows": {
//            "job_name": "linux",
//            "job_id": "42d459b1-9c7c-45dd-984b-8fa7bbb83d1e",
//            "workflow_id": "033534e5-8ca3-4ac8-9f8c-19d55f100e3b",
//            "workspace_id": "033534e5-8ca3-4ac8-9f8c-19d55f100e3b",
//            "upstream_job_ids": [],
//            "upstream_concurrency_map": {},
//            "workflow_name": "tests"
//        },
//        "owners": [
//          "twof"
//        ],
//        "vcs_tag": null,
//        "pull_requests": [],
//        "build_num": 580,
//        "infrastructure_fail": false,
//        "committer_email": "fabiobean2@gmail.com",
//        "has_artifacts": true,
//        "previous": null,
//        "status": "success",
//        "committer_name": "twof",
//        "retries": null,
//        "subject": "add webhook",
//        "vcs_type": "github",
//        "timedout": false,
//        "dont_build": null,
//        "lifecycle": "finished",
//        "no_dependency_cache": false,
//        "stop_time": "2019-02-21T02:35:30.714Z",
//        "ssh_disabled": true,
//        "build_time_millis": 29689,
//        "picard": {
//            "build_agent": {
//                "image": "circleci/picard:1.0.7981-23afa854",
//                "properties": {
//                    "build_agent": "1.0.7981-23afa854",
//                    "executor": "docker"
//                }
//            },
//            "resource_class": {
//                "cpu": 2,
//                "ram": 4096,
//                "class": "medium"
//            },
//            "executor": "docker"
//        },
//        "circle_yml": {
//            "string": "version: 2\n\njobs:\n  linux:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build\n      - run: swift test\n  linux-release:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift build -c release\n  linux-performance:\n    docker:\n      - image: vapor/swift:5.0\n    steps:\n      - checkout\n      - run: swift test -c release\n\nworkflows:\n  version: 2\n  tests:\n    jobs:\n      - linux\n      - linux-release\n      - linux-performance\nnotify:\n  webhooks:\n    - url: https://6a4b8e77.ngrok.io/circle\n"
//        },
//        "messages": [],
//        "is_first_green_build": false,
//        "job_name": null,
//        "start_time": "2019-02-21T02:35:01.025Z",
//        "canceler": null,
//        "all_commit_details": [
    //        {
        //        "committer_date": "2019-02-20T18:34:42-08:00",
        //        "body": "",
        //        "branch": "circleWebhook",
        //        "author_date": "2019-02-20T18:34:42-08:00",
        //        "committer_email": "fabiobean2@gmail.com",
        //        "commit": "0f5def6f03e7652e2fe9fcf8526a0aa799fb2d32",
        //        "committer_login": "twof",
        //        "committer_name": "twof",
        //        "subject": "add webhook",
        //        "commit_url": "https://github.com/vapor/routing/commit/0f5def6f03e7652e2fe9fcf8526a0aa799fb2d32",
        //        "author_login": "twof",
        //        "author_name": "twof",
        //        "author_email": "fabiobean2@gmail.com"
    //        }
//        ],
//        "platform": "2.0",
//        "outcome": "success",
//        "vcs_url": "https://github.com/vapor/routing",
//        "author_name": "twof",
//        "node": null,
//        "queued_at": "2019-02-21T02:34:59.967Z",
//        "canceled": false,
//        "author_email": "fabiobean2@gmail.com"
//    }
//}
