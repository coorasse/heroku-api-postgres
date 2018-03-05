# Heroku CLI Postgres commands

This list contains all postgres commands supported by the official CLI.
Source: https://devcenter.heroku.com/articles/heroku-cli-commands

- [x] pg --> `client.databases.info(database_id)`

- [x] pg:backups --> `client.backups.list(app_id)`

- [ ] pg:backups:cancel

- [x] pg:backups:capture ---> `client.backups.capture(database_id)`
The command returns immediately, without waiting for the capture to be completed.
`--wait-interval` not implemented. `--snapshot` not implemented.

- [ ] pg:backups:delete

- [ ] pg:backups:download

- [ ] pg:backups:info

- [ ] pg:backups:restore

- [x] pg:backups:schedule --> `client.backups.schedule(database_id)`


- [x] pg:backups:schedules --> `client.backups.schedules(database_id)`

- [ ] pg:backups:unschedule

- [x] pg:backups:url --> `client.backups.url(app_id, backup_num)`

- [ ] pg:connection-pooling:attach

- [ ] pg:copy

- [ ] pg:credentials

- [ ] pg:credentials:create

- [ ] pg:credentials:destroy

- [ ] pg:credentials:repair-default

- [ ] pg:credentials:rotate

- [ ] pg:credentials:url

- [ ] pg:diagnose

- [x] pg:info --> `client.databases.info(database_id)`

- [ ] pg:kill

- [ ] pg:killall

- [ ] pg:links

- [ ] pg:links:create

- [ ] pg:links:destroy

- [ ] pg:maintenance

- [ ] pg:maintenance:run

- [ ] pg:maintenance:window

- [ ] pg:outliers

- [ ] pg:promote

- [ ] pg:ps

- [ ] pg:psql

- [ ] pg:pull

- [ ] pg:push

- [ ] pg:reset

- [ ] pg:settings

- [ ] pg:settings:log-lock-waits

- [ ] pg:settings:log-min-duration-statement

- [ ] pg:settings:log-statement

- [ ] pg:unfollow

- [ ] pg:upgrade

- [x] pg:wait --> `client.wait(database_id)`
Waits for a database to be ready.
