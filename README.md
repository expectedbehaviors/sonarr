# Sonarr Helm Chart

Baseline Helm chart for [Sonarr](https://sonarr.tv) (TV series manager). Uses the [bjw-s app-template](https://github.com/bjw-s/app-template) with PostgreSQL and 1Password items.

## Subcharts

| Subchart | Source | Values prefix | Description |
|----------|--------|---------------|-------------|
| **sonarr** (app-template) | [bjw-s helm-charts](https://github.com/bjw-s/helm-charts) | `sonarr.*` | App template: controllers, persistence, ingress, env. |
| **postgresql** | [Bitnami](https://github.com/bitnami/charts) | `postgresql.*` | Embedded PostgreSQL (optional; `postgresql.enabled`). |
| **onepassworditem** | [expectedbehaviors/OnePasswordItem-helm](https://github.com/expectedbehaviors/OnePasswordItem-helm) | `onepassworditem.*` | Optional secrets sync. |

## PostgreSQL options

| Option | Toggle | Default | Description |
|--------|--------|---------|-------------|
| **Bitnami PostgreSQL** | `postgresql.enabled` | `true` | Embedded Bitnami subchart. Set `false` when using operator or external DB. |
| **CloudNativePG operator** | `postgresqlOperator.enabled` | `false` | Creates a `PostgresCluster` CRD. Requires CloudNativePG operator. Set `postgresql.enabled: false` when enabled. |
| **External DB** | Both `false` | — | Use `externalSecrets.configXml.postgresHost` (and credentials) to point at your own PostgreSQL. |

When using `postgresqlOperator`, set `postgresqlOperator.bootstrap.existingSecret` to a Secret with `password` key. The cluster service will be `{{ postgresqlOperator.clusterName }}-rw.{{ Release.Namespace }}.svc.cluster.local`.

## ExternalSecrets (config.xml)

When `externalSecrets.enabled: true`, the chart creates an ExternalSecret that syncs `config.xml` from 1Password.

- `externalSecrets.configXml.databaseMode` supports `auto`, `sqlite`, `postgres`, `external-postgres`.
- In `auto`, Postgres tags are rendered only when Bitnami/PostgresOperator is enabled or an explicit `postgresHost` is provided.
- In `sqlite`, all Postgres tags are omitted from `config.xml`.
- Use `externalSecrets.configXml.enablePostgres` as an explicit override switch.

## Key values

| Area | Where | What to set |
|------|--------|-------------|
| Ingress | `sonarr.ingress.main.hosts` | Host and TLS for your domain. |
| Persistence | `sonarr.persistence` | `existingClaim` for media/downloads. |
| PostgreSQL | `postgresql.*` or `postgresqlOperator.*` | Auth, storage, or operator cluster. |
| ExternalSecrets | `externalSecrets.*` | 1Password refs for config.xml. |

## Install

```bash
helm dependency update
helm install sonarr . -f my-values.yaml -n sonarr --create-namespace
```

From Helm repo:

```bash
helm repo add expectedbehaviors https://expectedbehaviors.github.io/sonarr
helm install sonarr expectedbehaviors/sonarr -f my-values.yaml -n sonarr --create-namespace
```

## Render & validation

```bash
helm dependency update . && helm template sonarr . -f values.yaml -n sonarr
```

## Argo CD

Point your Application at this repo (path: `.`) and pass your values. Namespace typically `sonarr`.

## Recommended resources

- **Official docs:** https://sonarr.tv/#downloads-v3
- **Servarr wiki:** https://wiki.servarr.com/sonarr
- **TRaSH Guides (Sonarr):** https://trash-guides.info/Sonarr/
- **Recyclarr docs:** https://recyclarr.dev/wiki/
