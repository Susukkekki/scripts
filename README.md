# Scripts

> wsl 이나 linux 세팅을 간편화하기 위한 스크립트 모음

- [Scripts](#scripts)
  - [Install Docker on WSL](#install-docker-on-wsl)
  - [Install K3s on WSL](#install-k3s-on-wsl)
  - [Install GPU Support Docker on wsl](#install-gpu-support-docker-on-wsl)
  - [Install Kubeflow on wsl with GPU Support](#install-kubeflow-on-wsl-with-gpu-support)

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

3. docker 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/ubuntu-docker.sh | sh
```

4. k3s 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/ubuntu-k3s.sh | sh
```

5. (Optional) Helm 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/ubuntu-helm.sh | sh
```

6. 정상 동작 확인

다음 명령을 실행하여 모든 Pod 가 Running 이 될때까지 기다린다.

```bash
kubectl get po --all-namespaces
```

## Install GPU Support Docker on wsl

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/wsl-cuda.sh | sh
```

## Install Kubeflow on wsl with GPU Support

1. Insttall GPU Support Docker

[Install GPU Support Docker on wsl](#install-gpu-support-docker-on-wsl)

2. systemd 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/wsl-systemd.sh | sh
```

- :point_right: `wsl --shutdown` 으로 종료시키고 해야 함.

3. k3s 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/ubuntu-k3s.sh | sh
```

4. Kubeflow 설치

```bash
curl https://raw.githubusercontent.com/Susukkekki/scripts/master/wsl-kubeflow.sh | sh
```

5. Port-forward 를 통한 접속

```bash
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

다음 주소 접근 하여 로그인

http://localhost:8080
user@example.com / 12341234

> :point_right: `Unable to do port forwarding: socat not found.` 이 발생하면 `sudo apt-get -y install socat` 로 설치해주면 된다.
