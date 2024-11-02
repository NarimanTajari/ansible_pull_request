#!/bin/bash

# Create directories
mkdir -p vars tasks

# Create inventory file
cat > inventory.ini << EOF
[all]
localhost ansible_connection=local
EOF

# Create tasks/main.yml
cat > tasks/main.yml << EOF
---
- name: Print variable before set_fact
  debug:
    msg: "Before set_fact myvar is: {{ myvar }}"

- name: Set variable in tasks
  set_fact:
    myvar: "5. Variable from tasks/main.yml"

- name: Print variable after set_fact
  debug:
    msg: "After set_fact myvar is: {{ myvar }}"
EOF

# Create project.yml
cat > project.yml << EOF
---
- hosts: all
  gather_facts: no
  vars:
    myvar: "1. Variable from playbook vars"
  vars_files:
    - vars/vars1.yml
    - vars/vars2.yml
  
  tasks:
    - name: Print initial variable
      debug:
        msg: "Initial myvar is: {{ myvar }}"

    - name: Include vars/main.yml
      include_vars:
        file: vars/main.yml

    - name: Print after vars/main.yml
      debug:
        msg: "After vars/main.yml myvar is: {{ myvar }}"

    - name: Include tasks from main.yml
      include_tasks: tasks/main.yml

    - name: Print final variable
      debug:
        msg: "Final myvar is: {{ myvar }}"
EOF

# Create vars/main.yml
cat > vars/main.yml << EOF
---
myvar: "3. Variable from vars/main.yml"
EOF

# Create vars1.yml
cat > vars/vars1.yml << EOF
---
myvar: "2a. Variable from vars1.yml"
EOF

# Create vars2.yml
cat > vars/vars2.yml << EOF
---
myvar: "2b. Variable from vars2.yml"
EOF

# Create ansible.cfg
cat > ansible.cfg << EOF
[defaults]
inventory = inventory.ini
host_key_checking = False
EOF

echo "Structure created. Now you can run:"
echo "ansible-playbook project.yml"
echo "or"
echo "ansible-playbook project.yml -e \"myvar='6. Variable from command line'\""
