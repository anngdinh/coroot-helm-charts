# Coroot Custom Helm Charts

## Usage

### Install `chartmuseum` via Docker

```console
sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
```

### Dowload and build dependency

```console
make dependency
```

### Install via Helm

```console
make install
```
