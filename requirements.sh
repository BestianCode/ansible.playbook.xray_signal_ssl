#!/bin/bash

ansible-playbook -i inventory _update-ansible-collections.yml --diff
