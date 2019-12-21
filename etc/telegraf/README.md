# Loading env vars

The env file will provide InfluxDB credentials and needs to be copied and sourced.

```shell
$ sudo cp telegraf_env.sample.sh /etc/telegraf/env.sh
$ echo "source /etc/telegraf/env.sh" >> ~/.bash_profile
```
