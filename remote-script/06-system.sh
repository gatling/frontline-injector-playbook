#!/usr/bin/bash


echo "------------------------------------------------------------------------"
echo "-- tuning system                                                      --"
echo "------------------------------------------------------------------------"

sudo su << EOT

cat  << EOC >> /etc/pam.d/sshd
session    required     pam_limits.so
EOC

cat  << EOC >> /etc/sysctl.d/99-gatling.conf
# Enhance connections limits

# Increase size of file handles and inode cache
fs.nr_open = 1048576
fs.file-max = 1048576

net.core.netdev_max_backlog = 300000 # Max packets waiting on interface
net.core.somaxconn = 40000 # Max new connections per port
net.ipv4.ip_local_port_range = 1024 65535 # Max TCP ports available
net.ipv4.tcp_max_syn_backlog = 40000 # Max global new connections

# Faster port recycling

net.ipv4.tcp_fin_timeout = 15 # Duration of TIME_WAIT_2
net.ipv4.tcp_tw_reuse = 1 # Reuse socket in TIME_WAIT

# Minimize slow-start

net.ipv4.tcp_slow_start_after_idle = 0 # Disable idle

# Windows adjustments and buffers

net.ipv4.tcp_window_scaling = 1 # Check

net.ipv4.tcp_rmem = 4096 277750 134217728 # Buffers TCP connections (read)
net.ipv4.tcp_wmem = 4096 277750 134217728 # Buffers TCP connections (write)
net.ipv4.tcp_mem  = 134217728 134217728 134217728 # Max TCP memory

# Fail fast

#net.ipv4.tcp_syn_retries
#net.ipv4.tcp_synack_retries

# Adjust TCP keep alive

#net.ipv4.tcp_keepalive_time
net.ipv4.tcp_keepalive_intvl = 30 # Interval between probes
#net.ipv4.tcp_keepalive_probes # Probes before failure

# ?

#net.core.wmem_default = 8388608
#net.core.rmem_default = 8388608
#net.ipv4.tcp_sack = 1
#net.ipv4.tcp_moderate_rcvbuf = 1

#net.core.rmem_max = 134217728
#net.core.wmem_max = 134217728

#net.ipv4.tcp_abort_on_overflow = 1 # maybe
EOC

sysctl -p /etc/sysctl.d/99-gatling.conf

cat  << EOC >> /etc/security/limits.conf
*              hard     nofile          1048576
*              soft     nofile          1048576
EOC


EOT
