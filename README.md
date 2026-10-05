# EQMacDocker

## Requirements

  - [Docker](https://docs.docker.com/engine/install/)
  - [Docker Compose](https://docs.docker.com/compose/install/linux)


## Setup

```bash
# Clone this repo with submodules
git clone --recurse-submodules https://github.com/nickgal/EQMacDocker
cd EQMacDocker

# Create .env from the example, be sure to update SERVER_ADDRESS
# and set LOGIN_PASSWORD_SALT and WORLD_SHARED_KEY
cp .env.example .env

# Run the server
docker compose up
```

## Static zones

By default the zone container keeps 10 idle zone processes, and world assigns
a zone to one of them when a player enters it. To keep specific zones running
at all times, list them in `STATIC_ZONES` in `.env`, e.g.
`STATIC_ZONES=poknowledge,nexus`. The `static` container runs them on ports
from `STATIC_ZONE_PORT_START` to `STATIC_ZONE_PORT_END` (default 7401-7425),
and exits at startup when `STATIC_ZONES` is empty. World applies the list when
it starts, so restart world and `static` after changing it. The boat zones
always run in the `boats` container and cannot be listed here.

## Optional tools

Enable these by listing them in `COMPOSE_PROFILES` in `.env`, e.g.
`COMPOSE_PROFILES=phpmyadmin,peqeditor`.

  - `phpmyadmin`: [phpMyAdmin](https://www.phpmyadmin.net/) on `PHPMYADMIN_PORT`
    (default 8080). Log in with `DATABASE_USER` / `DATABASE_PASSWORD`.
  - `peqeditor`: the EQMacEmu fork of the
    [PEQ database editor](https://github.com/EQMacEmu/takpphpeditor) on
    `PEQ_EDITOR_PORT` (default 8081). Log in as `admin` with
    `PEQ_EDITOR_PASSWORD`, which is required when this is enabled.
