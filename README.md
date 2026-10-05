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

## Optional tools

Enable these by listing them in `COMPOSE_PROFILES` in `.env`, e.g.
`COMPOSE_PROFILES=phpmyadmin,peqeditor`.

  - `phpmyadmin`: [phpMyAdmin](https://www.phpmyadmin.net/) on `PHPMYADMIN_PORT`
    (default 8080). Log in with `DATABASE_USER` / `DATABASE_PASSWORD`.
  - `peqeditor`: the EQMacEmu fork of the
    [PEQ database editor](https://github.com/EQMacEmu/takpphpeditor) on
    `PEQ_EDITOR_PORT` (default 8081). Log in as `admin` with
    `PEQ_EDITOR_PASSWORD`, which is required when this is enabled.

## Todo

Static zones
