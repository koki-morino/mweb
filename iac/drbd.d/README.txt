Couldn't use Pacemaker for OCFS2 as non-server edition of Ubuntu doesn't
support OCFS2 resource for Pacemaker. So, use legacy method instead.

Configure OCFS2 cluster:
$ dpkg-reconfigure -p medium -f readline ocfs2-tools

Reboot:
$ shutdown -r now

After first synchronizaion has completed, update DRBD config to enable dual-
primary mode and run:
$ drbdadm adjust datastore

Now, both nodes are able to be primary:
$ drbdadm primary datastore

Make OCFS2 on either node:
$ mkfs -t ocfs2 -N 2 -L ocfs2_drbd /dev/drbd1

Mount OCFS2:
$ mount -t ocfs2 /dev/drbd1 /shared

Watch DRBD status:
$ while :; do drbdadm status; sleep 5; done

Simulate network partition:
$ sudo iptables -A INPUT -s 10.0.0.10 -j DROP
$ sudo iptables -A OUTPUT -d 10.0.0.10 -j DROP

Recover from network partition simulation:
$ sudo iptables -D INPUT -s 10.0.0.10 -j DROP
$ sudo iptables -D OUTPUT -d 10.0.0.10 -j DROP
