### Description
Dockerized version of jpmorgan quorum-examples vagrant box

### Versions
* quorum v2.0.1
* constellation v0.3.2
* porosity v1.2.0
* ubuntu v16.04
* go v1.9.3

### Example docker-compose.yml to start the 7nodes raft example with a custom genesis file
```
version: '3'

services:
  quorum:
    image: barrongineer/quorum
    container_name: quorum
    ports:
      - 22000:22000
    tty: true
    volumes:
      - ${PWD}/genesis.json:/quorum-examples/examples/7nodes/genesis.json
    working_dir: /quorum-examples/examples/7nodes
    command: bash -c "./raft-init.sh && ./raft-start.sh && tail -f qdata/logs/1.log"
```
