#!/bin/bash

knife bootstrap sp-control-1.nhm.ac.uk -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-control]'
knife bootstrap sp-app-1.nhm.ac.uk     -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-app]'
knife bootstrap sp-app-2.nhm.ac.uk     -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-app]'
knife bootstrap sp-data-1.nhm.ac.uk    -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-data]'
knife bootstrap sp-data-2.nhm.ac.uk    -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-data]'
knife bootstrap sp-search-1.nhm.ac.uk  -x simor -i ~/.ssh/id_rsa --sudo -r 'role[scratchpads-role-search]'
