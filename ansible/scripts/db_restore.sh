#!/bin/bash

# Check whether there's a database backup:
if [ -d "/vagrant/storage/backups" ]; then
  db_backup=`ls /vagrant/storage/backups | tail -1`;
else
  db_backup='';
fi

# If there is, restore the most recent one:
if test ! -s $db_backup
then
  echo
  echo "Populating Craft database from latest backup ($db_backup)";
  mysql -uroot -p123 craft < /vagrant/storage/backups/$db_backup;
  echo
else
  echo
  echo "No Craft database backups found.";
  echo "Please finish installing Craft by visiting /admin/install in your browser.";
  echo
fi
