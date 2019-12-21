# Setup database connection

```shell
$ docker exec -it nextcloud_db_1 bash

$ bash-4.4# su postgres
> createuser -P nextcloud
> Enter password for new role:
> Enter it again:
> createdb -O nextcloud nextcloud
```
