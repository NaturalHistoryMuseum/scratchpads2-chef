#!/bin/bash
knife bootstrap sp-control-1.nhm.ac.uk --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-control]' &&
knife bootstrap sp-app-1.nhm.ac.uk     --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-app]'     &&
knife bootstrap sp-app-2.nhm.ac.uk     --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-app]'     &&
knife bootstrap sp-data-1.nhm.ac.uk    --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-data]'    &&
knife bootstrap sp-data-2.nhm.ac.uk    --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-data]'    &&
knife bootstrap sp-search-1.nhm.ac.uk  --ssh-user simor --identity-file ~/.ssh/id_rsa --sudo --environment 'production' --run-list 'role[scratchpads-role-search]'