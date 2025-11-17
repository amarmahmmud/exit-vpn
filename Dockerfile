# Use the base noVNC desktop image
FROM prbinu/novnc-desktop:latest

# Install Tailscale using the official script
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create directories for Tailscale state (non-persistent on Render free tier)
RUN mkdir -p /var/lib/tailscale /var/run/tailscale

# Copy the Tailscale startup script
COPY tailscale-start.sh /usr/local/bin/tailscale-start.sh

# Convert line endings to Unix (fix ENOEXEC if script has CRLF)
RUN sed -i 's/\r$//' /usr/local/bin/tailscale-start.sh

# Make executable
RUN chmod +x /usr/local/bin/tailscale-start.sh

# Append a Supervisor program section to run Tailscale
# (The base image uses /etc/supervisord.conf for its config)
RUN cat >> /etc/supervisord.conf <<EOF

[program:tailscale]
command=/usr/local/bin/tailscale-start.sh
priority=5  ; Lower priority starts earlier—adjust if needed (base programs use 0)
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
EOF