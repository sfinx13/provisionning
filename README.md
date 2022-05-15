# Provisionning

## Provisionning with bash
The objective is to test the bash script, we will use container

```bash
$ docker build -f bash/Dockerfile -t provision-bash .
$ docker run -it --rm --name test-provision provision-bash 
```

## Provisionning with ansible
The objective is to test the playbook ansible, we will use a container as node

### Run container
Provision the node with ssh enabled cause ansible node manager communicate with nodes in ssh

```bash
$ docker build -f ansible/Dockerfile -t node-ssh .
$ docker run -dit --rm -p 22:22 --name http-node-1 node-ssh
```

### Execute playbook
```
ansible-playbook -v -i inventory.ini initial-setup.yml
ansible-playbook -v -i inventory.ini install-sqlite.yml
ansible-playbook -v -i inventory.ini install-python.yml
```

## @TODO 

futher roles is coming