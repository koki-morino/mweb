# Unorthodox Web Architecture Lab

An experimental full-stack playground exploring an unconventional web
architecture: pairing a __Flutter Web__ frontend with low-latency
__protobuf-over-WebSocket__ communication, backed by a cluster running
__OCFS2__ over __DRBD__ block-level replication.

The repository serves primarily as a hands-on lab for __LPIC-305__, with
limited coverage of high-availability storage concepts from __LPIC-306__.

## Certification Coverage

### Primary Focus: LPIC-305 (Virtualization and Containerization)

#### 352.3 Docker (weight: 9)

Managing application containers, network interfaces, and volume mounts using
`Dockerfile` and runtime environments.

#### 352.4 Container Orchestration Platforms (weight: 3)

Implementing local multi-container environments using __Docker Compose__.

#### 353.1 Cloud Management Tools (weight: 2)

Declarative infrastructure provisioning and management using __Terraform__.

#### 353.2 Packer (weight: 2)

Automating system image creation across local and cloud builders using template
configuration files.

#### 353.3 cloud-init (weight: 3)

Configuring instance initialization scripts (`user-data`), package
installations, and volume setups on first boot.

### Secondary Focus: LPIC-306 (High Availability and Storage Clusters)

#### 362.1 DRBD (weight: 6)

Configuring block-level synchronous disk replication across nodes, including
handling replication modes and device states.

#### 362.3 Clustered File Systems (weight: 4)

Deploying and managing shared-disk cluster filesystems with __OCFS2__ and the
O2CB cluster stack on top of replicated block storage.

## References

* [LPIC-305 Exam Objectives](https://www.lpi.org/our-certifications/exam-305-objectives)
* [LPIC-306 Exam Objectives](https://www.lpi.org/our-certifications/exam-306-objectives)
