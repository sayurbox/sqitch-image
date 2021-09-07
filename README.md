# sqitch-image
Docker Image with pre-installed sqitch application for sqitch deployer


## Example usage on github actions
```yaml
name: Sqitch PR Checks

on:
  pull_request:
    branches: [main]
  push:
    branches:
      - "main"
jobs:
  sqitch-tests:
    runs-on: ubuntu-latest
    container: ghcr.io/sayurbox/sqitch-image:1.0.0
    steps:
      - name: Check out repository code
        uses: actions/checkout@v2
      - name: Check sqitch version
        run: sqitch --version
      - name: Deploy
        run: sqitch deploy <db-string>
      - name: Verify
        run: sqitch verify <db-string>
      - name: Revert
        run: sqitch revert -y <db-string>
    services:
      mysql:
        image: mysql:5.7
        env:
          MYSQL_DATABASE: <db_name>
          MYSQL_HOST: <db_host>
          MYSQL_USER: <db_user>
          MYSQL_PASSWORD: <db_password>
          MYSQL_ROOT_PASSWORD: <db_root_password>
        ports:
          - 3306:3306
        options: --health-cmd="mysqladmin ping" --health-interval=10s --health-timeout=5s --health-retries=3
```

## Example usage on bitbucket pipelines
```yaml
image: ghcr.io/sayurbox/sqitch-image:1.0.0

pipelines:
  default:
    - step:
        name: Check sqitch version
        script:
          - sqitch --version
    - step:
        name: Sqitch Tests
        services:
          - mysql
        script:
          - while ! mysqladmin ping -h127.0.0.1; do sleep 1; done
          - sqitch deploy -h 127.0.0.1 -d <db_name>
          - sqitch verify -h 127.0.0.1 -d <db_name>
          - sqitch revert -y -h 127.0.0.1 -d <db_name>

definitions:
  services:
    mysql:
      image: mysql:8.0.25
      variables:
        MYSQL_DATABASE: <db_name>
        MYSQL_ROOT_PASSWORD: <db_root_password>
```
