# Scripts

> wsl 이나 linux 세팅을 간편화하기 위한 스크립트 모음

- [Scripts](#scripts)
  - [Install Docker on WSL](#install-docker-on-wsl)
  - [Install K3s on WSL](#install-k3s-on-wsl)

## Install Docker on WSL

- docker 를 설치한다.
- sudo 없이 실행가능하게 한다.

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/ubuntu-docker.sh | sh
```

## Install K3s on WSL

1. systemd 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/wsl-systemd.sh | sh
```

2. :point_right: shell 종료 시키고 다시 실행

3. k3s 설치 (docker 설치 포함)

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/wsl-ubuntu-k3s.sh | sh
```

4. 정상 동작 확인

다음 명령을 실행하여 모든 Pod 가 Running 이 될때까지 기다린다.

```bash
kubectl get po --all-namespaces
```
