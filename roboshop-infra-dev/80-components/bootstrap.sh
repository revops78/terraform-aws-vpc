# #!/bin/bash
# component=$1
# env=${2:-dev}        # Use default 'dev' if $2 is empty or unset
# dnf install ansible -y
# ansible-pull -U https://github.com/revops78/ansible-roboshop-roles-tf.git -e component=$component -e env=$env main.yaml


#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/revops78/ansible-roboshop-roles-tf.git -e component=$1 -e env=$2 main.yaml