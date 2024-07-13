#!/bin/sh

# Correct permissions for Squid log and cache directories
chown -R squid:squid /var/log/squid /var/spool/squid

# Initialize Squid cache directories if they don't exist
if [ ! -d "/var/spool/squid/00" ]; then
    echo "Initializing Squid cache directories..."
    squid -z
    sleep 5 # Wait a few seconds to ensure directories are created
fi

# Adjustments for cache memory, maximum object size, and workers
[ ! -z "$SQUID_CACHE_SIZE" ] && sed -i "s/^cache_dir ufs \/var\/spool\/squid .*/cache_dir ufs \/var\/spool\/squid ${SQUID_CACHE_SIZE:-100} 16 256/" /etc/squid/squid.conf
[ ! -z "$SQUID_CACHE_MEM" ] && sed -i "s/^cache_mem .*/cache_mem ${SQUID_CACHE_MEM:-256} MB/" /etc/squid/squid.conf
[ ! -z "$SQUID_MAX_OBJ_SIZE" ] && sed -i "s/^maximum_object_size .*/maximum_object_size ${SQUID_MAX_OBJ_SIZE:-128} MB/" /etc/squid/squid.conf
[ ! -z "$SQUID_WORKERS" ] && sed -i "s/^workers .*/workers ${SQUID_WORKERS:-2}/" /etc/squid/squid.conf

# Start Squid
exec squid -f /etc/squid/squid.conf -NYCd 1
