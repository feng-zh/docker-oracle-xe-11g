#!/bin/bash
LISTENERS_ORA=/u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora

cp "${LISTENERS_ORA}.tmpl" "$LISTENERS_ORA" &&
sed -i "s/%hostname%/$HOSTNAME/g" "${LISTENERS_ORA}" &&
sed -i "s/%port%/1521/g" "${LISTENERS_ORA}" &&

service oracle-xe start

if [ ! -f "/tmp/.started" ]; then
  touch /tmp/.started
  export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe
  export PATH=$ORACLE_HOME/bin:$PATH
  export ORACLE_SID=XE
  sqlplus -s SYSTEM/oracle << EOF
    alter system disable restricted session;
    alter profile default limit password_life_time unlimited;
    alter user system identified by oracle;
EOF
fi
