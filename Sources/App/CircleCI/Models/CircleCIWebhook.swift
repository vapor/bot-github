import Vapor

public struct CircleCIWebhook: Content {
    
    //{
    //    "payload": {
    //        "compare": null,
    //        "previous_successful_build": {
    //            "build_num": 11,
    //            "status": "success",
    //            "build_time_millis": 6192
    //        },
    //        "build_parameters": {
    //            "CIRCLE_JOB": "build"
    //        },
    //        "oss": true,
    //        "all_commit_details_truncated": false,
    //        "committer_date": "2019-02-20T17:49:07-08:00",
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
        //        "end_time": "2019-02-21T01:49:19.255Z",
        //        "type": "test",
        //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
        //        "output_url": "https://circle-production-action-output.s3.amazonaws.com/1db15d1000a5ad5bd930e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-0-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T014925Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=b0c0c0d9776b82f210a0228b2eecf97cba6ae1bd97b2e618daa65ac666ba2588",
        //        "start_time": "2019-02-21T01:49:17.501Z",
        //        "background": false,
        //        "exit_code": null,
        //        "insignificant": false,
        //        "canceled": null,
        //        "step": 0,
        //        "run_time_millis": 1754,
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
    //        "bash_command": "#!/bin/sh\nset -e\n\n# Workaround old docker images with incorrect $HOME\n# check https://github.com/docker/docker/issues/2968 for details\nif [ \"${HOME}\" = \"/\" ]\nthen\n  export HOME=$(getent passwd $(id -un) | cut -d: -f6)\nfi\n\nmkdir -p ~/.ssh\n\necho 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==\nbitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==\n' >> ~/.ssh/known_hosts\n\n(umask 077; touch ~/.ssh/id_rsa)\nchmod 0600 ~/.ssh/id_rsa\n(cat <<EOF > ~/.ssh/id_rsa\n$CHECKOUT_KEY\nEOF\n)\n\n# use git+ssh instead of https\ngit config --global url.\"ssh://git@github.com\".insteadOf \"https://github.com\" || true\ngit config --global gc.auto 0 || true\n\nif [ -e /home/circleci/repo/.git ]\nthen\n  cd /home/circleci/repo\n  git remote set-url origin \"$CIRCLE_REPOSITORY_URL\" || true\nelse\n  mkdir -p /home/circleci/repo\n  cd /home/circleci/repo\n  git clone \"$CIRCLE_REPOSITORY_URL\" .\nfi\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git fetch --force origin \"refs/tags/${CIRCLE_TAG}\"\nelse\n  git fetch --force origin \"master:remotes/origin/master\"\nfi\n\n\nif [ -n \"$CIRCLE_TAG\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q \"$CIRCLE_TAG\"\nelif [ -n \"$CIRCLE_BRANCH\" ]\nthen\n  git reset --hard \"$CIRCLE_SHA1\"\n  git checkout -q -B \"$CIRCLE_BRANCH\"\nfi\n\ngit reset --hard \"$CIRCLE_SHA1\"",
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:20.011Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "output_url": "https://circle-production-action-output.s3.amazonaws.com/4db15d1000a5ad5bf930e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-101-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T014925Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=12c1871f44876bbdb7fb8d21a6fc31323ee70c49b1ac5d226b5c8583390cf386",
    //        "start_time": "2019-02-21T01:49:19.332Z",
    //        "background": false,
    //        "exit_code": 0,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 101,
    //        "run_time_millis": 679,
    //        "has_output": true
    //        }
    //        ]
    //        },
    //        {
    //        "name": "Restoring Cache",
    //        "actions": [
    //        {
    //        "truncated": false,
    //        "index": 0,
    //        "parallel": true,
    //        "failed": null,
    //        "infrastructure_fail": null,
    //        "name": "Restoring Cache",
    //        "bash_command": null,
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:22.228Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "output_url": "https://circle-production-action-output.s3.amazonaws.com/9db15d1000a5ad5b0a30e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-102-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T014925Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=723deabb770ae0b9295ff2cdb3caf5a2d106cd4dfbb64adcad13089defe6331d",
    //        "start_time": "2019-02-21T01:49:20.016Z",
    //        "background": false,
    //        "exit_code": null,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 102,
    //        "run_time_millis": 2212,
    //        "has_output": true
    //        }
    //        ]
    //        },
    //        {
    //        "name": "install dependencies",
    //        "actions": [
    //        {
    //        "truncated": false,
    //        "index": 0,
    //        "parallel": true,
    //        "failed": null,
    //        "infrastructure_fail": null,
    //        "name": "install dependencies",
    //        "bash_command": "#!/bin/bash -eo pipefail\npython3 -m venv venv\n. venv/bin/activate\npip install -r requirements.txt\n",
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:24.295Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "start_time": "2019-02-21T01:49:22.233Z",
    //        "background": false,
    //        "exit_code": 0,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 103,
    //        "run_time_millis": 2062,
    //        "has_output": true
    //        }
    //        ]
    //        },
    //        {
    //        "name": "Saving Cache",
    //        "actions": [
    //        {
    //        "truncated": false,
    //        "index": 0,
    //        "parallel": true,
    //        "failed": null,
    //        "infrastructure_fail": null,
    //        "name": "Saving Cache",
    //        "bash_command": null,
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:24.323Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "output_url": "https://circle-production-action-output.s3.amazonaws.com/aeb15d1000a5ad5b4a30e6c5-9d696e9c-958f-40a3-9ce4-b75c5a7b1768-104-0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20190221T014925Z&X-Amz-SignedHeaders=host&X-Amz-Expires=431999&X-Amz-Credential=AKIAIQ65EYQDTMSJK2DQ%2F20190221%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=571685b66e8871699b8497b01a3b86d218573342c90dd0affbdd560e7c691a1d",
    //        "start_time": "2019-02-21T01:49:24.301Z",
    //        "background": false,
    //        "exit_code": null,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 104,
    //        "run_time_millis": 22,
    //        "has_output": true
    //        }
    //        ]
    //        },
    //        {
    //        "name": "run tests",
    //        "actions": [
    //        {
    //        "truncated": false,
    //        "index": 0,
    //        "parallel": true,
    //        "failed": null,
    //        "infrastructure_fail": null,
    //        "name": "run tests",
    //        "bash_command": "#!/bin/bash -eo pipefail\n. venv/bin/activate\npython manage.py test\n",
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:24.945Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "start_time": "2019-02-21T01:49:24.329Z",
    //        "background": false,
    //        "exit_code": 0,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 105,
    //        "run_time_millis": 616,
    //        "has_output": false
    //        }
    //        ]
    //        },
    //        {
    //        "name": "Uploading artifacts",
    //        "actions": [
    //        {
    //        "truncated": false,
    //        "index": 0,
    //        "parallel": true,
    //        "failed": null,
    //        "infrastructure_fail": null,
    //        "name": "Uploading artifacts",
    //        "bash_command": null,
    //        "status": "success",
    //        "timedout": null,
    //        "continue": null,
    //        "end_time": "2019-02-21T01:49:24.969Z",
    //        "type": "test",
    //        "allocation_id": "5c6e039caf595a00084a0e5e-0-build/D07984F",
    //        "start_time": "2019-02-21T01:49:24.955Z",
    //        "background": false,
    //        "exit_code": null,
    //        "insignificant": false,
    //        "canceled": null,
    //        "step": 106,
    //        "run_time_millis": 14,
    //        "has_output": true
    //        }
    //        ]
    //        }
    //        ],
    //        "body": "",
    //        "usage_queued_at": "2019-02-21T01:49:16.203Z",
    //        "context_ids": [],
    //        "fail_reason": null,
    //        "retry_of": null,
    //        "reponame": "FlaskOnAWS",
    //        "ssh_users": [],
    //        "build_url": "https://circleci.com/gh/twof/FlaskOnAWS/12",
    //        "parallel": 1,
    //        "failed": false,
    //        "branch": "master",
    //        "username": "twof",
    //        "author_date": "2019-02-20T17:49:07-08:00",
    //        "why": "github",
    //        "user": {
    //            "is_user": true,
    //            "login": "twof",
    //            "avatar_url": "https://avatars2.githubusercontent.com/u/5561501?v=4",
    //            "name": "Alex Reilly",
    //            "vcs_type": "github",
    //            "id": 5561501
    //        },
    //        "vcs_revision": "c8e8bfd2f3f180696aa4d1465656ac24c99c8f35",
    //        "workflows": {
    //            "job_name": "build",
    //            "job_id": "910ef3a1-9a26-4a2e-ab99-45413e075ca5",
    //            "workflow_id": "df683fc4-0a48-4bd8-84f5-64f4735d2cce",
    //            "workspace_id": "df683fc4-0a48-4bd8-84f5-64f4735d2cce",
    //            "upstream_job_ids": [],
    //            "upstream_concurrency_map": {},
    //            "workflow_name": "workflow"
    //        },
    //        "owners": [
    //        "twof"
    //        ],
    //        "vcs_tag": null,
    //        "pull_requests": [],
    //        "build_num": 12,
    //        "infrastructure_fail": false,
    //        "committer_email": "fabiobean2@gmail.com",
    //        "has_artifacts": true,
    //        "previous": {
    //            "build_num": 11,
    //            "status": "success",
    //            "build_time_millis": 6192
    //        },
    //        "status": "success",
    //        "committer_name": "twof",
    //        "retries": null,
    //        "subject": "circle kick",
    //        "vcs_type": "github",
    //        "timedout": false,
    //        "dont_build": null,
    //        "lifecycle": "finished",
    //        "no_dependency_cache": false,
    //        "stop_time": "2019-02-21T01:49:24.977Z",
    //        "ssh_disabled": true,
    //        "build_time_millis": 7508,
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
    //            "string": "version: 2\njobs:\n  build:\n    docker:\n    - image: circleci/python:3.6.1\n    working_directory: ~/repo\n    steps:\n    - checkout\n    - restore_cache:\n        keys:\n        - v1-dependencies-{{ checksum \"requirements.txt\" }}\n        - v1-dependencies-\n    - run:\n        name: install dependencies\n        command: |\n          python3 -m venv venv\n          . venv/bin/activate\n          pip install -r requirements.txt\n    - save_cache:\n        paths:\n        - ./venv\n        key: v1-dependencies-{{ checksum \"requirements.txt\" }}\n    - run:\n        name: run tests\n        command: |\n          . venv/bin/activate\n          python manage.py test\n    - store_artifacts:\n        path: test-reports\n        destination: test-reports\nnotify:\n  webhooks:\n  - url: https://6a4b8e77.ngrok.io/circle\nworkflows:\n  version: 2\n  workflow:\n    jobs:\n    - build\n"
    //        },
    //        "messages": [],
    //        "is_first_green_build": false,
    //        "job_name": null,
    //        "start_time": "2019-02-21T01:49:17.469Z",
    //        "canceler": null,
    //        "all_commit_details": [
    //        {
    //        "committer_date": "2019-02-20T17:49:07-08:00",
    //        "body": "",
    //        "branch": "master",
    //        "author_date": "2019-02-20T17:49:07-08:00",
    //        "committer_email": "fabiobean2@gmail.com",
    //        "commit": "c8e8bfd2f3f180696aa4d1465656ac24c99c8f35",
    //        "committer_login": "twof",
    //        "committer_name": "twof",
    //        "subject": "circle kick",
    //        "commit_url": "https://github.com/twof/FlaskOnAWS/commit/c8e8bfd2f3f180696aa4d1465656ac24c99c8f35",
    //        "author_login": "twof",
    //        "author_name": "twof",
    //        "author_email": "fabiobean2@gmail.com"
    //        }
    //        ],
    //        "platform": "2.0",
    //        "outcome": "success",
    //        "vcs_url": "https://github.com/twof/FlaskOnAWS",
    //        "author_name": "twof",
    //        "node": null,
    //        "queued_at": "2019-02-21T01:49:16.232Z",
    //        "canceled": false,
    //        "author_email": "fabiobean2@gmail.com"
    //    }
    //}

}
