## Find top 10 slow queries taking more than 100ms from log file
egrep '[0-9]{3,}ms$' mongod.log | egrep -iv 'writebacklisten|lockpinger|split vector' | awk '{print $NF, $0}' | sort -n | tail -n 10
 
## Find all collections that have a query doing COLLSCAN
egrep '[0-9]{3,}ms$' /logs/mongod.log.1 | egrep -i collscan | awk '{print $6 }' | sort -n | uniq
 
## Find top namespaces by count of operations
egrep '[0-9]{3,}ms$' /log/mongod.log | grep -iv getlasterror | awk '{print $6}' | sort |  uniq -c | sort -n | tail -n 10
 
## Find top commands run by namespace
egrep COMMAND /path/to/mongod.log | awk '{print $6}' | sort | uniq -c | sort -n
 
## Find top QUERY operations by namespace
egrep QUERY /path/to/mongod.log | awk '{print $6}' | sort | uniq -c | sort -n
 
## For searching in compressed file, i.e. file.gz
gzip -cd <file> | rest_of commands_here
