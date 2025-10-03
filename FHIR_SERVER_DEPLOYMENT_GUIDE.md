# FHIR Server Deployment Guide
**iOS Lifestyle Medicine Implementation Guide - HEADS2 FMUP**

Last Updated: October 2025
Project: `iOS-Lifestyle-Medicine` (FHIR R4)

---

## 1. Quick Comparison Matrix

| Option | Type | Cost/Month (EUR) | Setup Time | Pros | Cons | Best For |
|--------|------|-----------------|------------|------|------|----------|
| **HAPI FHIR** | Self-hosted OSS | €0-200 | 4-8h | Full control, free software, active community, custom validation | Maintenance overhead, requires DevOps skills | Development, testing, custom workflows |
| **Azure Health Data Services** | Cloud PaaS | €100-500 | 1-2h | Fully managed, GDPR/HIPAA compliant, EU regions, HA built-in | Vendor lock-in, recurring costs, limited customization | Production EU deployments |
| **Google Cloud Healthcare API** | Cloud PaaS | €80-400 | 1-2h | GCP integration, managed, ML/AI tools | US-centric, vendor lock-in | GCP-native projects |
| **AWS HealthLake** | Cloud PaaS | €150-600 | 2h | Analytics built-in, AWS ecosystem | US regions only, expensive, complex pricing | Analytics-heavy workloads |
| **Smile CDR** | Commercial | €1000+ | 1-2h | Enterprise support, performance, Canadian | Expensive, proprietary | Enterprise production |
| **GitHub Pages** | Static IG hosting | €0 | 30min | Free, simple, version control | No FHIR API, static only | IG documentation |

**Recommendation for this project:** Start with GitHub Pages (FREE) for IG documentation, then HAPI FHIR on VPS (€20-50/month) for development/testing.

---

## 2. HAPI FHIR Quick Start (Recommended)

### Why HAPI FHIR?
- **Open source** and free (Apache 2.0 license)
- **Most popular** FHIR server (used by NHS, CDC, others)
- **Custom IG support** - load your `package.tgz` directly
- **Active development** - regular updates, security patches
- **Flexible deployment** - Docker, JAR, Kubernetes

### Option A: Docker Compose (Fastest - 15 minutes)

**Prerequisites:**
- Docker & Docker Compose installed
- 4GB RAM minimum
- Port 8080 available

**1. Create `docker-compose.yml`:**

```yaml
version: '3.8'

services:
  hapi-fhir:
    image: hapiproject/hapi:latest
    container_name: hapi-fhir-server
    ports:
      - "8080:8080"
    environment:
      # Database configuration
      spring.datasource.url: jdbc:postgresql://db:5432/hapi
      spring.datasource.username: admin
      spring.datasource.password: admin
      spring.datasource.driverClassName: org.postgresql.Driver
      spring.jpa.properties.hibernate.dialect: ca.uhn.fhir.jpa.model.dialect.HapiFhirPostgres94Dialect

      # HAPI FHIR configuration
      hapi.fhir.server_address: http://localhost:8080/fhir
      hapi.fhir.fhir_version: R4
      hapi.fhir.allow_multiple_delete: false
      hapi.fhir.allow_external_references: true
      hapi.fhir.allow_cascading_deletes: true
      hapi.fhir.allow_contains_searches: true

      # Validation
      hapi.fhir.validation_requests_enabled: true
      hapi.fhir.enforce_referential_integrity_on_write: true
      hapi.fhir.enforce_referential_integrity_on_delete: true

      # Performance
      hapi.fhir.max_page_size: 200
      hapi.fhir.default_page_size: 20

      # Subscription (for notifications)
      hapi.fhir.subscription.resthook_enabled: true
      hapi.fhir.subscription.email.enabled: false

      # CORS (adjust for production)
      hapi.fhir.cors.allowed_origin: "*"

    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    container_name: hapi-postgres
    environment:
      POSTGRES_DB: hapi
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
    volumes:
      - postgres-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres-data:
```

**2. Start the server:**

```bash
# Navigate to directory with docker-compose.yml
cd /path/to/deployment

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f hapi-fhir

# Wait ~30 seconds for startup
# Server ready when you see: "Started Application in X seconds"
```

**3. Test the server:**

```bash
# Get server metadata
curl http://localhost:8080/fhir/metadata

# Create a test Patient
curl -X POST http://localhost:8080/fhir/Patient \
  -H "Content-Type: application/fhir+json" \
  -d '{
    "resourceType": "Patient",
    "name": [{"given": ["Test"], "family": "Patient"}]
  }'

# Search for patients
curl http://localhost:8080/fhir/Patient
```

**4. Load your Implementation Guide:**

HAPI FHIR supports loading IGs via the admin UI or API.

**Via Web UI:**
1. Navigate to `http://localhost:8080`
2. Go to "Server Configuration" → "Package Registry"
3. Upload your `/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz`

**Via API (programmatic):**

```bash
# Upload the IG package
curl -X POST http://localhost:8080/fhir/\$upload-external-code-system \
  -H "Content-Type: application/gzip" \
  --data-binary "@/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz"
```

**Note:** For automatic IG loading on startup, you need to build a custom HAPI image or use configuration files. See "Advanced Configuration" below.

### Option B: Standalone JAR (Manual Setup)

**Prerequisites:**
- Java 17+ installed
- PostgreSQL 12+ database
- 8GB RAM recommended

**1. Download HAPI FHIR:**

```bash
# Get latest release
wget https://github.com/hapifhir/hapi-fhir-jpaserver-starter/releases/latest/download/ROOT.war

# Or clone and build from source
git clone https://github.com/hapifhir/hapi-fhir-jpaserver-starter.git
cd hapi-fhir-jpaserver-starter
./mvnw clean package -DskipTests
# JAR will be in target/
```

**2. Configure PostgreSQL:**

```bash
# Install PostgreSQL (Ubuntu/Debian)
sudo apt update
sudo apt install postgresql postgresql-contrib

# Create database
sudo -u postgres psql
CREATE DATABASE hapi;
CREATE USER hapiadmin WITH PASSWORD 'yourpassword';
GRANT ALL PRIVILEGES ON DATABASE hapi TO hapiadmin;
\q
```

**3. Create `application.yaml`:**

```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/hapi
    username: hapiadmin
    password: yourpassword
    driverClassName: org.postgresql.Driver
  jpa:
    properties:
      hibernate.dialect: ca.uhn.fhir.jpa.model.dialect.HapiFhirPostgres94Dialect
      hibernate.search.enabled: true

hapi:
  fhir:
    server_address: http://localhost:8080/fhir
    fhir_version: R4
    validation_requests_enabled: true
    allow_external_references: true
```

**4. Run the server:**

```bash
java -jar -Xmx4g ROOT.war --spring.config.location=application.yaml
```

### Option C: Cloud VPS Deployment (Production-Ready)

**Recommended providers for EU deployment:**
- **Hetzner Cloud** (Germany) - €20-50/month - GDPR compliant
- **DigitalOcean** (Frankfurt/Amsterdam) - €24-48/month
- **Azure VM** (West Europe) - €50-100/month
- **OVH** (France) - €15-40/month

**Quick setup on Ubuntu 22.04 VPS:**

```bash
# 1. Initial server setup
ssh root@your-server-ip
apt update && apt upgrade -y
apt install docker.io docker-compose nginx certbot python3-certbot-nginx -y
systemctl enable docker

# 2. Create deployment directory
mkdir -p /opt/hapi-fhir
cd /opt/hapi-fhir

# 3. Copy docker-compose.yml (from Option A above)
nano docker-compose.yml
# Paste the docker-compose configuration

# 4. Update environment variables for production
# Change passwords, set proper server_address

# 5. Start HAPI FHIR
docker-compose up -d

# 6. Configure Nginx reverse proxy
cat > /etc/nginx/sites-available/hapi-fhir <<EOF
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        # Increase timeout for large FHIR operations
        proxy_read_timeout 300s;
        proxy_connect_timeout 75s;
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/hapi-fhir /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx

# 7. Setup SSL with Let's Encrypt
certbot --nginx -d your-domain.com

# 8. Configure firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

**Your HAPI FHIR server is now running at:** `https://your-domain.com/fhir`

### Resource Requirements

| Environment | CPU | RAM | Storage | Expected Load |
|-------------|-----|-----|---------|---------------|
| **Development** | 2 cores | 4GB | 20GB | <10 users, <1000 resources |
| **Testing** | 2-4 cores | 8GB | 50GB | <50 users, <10k resources |
| **Production (Small)** | 4 cores | 16GB | 100GB | <200 users, <100k resources |
| **Production (Medium)** | 8 cores | 32GB | 500GB | <1000 users, <1M resources |

### Advanced Configuration

#### Custom IG Auto-Loading

Create `src/main/resources/application.yaml` in HAPI source:

```yaml
hapi:
  fhir:
    implementationguides:
      ios-lifestyle:
        name: ios.lifestyle.medicine
        version: 0.1.0
        packageUrl: https://your-domain.com/ig/package.tgz
        reloadExisting: false
```

Then rebuild and deploy.

#### Performance Tuning

```yaml
spring:
  jpa:
    properties:
      hibernate.jdbc.batch_size: 20
      hibernate.cache.use_query_cache: true
      hibernate.cache.use_second_level_cache: true

hapi:
  fhir:
    reuse_cached_search_results_millis: 60000
    max_page_size: 500
    default_page_size: 20

    # Enable search caching
    advanced_lucene_indexing: true
```

#### Security Headers (Nginx)

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;
add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
```

---

## 3. Cloud Managed Services

### Azure Health Data Services (AHDS)

**Best for:** Production deployments in EU, GDPR compliance, enterprise support

**Setup Steps:**

**1. Prerequisites:**
- Azure account with active subscription
- Azure CLI installed (`az cli`)

**2. Create Resource Group:**

```bash
# Login
az login

# Set subscription
az account set --subscription "Your-Subscription-Name"

# Create resource group in EU region
az group create \
  --name rg-fhir-lifestyle \
  --location westeurope
```

**3. Create FHIR Service:**

```bash
# Create AHDS workspace
az healthcareapis workspace create \
  --resource-group rg-fhir-lifestyle \
  --name lifestyle-medicine-workspace \
  --location westeurope

# Create FHIR service
az healthcareapis workspace fhir-service create \
  --resource-group rg-fhir-lifestyle \
  --workspace-name lifestyle-medicine-workspace \
  --name lifestyle-fhir \
  --kind fhir-R4 \
  --location westeurope \
  --identity-type SystemAssigned
```

**4. Configure Authentication:**

```bash
# Get service principal
FHIR_URL=$(az healthcareapis workspace fhir-service show \
  --resource-group rg-fhir-lifestyle \
  --workspace-name lifestyle-medicine-workspace \
  --name lifestyle-fhir \
  --query "properties.authenticationConfiguration.audience" -o tsv)

# Assign access (your user)
MY_USER_ID=$(az ad signed-in-user show --query id -o tsv)

az role assignment create \
  --assignee $MY_USER_ID \
  --role "FHIR Data Contributor" \
  --scope /subscriptions/$(az account show --query id -o tsv)/resourceGroups/rg-fhir-lifestyle
```

**5. Get Access Token and Test:**

```bash
# Get token
TOKEN=$(az account get-access-token \
  --resource=$FHIR_URL \
  --query accessToken -o tsv)

# Test API
FHIR_ENDPOINT=$(az healthcareapis workspace fhir-service show \
  --resource-group rg-fhir-lifestyle \
  --workspace-name lifestyle-medicine-workspace \
  --name lifestyle-fhir \
  --query "properties.serviceUrl" -o tsv)

curl -X GET "$FHIR_ENDPOINT/metadata" \
  -H "Authorization: Bearer $TOKEN"
```

**6. Load Implementation Guide:**

Azure AHDS does not directly support custom IG loading via package upload. You need to:
- Use the FHIR API to upload profiles/resources individually, OR
- Use the `$import` operation to bulk load from Azure Blob Storage

**Pricing (West Europe):**
- **Structured data**: €0.45 per GB/month stored
- **API requests**: €0.35 per 1000 requests
- **Typical cost**: €100-500/month depending on usage

**GDPR Compliance:**
- Data residency: Choose `westeurope` or other EU region
- Data Processing Agreement (DPA) included with Azure subscription
- BAA available for HIPAA compliance

### Google Cloud Healthcare API

**Setup (Condensed):**

```bash
# Enable API
gcloud services enable healthcare.googleapis.com

# Create dataset
gcloud healthcare datasets create lifestyle-medicine \
  --location=europe-west4

# Create FHIR store
gcloud healthcare fhir-stores create lifestyle-fhir-r4 \
  --dataset=lifestyle-medicine \
  --location=europe-west4 \
  --version=R4

# Get endpoint
gcloud healthcare fhir-stores describe lifestyle-fhir-r4 \
  --dataset=lifestyle-medicine \
  --location=europe-west4
```

**Pricing:** €80-400/month (similar to Azure)

### AWS HealthLake

**Note:** AWS HealthLake is primarily US-based. EU deployment options are limited.

```bash
# Create FHIR datastore (us-east-1)
aws healthlake create-fhir-datastore \
  --datastore-name lifestyle-medicine \
  --datastore-type-version R4 \
  --region us-east-1
```

**Pricing:** €150-600/month (higher than Azure/GCP)

---

## 4. Implementation Guide Hosting Strategy

### Two-Tier Approach (Recommended)

**Tier 1: Static IG Documentation (GitHub Pages) - FREE**

**Purpose:** Host the HTML documentation, profiles, examples, and specification

**Setup (5 minutes):**

```bash
# In your project directory
cd /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP

# Initialize git if not already done
git init
git add .
git commit -m "Initial commit"

# Create GitHub repository (via gh CLI or web)
gh repo create iOS_Lifestyle_Medicine_HEADS2_FMUP --public --source=. --remote=origin

# Push code
git push -u origin main

# Enable GitHub Pages
# Option A: Via gh CLI
gh api repos/ricardolsantos/iOS_Lifestyle_Medicine_HEADS2_FMUP/pages \
  -X POST \
  -f source[branch]=main \
  -f source[path]=/output

# Option B: Via GitHub web UI
# 1. Go to repository Settings
# 2. Navigate to "Pages"
# 3. Source: Deploy from branch "main", folder "/output"
# 4. Save

# Your IG will be available at:
# https://ricardolsantos.github.io/iOS_Lifestyle_Medicine_HEADS2_FMUP/
```

**Update workflow:**

```bash
# After making changes to FSH files
./_genonce.sh

# Commit and push
git add output/
git commit -m "Update IG"
git push

# GitHub Pages auto-updates in 1-2 minutes
```

**Tier 2: FHIR API Server (HAPI FHIR on VPS) - €20-50/month**

**Purpose:** Provide actual FHIR API for data operations, testing, validation

**Recommended setup:**
- Hetzner Cloud CX21 (€5.83/month) or CPX31 (€12.90/month)
- Use Docker Compose deployment from Section 2
- Point domain like `fhir.your-domain.com` to the server

**Architecture:**

```
┌─────────────────────────────────────────────────┐
│  GitHub Pages (FREE)                            │
│  https://you.github.io/project/                 │
│  - IG Documentation                             │
│  - Profiles, ValueSets                          │
│  - Examples (read-only)                         │
└─────────────────────────────────────────────────┘
                    ↓ (link to)
┌─────────────────────────────────────────────────┐
│  HAPI FHIR on VPS (€20-50/month)                │
│  https://fhir.your-domain.com/fhir              │
│  - Full FHIR API (CRUD)                         │
│  - Validation endpoint                          │
│  - Search/Query                                 │
│  - Custom IG loaded                             │
└─────────────────────────────────────────────────┘
```

### Single-Tier Options

**Option A: GitHub Pages Only** (FREE, documentation-only)
- No FHIR API
- Suitable for specification publication
- Zero maintenance

**Option B: Cloud Provider Only** (€100-500/month)
- Use Azure Static Web Apps + AHDS
- Both static site and FHIR API
- Fully managed, no maintenance

**Option C: VPS Only** (€30-60/month)
- HAPI FHIR + Nginx serving static IG
- Single server for everything
- More maintenance required

---

## 5. Security Essentials

### SSL/TLS (MANDATORY for production)

**Free SSL with Let's Encrypt:**

```bash
# Install certbot (Ubuntu)
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d fhir.your-domain.com

# Auto-renewal (already configured by certbot)
# Test renewal:
sudo certbot renew --dry-run
```

**Force HTTPS in Nginx:**

```nginx
server {
    listen 80;
    server_name fhir.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name fhir.your-domain.com;

    ssl_certificate /etc/letsencrypt/live/fhir.your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/fhir.your-domain.com/privkey.pem;

    # Modern SSL configuration
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://localhost:8080;
        # ... rest of proxy config
    }
}
```

### OAuth 2.0 / OpenID Connect

**Why OAuth?**
- Required for production FHIR servers
- SMART on FHIR standard for healthcare apps
- Supports user authentication + authorization

**Option A: Keycloak (Open Source, Recommended)**

**Docker Compose with Keycloak:**

```yaml
version: '3.8'

services:
  keycloak:
    image: quay.io/keycloak/keycloak:23.0
    container_name: keycloak
    environment:
      KEYCLOAK_ADMIN: admin
      KEYCLOAK_ADMIN_PASSWORD: admin
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://db:5432/keycloak
      KC_DB_USERNAME: admin
      KC_DB_PASSWORD: admin
      KC_HOSTNAME: auth.your-domain.com
      KC_PROXY: edge
    command: start
    ports:
      - "8180:8080"
    depends_on:
      - db
    restart: unless-stopped

  hapi-fhir:
    image: hapiproject/hapi:latest
    # ... (same as before)
    environment:
      # Add OAuth configuration
      hapi.fhir.security.oauth_enabled: true
      hapi.fhir.security.oauth_issuer_url: https://auth.your-domain.com/realms/fhir
      hapi.fhir.security.oauth_client_id: hapi-fhir-server
      # ... rest of config

  db:
    image: postgres:15-alpine
    environment:
      # Add Keycloak database
      POSTGRES_MULTIPLE_DATABASES: hapi,keycloak
    # ... rest of config
```

**Keycloak Setup (Quick):**

1. Access Keycloak at `http://localhost:8180`
2. Login with admin/admin
3. Create new realm: "fhir"
4. Create client: "hapi-fhir-server"
   - Client Protocol: openid-connect
   - Access Type: confidential
   - Valid Redirect URIs: `https://fhir.your-domain.com/*`
5. Create users and roles
6. Configure SMART on FHIR scopes (patient/*.read, user/*.*, etc.)

**Option B: Azure Active Directory (Managed)**

If using Azure AHDS, use Azure AD:
- Built-in integration
- No extra setup needed
- Enterprise-grade

**Option C: Auth0 / Okta (Managed SaaS)**

- €0-100/month for small deployments
- Easy integration with HAPI FHIR
- SMART on FHIR support

### GDPR Compliance Checklist

**For EU deployment, you MUST:**

- [ ] **Data Residency:** Host server in EU region (Germany, France, Netherlands)
- [ ] **Encryption at Rest:** Database encryption enabled
- [ ] **Encryption in Transit:** HTTPS/TLS 1.2+ only
- [ ] **Access Controls:** OAuth 2.0, role-based access (RBAC)
- [ ] **Audit Logging:** Enable FHIR AuditEvent logging
  ```yaml
  hapi.fhir.audit_event_log_enabled: true
  ```
- [ ] **Data Processing Agreement (DPA):** Sign with cloud provider if using Azure/GCP
- [ ] **Privacy Policy:** Document how PHI is processed
- [ ] **Right to Erasure:** Implement patient data deletion endpoint
- [ ] **Data Breach Notification:** 72-hour notification process
- [ ] **Data Minimization:** Only collect necessary data
- [ ] **Consent Management:** Implement IHE PCF consent profiles (already in your IG dependencies)

**HAPI FHIR GDPR Features:**

```yaml
# Audit logging
hapi.fhir.audit_event_log_enabled: true

# Data expiry (auto-delete old data)
hapi.fhir.expunge_enabled: true

# Consent enforcement
hapi.fhir.consent.enabled: true
```

**Recommended GDPR-compliant VPS providers:**
- **Hetzner** (Germany) - Strong GDPR compliance, DPA available
- **OVH** (France) - EU-based, GDPR-first
- **Scaleway** (France) - EU data centers

### Rate Limiting & DDoS Protection

**Nginx rate limiting:**

```nginx
# Add to http block
limit_req_zone $binary_remote_addr zone=fhir_limit:10m rate=10r/s;

# Add to location block
location /fhir {
    limit_req zone=fhir_limit burst=20 nodelay;
    # ... rest of proxy config
}
```

**Cloudflare (Free tier):**
- Add domain to Cloudflare
- Enable proxy (orange cloud)
- Free DDoS protection + CDN
- WAF rules available on paid plans

---

## 6. Validation Setup

### Validate Resources Against Your IG

**Option A: FHIR Validator CLI (Offline)**

**1. Download validator:**

```bash
# Get latest validator
wget https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar

# Or specific version
wget https://github.com/hapifhir/org.hl7.fhir.core/releases/download/6.3.3/validator_cli.jar
```

**2. Validate against your IG:**

```bash
# Validate a single resource
java -jar validator_cli.jar \
  /path/to/patient-example.json \
  -version 4.0.1 \
  -ig /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz

# Validate all examples
java -jar validator_cli.jar \
  /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/input/examples/*.json \
  -version 4.0.1 \
  -ig /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz

# Validate with specific profile
java -jar validator_cli.jar \
  patient.json \
  -version 4.0.1 \
  -ig /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz \
  -profile https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/YourProfileName
```

**3. Automation script:**

```bash
#!/bin/bash
# validate-all.sh

VALIDATOR="validator_cli.jar"
IG_PACKAGE="/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz"
EXAMPLES_DIR="/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/input/examples"

echo "Validating all examples against IG..."

for file in $EXAMPLES_DIR/*.json; do
    echo "Validating $file..."
    java -jar $VALIDATOR "$file" -version 4.0.1 -ig $IG_PACKAGE

    if [ $? -eq 0 ]; then
        echo "✓ $file is valid"
    else
        echo "✗ $file has errors"
    fi
    echo "---"
done
```

**Option B: Online Validators**

**1. Official HL7 Validator:**
- URL: https://validator.fhir.org/
- Steps:
  1. Click "IG/Package" tab
  2. Upload `/Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP/output/package.tgz`
  3. Paste JSON/XML resource
  4. Click "Validate"

**2. Simplifier.net:**
- URL: https://simplifier.net/validate
- Login required (free)
- Supports custom IGs from package URL

**Option C: HAPI FHIR $validate Endpoint**

Once your IG is loaded into HAPI FHIR:

```bash
# Validate a resource
curl -X POST http://localhost:8080/fhir/Patient/\$validate \
  -H "Content-Type: application/fhir+json" \
  -d '{
    "resourceType": "Patient",
    "name": [{"given": ["Test"], "family": "Patient"}]
  }'

# Validate against specific profile
curl -X POST "http://localhost:8080/fhir/Patient/\$validate?profile=https://2rdoc.pt/ig/ios-lifestyle-medicine/StructureDefinition/YourProfile" \
  -H "Content-Type: application/fhir+json" \
  -d @patient.json
```

### Continuous Validation (CI/CD)

**GitHub Actions workflow (`.github/workflows/validate.yml`):**

```yaml
name: Validate FHIR Resources

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  validate:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '17'

    - name: Download FHIR Validator
      run: |
        wget -q https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar

    - name: Build IG
      run: |
        ./_updatePublisher.sh -y
        ./_genonce.sh

    - name: Validate Examples
      run: |
        for file in input/examples/*.json; do
          echo "Validating $file"
          java -jar validator_cli.jar "$file" -version 4.0.1 -ig output/package.tgz || exit 1
        done

    - name: Upload validation results
      if: failure()
      uses: actions/upload-artifact@v3
      with:
        name: validation-errors
        path: '**/*.log'
```

---

## 7. Recommended Deployment Path for This Project

### Phase 1: Documentation (NOW - FREE, 1 hour)

**Goal:** Publish IG documentation for review and collaboration

**Steps:**

1. **Enable GitHub Pages:**
   ```bash
   cd /Users/ricardo/shorthand/iOS_Lifestyle_Medicine_HEADS2_FMUP

   # Push to GitHub
   git add .
   git commit -m "Publish IG documentation"
   git push origin main

   # Enable Pages via Settings → Pages → Source: main branch, /output folder
   ```

2. **Access your IG:**
   - https://yourusername.github.io/iOS_Lifestyle_Medicine_HEADS2_FMUP/

3. **Share with stakeholders:**
   - Send link to FMUP team, clinicians, developers
   - Gather feedback on profiles and use cases

**Cost:** €0
**Time:** 1 hour
**Maintenance:** None (automated via GitHub)

### Phase 2: Development Server (NEXT - €20/month, 4 hours)

**Goal:** Set up FHIR API for development, testing, iOS app integration

**Steps:**

1. **Get Hetzner VPS:**
   - Sign up at https://www.hetzner.com/cloud
   - Create CX21 server (2 vCPU, 4GB RAM, €5.83/month)
   - Location: Falkenstein or Helsinki (EU)
   - OS: Ubuntu 22.04

2. **Deploy HAPI FHIR:**
   ```bash
   # SSH into server
   ssh root@your-server-ip

   # Install Docker
   curl -fsSL https://get.docker.com | sh

   # Create deployment
   mkdir /opt/hapi-fhir
   cd /opt/hapi-fhir

   # Create docker-compose.yml (see Section 2)
   nano docker-compose.yml
   # Paste configuration from Section 2, Option A

   # Start server
   docker-compose up -d

   # Check logs
   docker-compose logs -f
   ```

3. **Configure domain:**
   - Point `fhir.your-domain.com` to server IP
   - Setup Nginx + Let's Encrypt (see Section 5)

4. **Load IG package:**
   - Upload via HAPI UI: http://your-server-ip:8080
   - Or use API as shown in Section 2

5. **Test with iOS app:**
   ```swift
   // Swift example
   let fhirURL = "https://fhir.your-domain.com/fhir"
   // Integrate FHIR client library
   ```

**Cost:** €5.83-12.90/month (Hetzner) + €10/year (domain)
**Time:** 4 hours initial setup
**Maintenance:** ~1 hour/month (updates, monitoring)

**What you get:**
- Full FHIR R4 API
- Custom IG loaded and validated
- HTTPS with valid SSL
- PostgreSQL persistence
- Ready for iOS app testing

### Phase 3A: Production (Self-Hosted) - €50-100/month, 8 hours

**Goal:** Production-ready self-hosted deployment with HA, backups, monitoring

**Steps:**

1. **Upgrade VPS:**
   - Hetzner CPX31 (4 vCPU, 8GB RAM, €12.90/month) or
   - Hetzner CCX33 (8 vCPU, 32GB RAM, €54.90/month)

2. **Add redundancy:**
   - PostgreSQL streaming replication (hot standby)
   - Load balancer (Nginx or HAProxy)
   - Automated backups to Hetzner Storage Box (€3.81/month for 100GB)

3. **Implement OAuth 2.0:**
   - Deploy Keycloak (see Section 5)
   - Configure SMART on FHIR scopes
   - Integrate with iOS app authentication

4. **Setup monitoring:**
   - Prometheus + Grafana for metrics
   - Uptime monitoring (UptimeRobot - free tier)
   - Log aggregation (ELK stack or Loki)

5. **Backup automation:**
   ```bash
   # Daily PostgreSQL backups
   0 2 * * * docker exec hapi-postgres pg_dump -U admin hapi | gzip > /backups/hapi-$(date +\%Y\%m\%d).sql.gz

   # Sync to remote
   0 3 * * * rsync -az /backups/ user@backup-server:/hapi-backups/
   ```

6. **GDPR compliance:**
   - Implement audit logging
   - Data retention policies
   - Consent management (IHE PCF)

**Cost:** €50-100/month
**Time:** 8-16 hours setup
**Maintenance:** 2-4 hours/month

**What you get:**
- Production-grade reliability (99.5%+ uptime)
- Full control and customization
- OAuth 2.0 security
- GDPR compliant
- Automated backups

### Phase 3B: Production (Managed Cloud) - €100-300/month, 2 hours

**Goal:** Fully managed production deployment with enterprise support

**Option:** Azure Health Data Services (recommended for EU/GDPR)

**Steps:**

1. **Deploy AHDS:**
   ```bash
   # See Section 3 for full commands
   az group create --name rg-fhir-prod --location westeurope
   az healthcareapis workspace create --name fhir-prod --location westeurope
   az healthcareapis workspace fhir-service create --kind fhir-R4
   ```

2. **Configure Azure AD authentication:**
   - Create App Registration
   - Assign FHIR Data Contributor roles
   - Configure SMART on FHIR scopes

3. **Setup API Management (optional):**
   - Add Azure API Management in front of FHIR service
   - Rate limiting, caching, analytics
   - Custom API policies

4. **Load IG resources:**
   - Bulk import from Azure Blob Storage
   - Or individual POST via API

5. **Monitor with Azure Monitor:**
   - Built-in metrics and alerts
   - Log Analytics integration

**Cost:** €100-300/month
**Time:** 2 hours setup
**Maintenance:** <1 hour/month (mostly managed)

**What you get:**
- 99.9% SLA uptime guarantee
- Automatic scaling
- Enterprise support
- GDPR/HIPAA compliance out-of-box
- No DevOps overhead

### Decision Matrix: Self-Hosted vs Cloud

| Factor | Self-Hosted (Phase 3A) | Managed Cloud (Phase 3B) |
|--------|------------------------|--------------------------|
| **Initial Cost** | €50-100/month | €100-300/month |
| **Setup Time** | 8-16 hours | 2 hours |
| **Maintenance** | 2-4 hours/month | <1 hour/month |
| **DevOps Skills** | Required | Not required |
| **Customization** | Full control | Limited |
| **Scaling** | Manual | Automatic |
| **Compliance** | DIY | Certified (GDPR/HIPAA) |
| **SLA** | DIY (~99.5%) | 99.9% guarantee |
| **Best For** | Tight budget, tech team | Enterprise, compliance-critical |

**Recommendation:**
- **Academic/Research:** Phase 2 (HAPI on Hetzner)
- **Commercial iOS App:** Phase 3B (Azure AHDS)
- **Open Source Community:** Phase 1 (GitHub Pages) + Phase 2

---

## 8. Key Resources & Documentation

### HAPI FHIR
- **Official Docs:** https://hapifhir.io/hapi-fhir/docs/
- **GitHub:** https://github.com/hapifhir/hapi-fhir
- **Docker Hub:** https://hub.docker.com/r/hapiproject/hapi
- **JPA Server Starter:** https://github.com/hapifhir/hapi-fhir-jpaserver-starter
- **Community:** https://chat.fhir.org/ (#hapi channel)

### Azure Health Data Services
- **Docs:** https://learn.microsoft.com/en-us/azure/healthcare-apis/
- **Pricing:** https://azure.microsoft.com/en-us/pricing/details/azure-api-for-fhir/
- **Quickstart:** https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/fhir-portal-quickstart
- **SMART on FHIR:** https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/smart-on-fhir

### FHIR Validation
- **Validator Documentation:** https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator
- **Online Validator:** https://validator.fhir.org/
- **Validator Releases:** https://github.com/hapifhir/org.hl7.fhir.core/releases
- **IG Publisher:** https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation

### Security & SMART on FHIR
- **SMART App Launch:** http://hl7.org/fhir/smart-app-launch/
- **OAuth 2.0 for FHIR:** https://docs.smarthealthit.org/
- **Keycloak FHIR Integration:** https://github.com/Alvearie/keycloak-extensions-for-fhir
- **Azure AD + FHIR:** https://learn.microsoft.com/en-us/azure/healthcare-apis/fhir/azure-active-directory-identity-configuration

### GDPR & Compliance
- **IHE PCF (Privacy Consent on FHIR):** https://profiles.ihe.net/ITI/PCF/
- **FHIR Security:** https://www.hl7.org/fhir/security.html
- **GDPR Guidance:** https://gdpr.eu/
- **EU Data Residency:** https://ec.europa.eu/info/law/law-topic/data-protection_en

### Implementation Guides
- **FHIR IG Registry:** https://registry.fhir.org/
- **Your IG (after deployment):** https://2rdoc.pt/ig/ios-lifestyle-medicine
- **IPS (International Patient Summary):** https://hl7.org/fhir/uv/ips/
- **US Core:** http://hl7.org/fhir/us/core/

### Hosting Providers (EU GDPR-Compliant)
- **Hetzner:** https://www.hetzner.com/cloud (Germany) - Recommended
- **OVH:** https://www.ovhcloud.com/en/ (France)
- **Scaleway:** https://www.scaleway.com/en/ (France)
- **DigitalOcean:** https://www.digitalocean.com/ (Frankfurt datacenter)
- **Azure:** https://azure.microsoft.com/ (West Europe region)

### Tools
- **SUSHI (FSH compiler):** https://github.com/FHIR/sushi
- **FSH Online:** https://fshschool.org/FSHOnline/
- **Postman FHIR Collection:** https://www.postman.com/fhir
- **Insomnia:** https://insomnia.rest/ (REST client)

### iOS Development
- **FHIR Swift SDK:** https://github.com/smart-on-fhir/Swift-FHIR
- **Apple HealthKit + FHIR:** https://developer.apple.com/documentation/healthkit
- **SMART on FHIR iOS:** https://github.com/smart-on-fhir/Swift-SMART

---

## 9. Quick Reference Commands

### Docker Management

```bash
# Start HAPI FHIR
docker-compose up -d

# Stop server
docker-compose down

# View logs
docker-compose logs -f hapi-fhir

# Restart after config change
docker-compose restart hapi-fhir

# Update to latest image
docker-compose pull
docker-compose up -d

# Backup database
docker exec hapi-postgres pg_dump -U admin hapi > backup.sql

# Restore database
docker exec -i hapi-postgres psql -U admin hapi < backup.sql
```

### FHIR API Testing

```bash
# Get server capabilities
curl http://localhost:8080/fhir/metadata

# Create resource
curl -X POST http://localhost:8080/fhir/Patient \
  -H "Content-Type: application/fhir+json" \
  -d @patient.json

# Read resource
curl http://localhost:8080/fhir/Patient/123

# Update resource
curl -X PUT http://localhost:8080/fhir/Patient/123 \
  -H "Content-Type: application/fhir+json" \
  -d @patient-updated.json

# Delete resource
curl -X DELETE http://localhost:8080/fhir/Patient/123

# Search
curl "http://localhost:8080/fhir/Patient?name=Smith"

# Validate
curl -X POST http://localhost:8080/fhir/Patient/\$validate \
  -H "Content-Type: application/fhir+json" \
  -d @patient.json
```

### IG Building

```bash
# Update publisher
./_updatePublisher.sh

# Build IG
./_genonce.sh

# Validate specific resource
java -jar input-cache/validator_cli.jar \
  input/examples/patient-example.json \
  -version 4.0.1 \
  -ig output/package.tgz
```

### SSL/TLS

```bash
# Get Let's Encrypt certificate
sudo certbot --nginx -d fhir.your-domain.com

# Test renewal
sudo certbot renew --dry-run

# Check certificate expiry
echo | openssl s_client -servername fhir.your-domain.com -connect fhir.your-domain.com:443 2>/dev/null | openssl x509 -noout -dates
```

### Server Monitoring

```bash
# Check server status
systemctl status docker

# View resource usage
docker stats

# Check disk space
df -h

# Check memory
free -h

# View active connections
netstat -an | grep :8080
```

---

## 10. Troubleshooting

### HAPI FHIR Won't Start

**Symptom:** Container exits immediately

```bash
# Check logs
docker-compose logs hapi-fhir

# Common issues:
# 1. Database not ready - wait 30s and retry
# 2. Port 8080 in use - change port in docker-compose.yml
# 3. Memory issues - increase Docker memory limit
```

**Fix:**

```bash
# Kill process using port 8080
sudo lsof -ti:8080 | xargs kill -9

# Or change port in docker-compose.yml
ports:
  - "8888:8080"  # Access via localhost:8888
```

### IG Not Loading

**Symptom:** Validation fails, profiles not found

```bash
# Check if IG is loaded
curl http://localhost:8080/fhir/StructureDefinition

# Manually upload via API
curl -X POST http://localhost:8080/fhir/\$upload-external-code-system \
  -H "Content-Type: application/gzip" \
  --data-binary "@output/package.tgz"
```

### Database Connection Errors

**Symptom:** `Connection refused` or `Authentication failed`

```bash
# Check if PostgreSQL is running
docker-compose ps

# Reset database
docker-compose down -v  # WARNING: Deletes all data
docker-compose up -d

# Check connection
docker exec -it hapi-postgres psql -U admin -d hapi
```

### Performance Issues

**Symptom:** Slow queries, timeouts

```bash
# Check resource usage
docker stats

# Increase memory
# In docker-compose.yml:
services:
  hapi-fhir:
    environment:
      JAVA_OPTS: "-Xmx4g -Xms2g"

# Enable query caching
hapi.fhir.reuse_cached_search_results_millis: 60000
```

### SSL Certificate Issues

**Symptom:** `NET::ERR_CERT_AUTHORITY_INVALID`

```bash
# Check certificate
sudo certbot certificates

# Renew if expired
sudo certbot renew --force-renewal

# Restart Nginx
sudo systemctl restart nginx
```

---

## Conclusion

This guide provides everything needed to deploy your **iOS Lifestyle Medicine Implementation Guide** from development to production.

**Quick Start Recommendations:**

1. **Today (FREE):** Deploy IG to GitHub Pages for documentation
2. **This Week (€20/month):** Set up HAPI FHIR on Hetzner for development
3. **Production (€100+/month):** Choose Azure AHDS for managed or HAPI HA for self-hosted

**Total estimated costs:**
- **Development:** €0-20/month
- **Small Production:** €50-100/month (self-hosted)
- **Enterprise Production:** €100-500/month (managed cloud)

**Need help?**
- FHIR Community Chat: https://chat.fhir.org/
- HAPI FHIR Discussions: https://github.com/hapifhir/hapi-fhir/discussions
- Stack Overflow: Tag `fhir` or `hapi-fhir`

**Your next steps:**
1. Enable GitHub Pages (Section 7, Phase 1)
2. Review comparison matrix (Section 1)
3. Choose deployment path (Section 7)
4. Follow quick start guide (Section 2)

Good luck with your deployment!
