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

다음은 wsl 에 kubeflow gpu 지원 기능 설치 정보이다.

| Tool                 | Version                      |
|----------------------|------------------------------|
| Cuda                 | 11.7.0                       |
| docker               | latest                       |
| systemd              | latest                       |
| k3s                  | v1.21.14+k3s1                |
| kubeflow             | v1.4.0-rc.2                  |
| nvidia-device-plugin | custom version built for wsl |

아래 스텝을 차근차근 진행하자.

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

`Kubeflow v1.4.0-rc.02`의 경우 다음을 업데이트 해주어야 한다.

```bash
kubectl edit sts -n kubeflow kfserving-controller-manager
```

```diff
-   image: gcr/kfserving/kfserving-controller:v0.6.0
+   image: kfserving/kfserving-controller:v0.6.1
```


Pod 가 모두 정상적인지 체크하는 kubectl 명령 `grep -v` 를 사용하면 `invert-match` 이다.

```bash
watch "kubectl get po --all-namespaces | grep -v Running"
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

> http://localhost:32500 로 그냥 접속 되는 것 같다.

```bash
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80
```

다음 주소 접근 하여 로그인

- http://localhost:8080
- user@example.com / 12341234

> :point_right: `Unable to do port forwarding: socat not found.` 이 발생하면 `sudo apt-get -y install socat` 로 설치해주면 된다.

7. Jupyter 노트북에서 "XSRF cookie does not match POST argument" Error 발생

> 음 이 문제가 발생시 아래 가이드보다 그냥 Cookie 를 삭제한 후 해결된 것 같다. 원인은 계속 여러버전의 kubeflow 를 설치하다 보니 인증 정보가 재활용되었던 것 같다.

다 끝난 줄 알았는데 또 문제가 발생했다. 아래 참고해 보았다.

- 참고 : https://otzslayer.github.io/kubeflow/2022/06/11/could-not-find-csrf-cookie-xsrf-token-in-the-request.html

kubeflow manifest 폴더 하위에서 다음 명령 실행

```bash
vi apps/jupyter/jupyter-web-app/upstream/base/deployment.yaml
```

아래 내용 추가

```diff
    spec:
      containers:
      - name: jupyter-web-app
        image: public.ecr.aws/j1r0q0g6/notebooks/jupyter-web-app
        ports:
        - containerPort: 5000
        volumeMounts:
        - mountPath: /etc/config
          name: config-volume
        - mountPath: /src/apps/default/static/assets/logos
          name: logos-volume
        env:
        - name: APP_PREFIX
          value: $(JWA_PREFIX)
        - name: UI
          value: $(JWA_UI)
        - name: USERID_HEADER
          value: $(JWA_USERID_HEADER)
        - name: USERID_PREFIX
          value: $(JWA_USERID_PREFIX)
+       - name: APP_SECURE_COOKIES
+         value: "false"
```

반영

```bash
kustomize build apps/jupyter/jupyter-web-app/upstream/overlays/istio | kubectl apply -f -
```
