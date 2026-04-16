#!/usr/bin/env bash
# Security Audit Script — Daily check for leaked sensitive information
# Repository: iOS Lifestyle Medicine FHIR IG (PUBLIC on GitHub)
# Created: 2026-04-15 by T2 S14
# Usage: ./scripts/security_audit.sh [--fix]
#   --fix: automatically stage .gitignore additions for flagged files

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Directories to exclude from scanning (build artifacts, templates)
EXCLUDE=':!scripts/security_audit.sh :!qa_comparison/ :!output/ :!template/ :!fsh-generated/ :!*.html'

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'
FOUND=0
REPORT=""

log_finding() {
    local severity="$1" file="$2" line="$3" desc="$4"
    FOUND=$((FOUND + 1))
    if [ "$severity" = "HIGH" ]; then
        REPORT+="${RED}[HIGH]${NC} ${file}:${line} — ${desc}\n"
    else
        REPORT+="${YELLOW}[WARN]${NC} ${file}:${line} — ${desc}\n"
    fi
}

echo "=== Security Audit: $(date '+%Y-%m-%d %H:%M:%S') ==="
echo "Repository: $REPO_ROOT"
echo ""

# 1. API Keys & Tokens (common patterns)
echo "Checking API keys and tokens..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "HIGH" "$file" "$line" "Possible API key/token: $(echo "$content" | head -c 80)"
done < <(git grep -n -E '(sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|ghu_[a-zA-Z0-9]{36}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35})' -- $EXCLUDE 2>/dev/null || true)

# 2. Passwords & Secrets in tracked files
echo "Checking passwords and secrets..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "HIGH" "$file" "$line" "Possible password: $(echo "$content" | head -c 80)"
done < <(git grep -n -i -E '(password|passwd|pwd|secret|credential)\s*[:=]\s*["\x27][^"\x27]{3,}' -- ':!scripts/security_audit.sh' ':!*.md' ':!input/pagecontent/*.md' 2>/dev/null || true)

# 3. Private file paths (local system disclosure)
echo "Checking private file paths..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "WARN" "$file" "$line" "Local path disclosure: $(echo "$content" | head -c 80)"
done < <(git grep -n -E '(/Users/[a-zA-Z]+/|/home/[a-zA-Z]+/|C:\\Users\\)' -- ':!scripts/security_audit.sh' ':!.gitignore' 2>/dev/null || true)

# 4. SSH/PGP private keys
echo "Checking for private keys..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "HIGH" "$file" "$line" "Private key material detected!"
done < <(git grep -n -E '(BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY|BEGIN PGP PRIVATE)' -- $EXCLUDE 2>/dev/null || true)

# 5. Environment files tracked
echo "Checking for tracked .env files..."
for envfile in $(git ls-files '*.env' '.env*' '*.key' '*.pem' '*.p12' '*.pfx' '*.jks' 2>/dev/null); do
    log_finding "HIGH" "$envfile" "0" "Sensitive file type tracked in git"
done

# 6. Hardcoded IP addresses (internal network)
echo "Checking for internal IPs..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "WARN" "$file" "$line" "Internal IP: $(echo "$content" | head -c 80)"
done < <(git grep -n -E '(10\.[0-9]+\.[0-9]+\.[0-9]+|172\.(1[6-9]|2[0-9]|3[01])\.[0-9]+\.[0-9]+|192\.168\.[0-9]+\.[0-9]+)' -- ':!scripts/security_audit.sh' ':!*.md' 2>/dev/null || true)

# 7. JWT tokens
echo "Checking for JWT tokens..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "HIGH" "$file" "$line" "Possible JWT: $(echo "$content" | head -c 80)"
done < <(git grep -n -E 'eyJ[A-Za-z0-9_-]{10,}\.' -- $EXCLUDE 2>/dev/null || true)

# 8. Personal information (beyond publisher metadata)
echo "Checking for personal information..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    # Skip sushi-config.yaml publisher section (intentional)
    [[ "$file" == "sushi-config.yaml" ]] && continue
    [[ "$file" == "input/pagecontent/"* ]] && continue
    log_finding "WARN" "$file" "$line" "Personal identifier: $(echo "$content" | head -c 80)"
done < <(git grep -n -E '(\+351[0-9]{9}|NIF[: ][0-9]{9}|CC[: ][0-9]{8})' -- $EXCLUDE 2>/dev/null || true)

# 9. Copyright-sensitive: large blocks of copied text (heuristic: files >50KB in pagecontent)
echo "Checking for unusually large content files..."
for f in $(git ls-files 'input/pagecontent/*.md'); do
    size=$(wc -c < "$f" 2>/dev/null || echo 0)
    if [ "$size" -gt 51200 ]; then
        log_finding "WARN" "$f" "0" "Large content file (${size} bytes) — verify copyright compliance"
    fi
done

# 10. Google Analytics / tracking IDs accidentally committed
echo "Checking for tracking IDs..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "WARN" "$file" "$line" "Tracking ID: $(echo "$content" | head -c 80)"
done < <(git grep -n -E 'G-[A-Z0-9]{10}|UA-[0-9]{6,}-[0-9]|GTM-[A-Z0-9]{6,}' -- $EXCLUDE 2>/dev/null || true)

# 11. Database connection strings
echo "Checking for database connection strings..."
while IFS=: read -r file line content; do
    [ -z "$file" ] && continue
    log_finding "HIGH" "$file" "$line" "DB connection string: $(echo "$content" | head -c 80)"
done < <(git grep -n -E '(mongodb|mysql|postgres|redis)://[^/]+:[^@]+@' -- $EXCLUDE 2>/dev/null || true)

echo ""
echo "=== Results ==="
if [ "$FOUND" -eq 0 ]; then
    echo -e "${GREEN}PASS${NC}: No sensitive information detected in tracked files."
else
    echo -e "${RED}FOUND $FOUND issue(s):${NC}"
    echo -e "$REPORT"
    echo ""
    echo "Review each finding. For false positives, add to .gitignore or exclude in this script."
fi

echo ""
echo "Audit complete: $(date '+%Y-%m-%d %H:%M:%S')"
exit $FOUND
