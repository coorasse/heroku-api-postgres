# Heroku CLI Postgres commands

This list contains all postgres commands supported by the official CLI.
Source: https://devcenter.heroku.com/articles/heroku-cli-commands

- [x] pg --> `client.databases.info(database_id)`

- [x] pg:backups --> `client.backups.list(app_id)`

- [ ] pg:backups:cancel

- [ ] pg:backups:capture

- [ ] pg:backups:delete

- [ ] pg:backups:download

- [ ] pg:backups:info

- [ ] pg:backups:restore

- [ ] pg:backups:schedule

- [x] pg:backups:schedules --> `client.backups.schedules(database_id)`

- [ ] pg:backups:unschedule

- [ ] pg:backups:url

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

- [ ] pg:wait
