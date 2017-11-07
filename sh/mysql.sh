#!/bin/bash
USER="root"
PASSWORD="123456"
DATABASE="itmanager_development"
TABLE="devices"
mysql -u$USER -p$PASSWORD << EOF
use $DATABASE
update $TABLE set borrow_timeleft=borrow_timeleft-1 where status=4 and borrow_timeleft>0
EOF
