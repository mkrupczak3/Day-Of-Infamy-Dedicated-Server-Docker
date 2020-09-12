# Day of Infamy Dedicated Server in Docker

Day of Infamy is a multiplayer first-person shooter game set in WWII featuring authentic combat and multiple game modes.

![Day of Infamy Screenshot](https://github.com/mkrupczak3/day-of-infamy-dedicated/raw/master/doi_screenshot.png "Day of Infamy Screenshot")

This repository is maintained by [mkrupczak](https://github.com/mkrupczak3). Its contents are intended to be bare-bones and used as a stock server. It might even work.

## Linux


### Download

```
docker pull t3l3tubie/day-of-infamy-dedicated;
```

### Run Self Tests

The image includes some hot trash tests that might work (probably not) (this will break the build):

```
docker run -it --rm t3l3tubie/day-of-infamy-dedicated ./ll-tests/gamesvr-csgo.sh @TODO fix me!;
```

### Run Interactive Server


```
docker run -it --rm --net=host t3l3tubie/day-of-infamy-dedicated ./srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 +map bastogne +sv_lan 1;
```


(Remove that last bit maybe?)


## Getting Started with Game Servers in Docker

[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable, self-sufficient containers. For a crash course on running Dockerized game servers check out [Using Docker for Game Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks, and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for [Working with Laclede's Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can also browse all of Laclede's other Dockerized game servers: [Laclede's LAN Game Servers Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers).
