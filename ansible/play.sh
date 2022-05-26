#!/bin/bash

ansible-playbook -v -i inventory.ini playbooks/initial-setup.yml
ansible-playbook -v -i inventory.ini playbooks/create-user.yml
ansible-playbook -v -i inventory.ini playbooks/install-sqlite.yml
ansible-playbook -v -i inventory.ini playbooks/install-python.yml
ansible-playbook -v -i inventory.ini playbooks/install-node.yml
ansible-playbook -v -i inventory.ini playbooks/install-nginx.yml
ansible-playbook -v -i inventory.ini playbooks/install-php.yml
ansible-playbook -v -i inventory.ini playbooks/install-redis.yml
ansible-playbook -v -i inventory.ini playbooks/install-memcached.yml
