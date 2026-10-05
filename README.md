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

## Todo

Static zones

PhpMyAdmin

PEQ Editor
