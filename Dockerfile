# Use the base noVNC desktop image
FROM prbinu/novnc-desktop:latest

# Install Tailscale using the official script
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create directories for Tailscale state (non-persistent on Render free tier)
RUN mkdir -p /var/lib/tailscale /var/run/tailscale

# Copy the Tailscale startup script
COPY tailscale-start.sh /usr/local/bin/tailscale-start.sh
RUN chmod +x /usr/local/bin/tailscale-start.sh

# Append to the existing startup script to run Tailscale first
# (Assumes the image uses /dockerstartup/startup.sh; adjust if your image differs)
RUN echo "/usr/local/bin/tailscale-start.sh &" >> /dockerstartup/startup.sh