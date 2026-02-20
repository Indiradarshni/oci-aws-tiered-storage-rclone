# Near Real-Time Multi-Cloud Backups with OCI and AWS: A Tiered Storage Approach

Cost-optimized HOT–WARM–COLD tiered storage architecture using OCI Object Storage, AWS S3, Glacier, and rclone

This repository demonstrates a **cost-optimized, multi-cloud tiered storage architecture** using **Oracle Cloud Infrastructure (OCI)** and **Amazon Web Services (AWS)**.

The solution implements a **HOT–WARM–COLD storage model**:
- **HOT**: OCI Object Storage (active data)
- **WARM**: Amazon S3 (near real-time backup)
- **COLD**: Amazon Glacier (long-term archival)

Data is replicated in **near real time** using **rclone**, a cloud-agnostic data synchronization tool that operates entirely on the data plane.


## Architecture Overview

OCI Object Storage (Standard)
 ↓
rclone (Continuous sync every 30–60 seconds)
 ↓
Amazon S3 (Standard / Infrequent Access)
 ↓
Lifecycle Policy (30–90 days)
 ↓
Amazon Glacier (Archive)

# Quick Start

This demo uses OCI Cloud Shell for simplicity.
For production, the same script can run continuously on an OCI Compute instance.

# Prerequisites

- OCI Object Storage bucket (private)
- AWS S3 bucket
- rclone installed
- rclone configured for: oracleobjectstorage (OCI) and s3 (AWS)

# Run the sync

cd scripts
./oci_to_aws_sync.sh

The script runs continuously and performs near real-time sync from:

OCI Object Storage (HOT) → AWS S3 (WARM)

Older data is automatically transitioned to Amazon Glacier (COLD) using an S3 lifecycle policy.
