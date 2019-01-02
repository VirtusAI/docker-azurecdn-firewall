Firewall rules to whitelist [Azure CDN Verizon IP addresses](https://docs.microsoft.com/en-us/rest/api/cdn/edgenodes/list) on ports 80 and 443 (based on [confd-firewall](https://hub.docker.com/r/colinmollenhour/confd-firewall/)).

[![](https://images.microbadger.com/badges/image/virtusai/docker-azurecdn-firewall.svg)](https://microbadger.com/images/virtusai/docker-azurecdn-firewall "Get your own image badge on microbadger.com")

Background
----------

This image allows firewall rules to be managed by a docker container which blocks traffic to the public interface from non-whitelisted addresses. Iptable rules are added to the `mangle` table.
The IP addresses are automatically updated every day by a cron job running on the container.

Environment Variables
---------------------
 - AZURE_CLIENT_ID - Azure Service Principal client ID
 - AZURE_CLIENT_SECRET - Azure Service Principal client secret
 - AZURE_TENANT_ID - Azure AD tenant ID
 - AZURE_CDN - Azure CDN (Standard/Premium/Custom)
 - FW_DISABLE - If set to 1, disables the firewall (removes the firewall table rules)

Azure credentials are required to authenticate with the [Azure CDN REST API](https://docs.microsoft.com/rest/api/cdn/). See https://docs.microsoft.com/en-us/azure/active-directory/develop/v1-oauth2-client-creds-grant-flow#request-an-access-token for a detailed description of the required parameters.

Usage
-----

Run with:

```
$ docker run -d --name docker-azurecdn-firewall --restart=always --env AZURE_CLIENT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX --env AZURE_CLIENT_SECRET=XXXX --env AZURE_TENANT_ID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX --env AZURE_CDN=Standard --cap-add=NET_ADMIN --net=host virtusai/docker-azurecdn-firewall
```

Or with docker-compose.yml:

```
version: '2'
services:
  firewall:
    restart: always
    image: virtusai/docker-azurecdn-firewall
    container_name: docker-azurecdn-firewall
    environment:
      AZURE_CLIENT_ID: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      AZURE_CLIENT_SECRET: XXXX
      AZURE_TENANT_ID: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
      AZURE_CDN: Standard
    cap_add:
      - NET_ADMIN
    network_mode: host
```

List affected rules:

*Raw*

```
$ sudo iptables-save -t mangle
```

*Formatted*

```
$ sudo iptables -L -n -v -t mangle
```

To persist the firewall rules, just run the container with the `--restart=always` option.

Credits
-------

 - [confd-firewall](https://hub.docker.com/r/colinmollenhour/confd-firewall/) (by [colinmollenhour](https://github.com/colinmollenhour))

Related projects
----------------

 - [VirtusAI/docker-firewall](https://github.com/VirtusAI/docker-firewall)
 - [VirtusAI/docker-cloudflare-firewall](https://github.com/VirtusAI/docker-cloudflare-firewall)

