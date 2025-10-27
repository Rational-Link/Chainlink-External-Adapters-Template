# Chainlink Node External Adapters Template
This guide provides a clear overview of how to build and customize an External Adapter for Chainlink. As a client, you'll tailor the adapter logic to meet your specific data needs. Once finalized, the adapter will be deployed and continuously executed via docker,and the Chainlink Node will implement a bridge specific to your account & job requirement.


## Repository Structure
```
my-api/
├── contract/
│   └── ClientContract.sol  # Client request
├── job/
│   └── numbers-ea.toml     # Chainlink Node Job spec
├── docker/
│   └── Dockerfile          # Docker image
├── src/
│   └── server.ts           # External Adapter server
├── docker-compose.yml
├── package-lock.json
├── package.json
├── tsconfig.json
└── README.md
```
---

## Overview
This template demonstrates how to implement and deploy a Chainlink External Adapter. It includes:
- A sample smart contract
- A job spec configuration
- A Dockerized server for the external adapter
---

## Request Structure
The External Adapter expects a JSON payload with the following format via an example using https://en.wikipedia.org/:
```json
{
  "id": "12345",
  "data": {
    "titles": "Machine_learning",
    "exchars": "100"
  }
}
```
---
## Response Structure
The adapter returns a structured JSON response:
```json
{
  "jobRunId": "12345",
  "statusCode": 200,
  "data": {
    "result": "Machine learning (ML) is a field of study in artificial intelligence concerned with the development and..." 
  }
}
```

---
## Running the Adapter
The adapter runs inside a Docker container on the Chainlink Node operator's infrastructure. This setup ensures the job specs can trigger the adapter reliably during each execution cycle.
To start the container locally:

```bash
  docker compose up
```

---
