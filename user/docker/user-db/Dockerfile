FROM mongo:3

copy ./scripts /tmp/scripts

# Modify child mongo to use /data/db-accounts as dbpath (because /data/db wont persist the build because it is already a VOLUME)
RUN mkdir -p /data/db-users \
    && echo "dbpath = /data/db-users" > /etc/mongodb.conf \
    && chown -R mongodb:mongodb /data/db-users

<<<<<<< HEAD
RUN chmod +x /tmp/scripts/mongo_create_insert.sh
=======

run chmod a+rwx /tmp && chmod a+rwx /tmp/scripts && chmod a+rwx /tmp/scripts/*

>>>>>>> 690ff1159e47e201cfbfb6c34da6f966d207bfda
RUN su - mongodb && mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db-users  \
    && /tmp/scripts/mongo_create_insert.sh \
    && mongod --dbpath /data/db-users --shutdown \
    && chown -R mongodb /data/db-users

# Make the new dir a VOLUME to persist it
VOLUME /data/db-users

CMD ["mongod", "--config", "/etc/mongodb.conf", "--smallfiles"]
