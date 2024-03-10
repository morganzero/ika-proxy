#!/bin/sh

# Correct permissions for Squid log directory
chown -R squid:squid /var/log/squid /var/spool/squid

# Initialize Squid cache directories if they don't exist
if [ ! -d "/var/spool/squid/01" ]; then
    echo "Initializing Squid cache directories..."
    squid -N -z
fi

# Adjustments for cache memory and maximum object size
if [ ! -z "$SQUID_CACHE_SIZE" ]; then
    sed -i "s/^cache_dir ufs \/var\/spool\/squid .*/cache_dir ufs \/var\/spool\/squid ${SQUID_CACHE_SIZE:-1000} 16 256/" /etc/squid/squid.conf
fi

if [ ! -z "$SQUID_CACHE_MEM" ]; then
    sed -i "s/^cache_mem .*/cache_mem ${SQUID_CACHE_MEM:-256} MB/" /etc/squid/squid.conf
fi

if [ ! -z "$SQUID_MAX_OBJ_SIZE" ]; then
    sed -i "s/^maximum_object_size .*/maximum_object_size ${SQUID_MAX_OBJ_SIZE:-128} MB/" /etc/squid/squid.conf
fi

if [ ! -z "$SQUID_WORKERS" ]; then
    sed -i "s/^workers .*/workers ${SQUID_WORKERS:-2}/" /etc/squid/squid.conf
fi

# Start Squid
exec squid -f /etc/squid/squid.conf -NYCd 1
