#!/bin/bash
# Install git hooks for automated CI triggers

HOOK_DIR=".git/hooks"
POST_COMMIT="$HOOK_DIR/post-commit"

echo "[HOOKS] Setting up git post-commit hook..."

mkdir -p "$HOOK_DIR"

cat > "$POST_COMMIT" << 'EOF'
#!/bin/bash
# Trigger Jenkins build on commit

JENKINS_URL="http://localhost:8080"
JOB_NAME="ACEest-CI"
USER="admin"
PASS="admin"

# Check if Jenkins is reachable
if curl --output /dev/null --silent --head --fail "$JENKINS_URL"; then
    echo "[CI] Triggering Jenkins build..."
    
    # Get Crumb (CSRF Protection)
    CRUMB=$(curl -u "$USER:$PASS" -c cookie.jar -s "$JENKINS_URL/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")
    
    # Trigger Build
    RESPONSE=$(curl -u "$USER:$PASS" -b cookie.jar -H "$CRUMB" -X POST "$JENKINS_URL/job/$JOB_NAME/build" -w "%{http_code}" -o /dev/null -s)
    
    rm -f cookie.jar

    if [[ "$RESPONSE" == "201" ]]; then
        echo "[CI] Build triggered successfully! 🚀"
        echo "[CI] Monitor at: $JENKINS_URL/job/$JOB_NAME/"
    else
        echo "[CI] Failed to trigger build. HTTP Status: $RESPONSE"
    fi
else
    echo "[CI] Jenkins not reachable. Skipping build trigger."
fi
EOF

chmod +x "$POST_COMMIT"
echo "[HOOKS] Setup complete. Jenkins will now build automatically on every commit."