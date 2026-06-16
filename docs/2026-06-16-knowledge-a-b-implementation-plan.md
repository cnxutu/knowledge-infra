# Knowledge Hub Deployment Standardization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Align `knowledge-infra` with `knowledge-hub` service deployment needs and add a reusable `knowledge-template` module family in `knowledge-hub`.

**Architecture:** The deployment repo becomes the single source of truth for middleware and microsystem runtime conventions, while the code repo gains a root-level template aggregator that mirrors the deployment naming model. Existing runnable services are wired in directly; future services are represented as standard skeleton entries and Maven modules.

**Tech Stack:** Docker Compose, Bash, Maven multi-module Java 17, Spring Boot

---

### Task 1: Re-home the design docs into project B

**Files:**
- Create: `knowledge-infra/docs/knowledge-hub-deployment-design.md`
- Create: `knowledge-infra/docs/2026-06-16-knowledge-a-b-implementation-plan.md`
- Delete: `docs/superpowers/specs/2026-06-16-knowledge-a-b-deploy-template-design.md`

- [ ] Copy the approved design into `knowledge-infra/docs/knowledge-hub-deployment-design.md`.
- [ ] Save this implementation plan beside it in `knowledge-infra/docs/`.
- [ ] Remove the workspace-level spec copy so deployment docs live with project B.

### Task 2: Rebuild project B middleware around project A

**Files:**
- Modify: `knowledge-infra/middleware/docker-compose.yml`
- Modify: `knowledge-infra/middleware/initdir.sh`
- Modify: `knowledge-infra/middleware/nginx/nginx.conf`
- Modify: `knowledge-infra/middleware/nginx/frontend-apps.properties`
- Modify: `knowledge-infra/middleware/nginx/sync-frontend.sh`
- Create: `knowledge-infra/middleware/elasticsearch/elasticsearch.yml`
- Create: `knowledge-infra/middleware/nginx/html/index.html`

- [ ] Replace company-specific middleware service definitions with the `knowledge-hub` stack: MySQL, Redis, Nacos, Elasticsearch, Nginx, RocketMQ.
- [ ] Keep historical non-core directories on disk, but stop treating them as part of the default startup chain.
- [ ] Rewrite the Nginx config into a simple gateway-facing reverse proxy plus static placeholder page.
- [ ] Convert frontend sync config into a clearly optional placeholder instead of company product names.
- [ ] Ensure middleware init creates the directories required by the retained stack.

### Task 3: Rebuild project B microsystem around `kb-*` services

**Files:**
- Modify: `knowledge-infra/microsystem/docker-compose.yml`
- Modify: `knowledge-infra/microsystem/env.properties`
- Modify: `knowledge-infra/microsystem/apps.properties`
- Modify: `knowledge-infra/microsystem/sync-and-restart.sh`
- Modify: `knowledge-infra/toolkits/startup_springboot.sh`

- [ ] Replace `c-*` service definitions with `kb-gateway`, `kb-auth`, `kb-content`, `kb-message`, `kb-search`.
- [ ] Standardize port allocation, log mounts, health checks, debug ports, and JAR naming.
- [ ] Update environment variables to match project A middleware semantics and note reserved future values.
- [ ] Make the startup script honor per-service JAR file names instead of hardcoding `app.jar`.
- [ ] Keep download/update workflow working for both current and placeholder services.

### Task 4: Update project B operational scripts and docs

**Files:**
- Modify: `knowledge-infra/init.sh`
- Modify: `knowledge-infra/startup.sh`
- Modify: `knowledge-infra/shutdown.sh` if needed
- Modify: `knowledge-infra/README.md`
- Modify: `knowledge-infra/arch.txt`

- [ ] Remove project-A-unrelated startup assumptions such as mandatory TDengine initialization from the default flow.
- [ ] Keep startup order strict: middleware first, then Nacos health gate, then microsystem.
- [ ] Rewrite README and architecture notes so they describe the `knowledge-hub` deployment topology and the distinction between active services and reserved skeleton services.

### Task 5: Add `knowledge-template` to project A root aggregation

**Files:**
- Modify: `knowledge-hub/pom.xml`
- Create: `knowledge-hub/knowledge-template/pom.xml`
- Create: `knowledge-hub/knowledge-template/README.md`

- [ ] Register `knowledge-template` as a new root module in `knowledge-hub/pom.xml`.
- [ ] Create the template aggregator module with concise documentation about intended reuse.

### Task 6: Add the template service family

**Files:**
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/pom.xml`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-api/pom.xml`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-core/pom.xml`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-bootstrap/pom.xml`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-api/src/main/java/com/cv/template/service/api/package-info.java`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-core/src/main/java/com/cv/template/service/core/package-info.java`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-bootstrap/src/main/java/com/cv/template/service/bootstrap/KnowledgeTemplateServiceApplication.java`
- Create: `knowledge-hub/knowledge-template/knowledge-template-service/knowledge-template-service-bootstrap/src/main/resources/application.yml`

- [ ] Build the three-way `api/core/bootstrap` split under a template service aggregator.
- [ ] Keep dependencies minimal and aligned with existing `knowledge-parent` conventions.
- [ ] Add a minimal Spring Boot bootstrap app so future services have a clear executable reference.

### Task 7: Verify structure and buildability

**Files:**
- Verify: `knowledge-infra` deployment configs
- Verify: `knowledge-hub/pom.xml`
- Verify: `knowledge-hub/knowledge-template/**`

- [ ] Read back the edited deployment files to confirm naming consistency.
- [ ] Run a targeted Maven validation for `knowledge-template`.
- [ ] Summarize any intentionally unverified runtime pieces, especially services that are only reserved skeletons.
