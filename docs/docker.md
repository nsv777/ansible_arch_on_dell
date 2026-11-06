# Docker decisions

## MCP network MTU

The `docker` role manages the bridge network `mcp-network` with an MTU of
1400. This matches the VPN tunnel MTU and prevents oversized TLS responses
from being dropped between bridge-network containers and internal services.

When the existing network has a different MTU, the role disconnects all of
its containers, replaces the network, and does not reconnect those containers.
Restart the Compose stacks that use `mcp-network` after that run.
