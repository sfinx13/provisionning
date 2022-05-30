# Provisionning

## Provisionning with bash
The objective is to test the bash script, we will use container

```bash
$ docker build -f bash/Dockerfile -t provision-bash bash    
$ docker run -it --rm --name test-provision provision-bash 
```

## Provisionning with ansible
The objective is to test the playbook ansible, we will use a container as node

### Run container
Provision the node with ssh enabled cause ansible node manager communicate with nodes in ssh

```bash
$ docker build -f ansible/Dockerfile -t node-ssh .
$ docker run -dit --rm -p 22:22 --name node-1 node-ssh
```

### Execute playbook
```
$ cd ansible
$ ./play.sh
```

## Main ansible modules used

### Install modules
- [apt_key](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_key_module.html)
- [apt_repository](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_repository_module.html)
- [package](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/package_module.html)

### User management moduless
- [user](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html)
- [group](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html)

### Scripting modules
- [command](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html)
- [script](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/script_module.html)
- [shell](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html)

### File management modules
- [file](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html)
- [lininfile](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lininfile_module.html)
- [blockinfile](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/blockinfile_module.html)
- [template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)

### Service management modules
- [service](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html)

### Local management modules
- [community.general.locale_gen](https://docs.ansible.com/ansible/latest/collections/community/general/locale_gen_module.html)
- [community.general.timezone](https://docs.ansible.com/ansible/latest/collections/community/general/timezone_module.html)

### MySQL modules
- [community.mysql.mysql_user](https://docs.ansible.com/ansible/latest/collections/community/mysql/mysql_user_module.html)
- [community.mysql.mysql_db](https://docs.ansible.com/ansible/latest/collections/community/mysql/mysql_db_module.html)

### Other modules
- [set_fact](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html)
