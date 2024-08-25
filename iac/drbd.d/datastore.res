resource datastore {
    net {
        protocol C;

        # Enable dual-primary mode only after initial synchronization has
        # completed.
        # allow-two-primaries yes;

        # fencing resource-only;

        # After split-brain detected.
        after-sb-0pri discard-zero-changes;
        after-sb-1pri discard-secondary;
        after-sb-2pri disconnect;
    }

    handlers {
        split-brain "/sbin/notify-split-brain.sh root";
        # fence-peer "/sbin/fence-self.sh root";
    }

    # /dev/drbd1
    device minor 1;
    disk "/dev/disk/by-id/google-dup";
    meta-disk internal;

    on "mweb-server-1" {
        node-id 0;
    }

    on "mweb-server-2" {
        node-id 1;
    }

    connection {
        host "mweb-server-1" address 10.0.0.10:7789;
        host "mweb-server-2" address 10.1.0.10:7789;
    }
}
