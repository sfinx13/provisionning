# Provisionning

## Provisionning with bash
The objective is to test the bash script, we will use container

```bash
$ docker build -f bash/Dockerfile -t provision-bash .
$ docker run -it --rm --name test-provision provision-bash 
```

## Provisionning with ansible
The objective is to test the playbook ansible, we will use a container as node

Provision the node with ssh enabled cause ansible node manager communicate with nodes in ssh

```bash
$ docker build -f ansible/Dockerfile -t node-ssh
$ docker run -dit --rm -p 2222:22 --name http-node-1 node-ssh
```

