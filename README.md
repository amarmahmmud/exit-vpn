# noVNC Desktop with Tailscale Exit Node

This repo deploys a noVNC-enabled Ubuntu desktop on Render, with Tailscale integrated as an exit node. It uses an environment variable `TAILSCALE_AUTHKEY` for authentication.

## Prerequisites
- A Tailscale account (sign up at tailscale.com).
- Generate a reusable auth key in your Tailscale admin console (Settings > Keys > Generate auth key > Reusable).
- A GitHub account and this repo cloned/pushed.

## Deployment on Render
1. Go to render.com and create a new "Web Service" (free tier works for testing).
2. Connect your GitHub repo (authorize Render to access it).
3. Select "Docker" as the runtime.
4. Set the branch to `main` (or your default).
5. Under "Environment", add a key-value pair: Key = `TAILSCALE_AUTHKEY`, Value = your Tailscale auth key (e.g., `tskey-auth-abc123`).
6. Click "Create Web Service".
7. Once deployed, access the noVNC desktop via the provided Render URL (e.g., https://your-service.onrender.com).
8. In your Tailscale admin console, approve the new node and enable it as an exit node if required by your ACLs.

## Testing
- From another Tailscale device (e.g., your phone), run `tailscale status` to see the node.
- Set it as exit node: `tailscale set --exit-node=<node-name-or-ip>`.
- Test routing: `curl ifconfig.me` should show the Render IP.

## Notes
- On Render free tier, the service sleeps after inactivity—Tailscale will reconnect on wake with the reusable key.
- For persistence (survive restarts), upgrade to a paid Render plan with disks and add a volume mount for `/var/lib/tailscale`.
- If issues: Check Render logs for errors. Userspace mode is used due to unprivileged containers.