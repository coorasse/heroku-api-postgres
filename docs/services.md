# Heroku CLI Postgres commands

This list contains all postgres commands supported by the official CLI.
Source: https://devcenter.heroku.com/articles/heroku-cli-commands

- [x] pg --> `client.databases.info(app_id, database_id)`

- [x] pg:backups --> `client.backups.list(app_id)`

- [ ] pg:backups:cancel

- [x] pg:backups:capture ---> `client.backups.capture(app_id, database_id)`
The command returns immediately, without waiting for the capture to be completed.
`--wait-interval` not implemented. `--snapshot` not implemented.

- [ ] pg:backups:delete

- [ ] pg:backups:download

- [x] pg:backups:info --> `client.backups.info(app_id, backup_id)`

- [x] pg:backups:restore --> `client.backups.restore(app_id, database_id, dump_url)`
The command works only with public URLs. It does not support all the features of the original
`heroku pg:backups:restore` command, like restoring directly from another database.
The command returns immediately, without waiting for the capture to be completed.
You can use the command `client.backups.wait(app_id, restore[:num])` to wait for it to be ready.

- [x] pg:backups:schedule --> `client.backups.schedule(app_id, database_id)`


- [x] pg:backups:schedules --> `client.backups.schedules(app_id, database_id)`

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

- [x] pg:info --> `client.databases.info(app_id, database_id)`

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

- [x] pg:wait --> `client.wait(app_id, database_id)`
Waits for a database to be ready.
