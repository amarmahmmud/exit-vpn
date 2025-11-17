#!/bin/bash

# Ensure env var is set
if [ -z "$TAILSCALE_AUTHKEY" ]; then
  echo "Error: TAILSCALE_AUTHKEY environment variable is not set."
  exit 1
fi

# Start tailscaled in userspace mode (background)
tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock --port=41641 &

# Wait for daemon to start
sleep 5

# Authenticate and advertise as exit node
tailscale up --authkey="$TAILSCALE_AUTHKEY" --advertise-exit-node

# Keep the script running if needed (but since it's backgrounded, the container continues)
wait
