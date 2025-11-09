# AIP-LMS Infra

This repository contains the **development and CI/CD infrastructure** for the **AIP-LMS (AI-Powered Learning Management System)** platform.

It provides a ready-to-run local environment using Docker Compose and serves as the canonical definition for how all services interact in development and CI pipelines.

---

## 🧱 Overview

**AIP-LMS** lets users upload and query their learning content (articles, PDFs, Word files, notes, links) using AI — summaries, explanations, flashcards, and Q&A.

This repo hosts all shared infra components:

| Component | Purpose |
|------------|----------|
| **Postgres** | Relational DB (one logical DB per microservice) |
| **Redis** | Caching, rotating refresh tokens, rate limits |
| **RabbitMQ** | Message broker for ingest tasks |
| **MinIO** | S3-compatible object storage for uploaded files |
| **OpenSearch** | Full-text / BM25 search indexing |
| **Milvus** | Vector DB for embeddings and semantic retrieval |
| **Jaeger** | Distributed tracing (OpenTelemetry backend) |
| **Prometheus** | Metrics collection |
| **Grafana** | Metrics visualization dashboards |
| **MailHog** | Local SMTP sink for signup and password-reset emails |

---

## 🗂 Folder Structure

```
aip-lms-infra/
├── docker-compose.yml
├── docker-compose.override.yml
├── docker-compose.ci.yml
├── .env.example
├── postgres/
│   └── init-db/
│       └── 1_create_databases.sql
├── monitoring/
│   ├── prometheus/prometheus.yml
│   └── grafana/
│       ├── provisioning/
│       │   ├── datasource.yml
│       │   └── dashboards.yaml
│       └── dashboards/
│           └── sample-service-dashboard.json
├── jenkins/Jenkinsfile
├── helm/
│   └── charts/auth-service/
│       ├── Chart.yaml
│       └── values.yaml
├── k8s/
│   ├── manifests/
│   │   ├── auth-service/
│   │   ├── user-service/
│   │   ├── content-service/
│   │   ├── ingest-service/
│   │   ├── qa-service/
│   │   ├── gateway-graphql/
│   │   └── frontend-react/
│   ├── templates/
│   │   ├── configmap-template.yaml
│   │   ├── deployment-template.yaml
│   │   ├── service-template.yaml
│   │   └── ingress-template.yaml
│   └── helm-values/
│       ├── dev-values.yaml
│       ├── staging-values.yaml
│       └── prod-values.yaml
├── service-application-sample.yml
├── .gitignore
└── README.md   ← you are here
```

---

## ⚙️ Quick Start (Local Dev)

### 1️⃣ Clone the repos

Make sure the service repos (`auth-service`, `user-service`, etc.) exist as siblings of this repo.

```
parent-folder/
 ├── aip-lms-infra/
 ├── auth-service/
 ├── user-service/
 ├── content-service/
 ├── ingest-service/
 ├── qa-service/
 ├── gateway-graphql/
 └── frontend-react/
```

### 2️⃣ Create your environment file

```bash
cp .env.example .env
# Edit .env if you want to change ports or passwords
```

### 3️⃣ Start the infra stack

```bash
docker compose up -d
```

> 💡 This launches Postgres, Redis, RabbitMQ, MinIO, OpenSearch, Milvus, Jaeger, Prometheus, Grafana, and MailHog.

To build and run local service images alongside infra:

```bash
docker compose -f docker-compose.yml -f docker-compose.override.yml up --build
```

### 4️⃣ Access useful endpoints

| Service | URL |
|----------|-----|
| Postgres | `localhost:5432` |
| Redis | `localhost:6379` |
| RabbitMQ Mgmt | [http://localhost:15672](http://localhost:15672) |
| MinIO Console | [http://localhost:9001](http://localhost:9001) |
| OpenSearch | [http://localhost:9200](http://localhost:9200) |
| Milvus | `localhost:19530` |
| Jaeger UI | [http://localhost:16686](http://localhost:16686) |
| Prometheus | [http://localhost:9090](http://localhost:9090) |
| Grafana | [http://localhost:3000](http://localhost:3000) (admin/admin) |
| MailHog | [http://localhost:8025](http://localhost:8025) |

---

## 🧩 Kubernetes Templates

The `k8s/templates/` folder includes **base YAML templates** for consistent Kubernetes manifests:

| File | Purpose |
|------|----------|
| `deployment-template.yaml` | Base Deployment definition for microservices |
| `service-template.yaml` | Standard ClusterIP service definition |
| `ingress-template.yaml` | Example ingress resource for routing via domain or path |
| `configmap-template.yaml` | Configuration map template for service-level environment vars |

Use these templates when creating new service manifests under `k8s/manifests/<service-name>/`.  
This ensures consistency across deployments and simplifies Helm chart migration.

---

## 🧠 Core Design Principles

- **One service → One DB schema** (ownership & Flyway migrations)
- **Object + metadata separation** (MinIO + Postgres)
- **Search + semantic retrieval** (OpenSearch + Milvus)
- **Event-driven ingest** (RabbitMQ)
- **Caching & token lifecycle** (Redis)
- **Full observability** (OpenTelemetry + Prometheus + Grafana)
- **CI parity** (same Compose stack used in CI with prebuilt images)
- **Kubernetes-first design** (consistent templates for manifests and Helm charts)

---

## 🧰 Helm & Kubernetes

- **Helm charts:** located under `helm/charts/<service-name>` for each microservice.  
- **Kubernetes manifests:** live under `k8s/manifests/`, one folder per service.  
- **Templates:** `k8s/templates/` provides shared base manifests.  
- **Values files:** `k8s/helm-values/` holds environment-specific overrides (`dev`, `staging`, `prod`).

This structure ensures you can easily migrate from Docker Compose → Helm → full Kubernetes deployment with minimal duplication.

---

## 🧾 Reset / Troubleshooting

| Issue | Fix |
|-------|-----|
| Containers won’t start | `docker compose down -v && docker compose up --build` |
| DB schema missing | Check logs of service and Flyway migrations |
| No emails delivered | Open [MailHog UI](http://localhost:8025) |
| Missing metrics | Verify `/actuator/prometheus` exposure |
| Vector DB errors | Restart `milvus` and `ingest-service` |

---

## 🧩 Extending Infra

You can easily add more infra components:

| Add-on | When to use |
|---------|-------------|
| **MongoDB** | If chunk storage moves to document DB |
| **Postgres Exporter** | For DB metrics |
| **pgBouncer** | For connection pooling in CI/prod |
| **Vault** | For centralized secret management |
| **Traefik/Nginx** | For local ingress proxying multiple APIs |

---

## ✅ Summary

✔ **All core infra** for local and CI environments  
✔ **Per-service Postgres DBs**, realistic object + search stack  
✔ **Observability ready** (Jaeger, Prometheus, Grafana)  
✔ **Email + Message queues** (MailHog, RabbitMQ)  
✔ **Kubernetes-ready structure with templates and manifests**  
✔ **Production-minded design**, developer-friendly setup

> “Run everything with one command — and mirror prod, safely.”

```bash
docker compose up --build
```

---

© 2025 AIP-LMS Team — Infrastructure Foundation
