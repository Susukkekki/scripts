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

5. Install nvidia device plugin (wsl 전용)

```bash
cd ~/
wget https://raw.githubusercontent.com/Susukkekki/scripts/master/file/nvidia-device-plugin
wget https://raw.githubusercontent.com/Susukkekki/scripts/master/file/nvidia-device-plugin.sh
chmod 755 nvidia-device-plugin
chmod 755 nvidia-device-plugin.sh
```

```bash
./nvidia-device-plugin.sh
```

GPU 가 제대로 인식되는지 확인:

```bash
kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t
```

아래 처럼 결과가 출력되면 성공이다.

```bash
$ kubectl describe nodes  |  tr -d '\000' | sed -n -e '/^Name/,/Roles/p' -e '/^Capacity/,/Allocatable/p' -e '/^Allocated resources/,/Events/p'  | grep -e Name  -e  nvidia.com  | perl -pe 's/\n//'  |  perl -pe 's/Name:/\n/g' | sed 's/nvidia.com\/gpu:\?//g'  | sed '1s/^/Node Available(GPUs)  Used(GPUs)/' | sed 's/$/ 0 0 0/'  | awk '{print $1, $2, $3}'  | column -t
Node             Available(GPUs)  Used(GPUs)
desktop-r29qhap  1                0
```

6. Port-forward 를 통한 접속

```bash
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

다음 주소 접근 하여 로그인

- http://localhost:8080
- user@example.com / 12341234

> :point_right: `Unable to do port forwarding: socat not found.` 이 발생하면 `sudo apt-get -y install socat` 로 설치해주면 된다.
