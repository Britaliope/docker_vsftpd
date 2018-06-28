# vsftpd Docker Image

Features: 
- Multi virtual user
- Support differents permissions for each user
- separate chrooted users
## General

By default, passive mode is enabled, port range is 21100-21150, and no pasv_address is specified. If you need to change that you should build the container yourself. 

Data is stored in `/var/ftp/{username}/data`, but you can change that by adding a `local_root=/path/to/data` in the user config file stored in `/config/vsftpd/user_config`.

FAQ: 

- **Why `/var/ftp/{username}/data/` and not `/var/ftp/{username}/ ?**

Storing data in a subfolder of the chroot folder enable to have a read-only root folder. (vsftpd option `allow_writeable_chroot` is set to false).
See https://www.benscobie.com/fixing-500-oops-vsftpd-refusing-to-run-with-writable-root-inside-chroot and http://serverfault.com/questions/362619/why-is-the-chroot-local-user-of-vsftpd-insecure


## Build container

- `cp vsftpd.conf.example vsftpd.conf`
- Adapt the config -you may want to customize `pasv_min_port`, `pasv_max_port` and `pasv_address` fields.
- `docker build .`

## Start Container


```
docker run -d -p 20-21:20-20-21 -p 21100-21150:21100-21150 \
	--name vsftpd
	-v user1_volume:/var/ftp/user1/data \
	-v user2_volume:/var/ftp/user2/data \
	-v user_config_volume:/config/vsftpd \
	britaliope/docker_vsftpd

```

## Add user

### Using script

```
docker exec -it vsftpd bash
addVirtualUser.sh
```

### Manual

- `virtual_users` file is located in /config/vsftpd in the container
- `echo "username:$(openssl passwd -1 password)" >> /path/to/virtual_users/file`
- Create and/or mount data folder (Default: `/var/ftp/username/data`) 
- (optional) add a file named `username` in the `user_config` folder that is in the same folder of `virtual_user`

Example user config file: 
``` user_config/myUsername


#local_root=/var/ftp/example_user/data

write_enable=NO
anon_upload_enable=NO
anon_mkdir_write_enable=NO
anon_other_write_enable=NO

```

### If you need to add a new volume to an existing container without deleting the container

Just commit the container (`docker commit container_name`) and then run the new container following previous instructions without forgeting the new volume ;)`
