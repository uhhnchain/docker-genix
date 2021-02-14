# Genix Image for Docker
## Installation
```
docker pull uhhnchain/genix
```

## Creating a new container
```
mkdir ~/genix
docker run -d -p 43649:43649 --name myGenixContainer -v ~/genix:/root/.genix uhhnchain/genix
```
The run command above will create a new container, map the p2p port to the host system, mount a directory on the host as the data directory, start the coin daemon and then detach.

Mapping the host port isn't necessary unless you want to allow nodes to connect to you from the outside. (You'll also need to configure port forwarding on your network and any firewalls running on the host.) If you want to use other software to interact with the coin daemon, map the RPC port to the host by adding `-p 9998:9998` to the above example.

If you plan on using this as a wallet, you should create the data directory outside the container and then mount it as a volume, as shown in the above example. Alternatively, you can back up your private keys by hand. This is so you don't lose everything forever in the case that you accidentally prune the built-in volume somehow by accident.

## Stopping and restarting an existing container
Stopping a running container should be done by issuing the `stop` command using `docker exec`. This allows the block index and data files to be closed properly:
```
docker exec myGenixContainer genix-cli stop
```
Restart a stopped container with `docker start`:
```
docker start myGenixContainer
```

## Using the CLI
Commands can be issued using 'docker exec' as shown in these examples.
```
docker exec myGenixContainer genix-cli getnetworkinfo
docker exec myGenixContainer genix-cli getblockchaininfo
docker exec myGenixContainer genix-cli getnewaddress
```
