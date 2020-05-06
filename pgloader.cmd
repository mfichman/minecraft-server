load database
     from sqlite:///data/backups/db/production.2020-05-06.sqlite3
     into postgres://bqbtdjlecgwdbb:f3969c9be82bf6266e33870f6553b678e7f47bff3baa9b028b72219f9d189ca8@ec2-52-207-25-133.compute-1.amazonaws.com:5432/dbqt8fs4n0bu13

with include drop, create tables, create indexes, reset sequences

set work_mem to '16MB', maintenance_work_mem to '512 MB';
