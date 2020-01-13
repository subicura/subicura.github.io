---
published: true
title: 쿠버네티스 시작하기 - Kubernetes란 무엇인가?
series: 1/4
categories: Kubernetes
tags: [Kubernetes, Docker, DevOps, Server]
layout: post
excerpt: 쿠버네티스는 컨테이너를 쉽고 빠르게 배포/확장하고 관리를 자동화해주는 오픈소스 플랫폼입니다. 1주일에 수십억 개의 컨테이너를 생성하는 구글이 내부 배포시스템으로 사용하던 borg를 기반으로 2014년 프로젝트를 시작했고 여러 커뮤니티의 아이디어와 좋은 사례를 모아 빠르게 발전하고 있습니다. 이 글은 쿠버네티스가 무엇인지 궁금한 엔지니어를 대상으로 쿠버네티스 세계의 입구까지 안내해 드립니다.
ogimage: /assets/og/2019-05-19-kubernetes-basic-1-summary.png
ogwidth: 1200
ogheight: 630
comments: yes
toc: true
last_modified_at: 2020-01-14T08:30:00+09:00
---

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/docker-logo.png"  | prepend: site.baseurl  }}" alt="docker logo" style="width: 450px">
</p>

2013년 등장한 도커<sub>docker</sub>는 인프라 세계를 컨테이너<sub>container</sub> 세상으로 바꿔버렸습니다. 수많은 애플리케이션이 컨테이너로 배포되고 도커파일을 만들어 이미지를 빌드하고 컨테이너를 배포하는 게 흔한 개발 프로세스가 되었습니다. 2019년 DockerCon 발표에선 무려 [1052억번의 컨테이너 image pull](https://twitter.com/ajeetsraina/status/1123258872443990017)이 발생했다고 합니다.

이러한 도커의 인기와 함께 쿠버네티스<sub>kubernetes</sub>의 인기도 엄청나게 치솟고 있습니다. 클라우드와 관련된 행사에 가면 여기저기서 다음과 같은 이야기를 들을 수 있습니다.

- 쿠버네티스 클러스터에 Deployment를 배포하고 Ingress를 연결하자. [Nginx](https://github.com/kubernetes/ingress-nginx)말고 [Traefik Ingress](https://docs.traefik.io/user-guide/kubernetes/)도 좋다던데?
- AWS에 설치할 땐 [kops](https://github.com/kubernetes/kops)가 좋고 요즘엔 [EKS](https://aws.amazon.com/eks/)도 많이 쓰더라.
- on-prem에 설치할 때 [kubespray](https://github.com/kubernetes-sigs/kubespray), [kubeadm](https://github.com/kubernetes/kubeadm), [rancher](https://rancher.com/), [openshift](https://www.openshift.com/) 중에 뭐가 나을까?
- 쿠버네티스에 [istio](https://istio.io/)나 [linkerd](https://linkerd.io/) 설치해서 서비스메시 적용하고 [zipkin](https://zipkin.io/)으로 추적하자.
- 컨테이너 서버리스<sub>Serverless</sub> [Cloud Run](https://cloud.google.com/run/)이 [Knative](https://cloud.google.com/knative/) 기반이라던데?
- 컨테이너 시대에 빌드, 배포는 [Spinnaker](https://www.spinnaker.io/)나 [Jenkins X](https://jenkins.io/projects/jenkins-x/) ~~(Jenkins와는 다름!)~~ 써야지.
- 설정 파일은 [helm](https://helm.sh/)으로 만들고 [ChartMuseum](https://chartmuseum.com/)으로 관리하자.
- 클러스터 하나는 불안한데 멀티 클러스터 구성해야 하지 않을까? [Anthos](https://cloud.google.com/anthos/)?
- 클라우드 네이티브<sub>Cloud Native</sub> 애플리케이션 만들어서 쿠버네티스에 배포하자.

![무슨 이야기인지..]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/i-dont-know.png)

이 모든 것들이 불과 2~3년 이내에 나온 것들로 인프라 세계가 이렇게 빨리 변한적이 있었나 싶습니다. 예전에는 일부 고오오급 회사에서만 썼던 것 같은데 이제 여기저기서 ~~나만 빼고~~ 다 쓰는 거 같고 뭔가 좀 해보고 싶어도 설치부터 어렵고 내용이 복잡해서 배우기가 쉽지 않습니다.

이 글은 쿠버네티스가 무엇인지 궁금한 엔지니어를 대상으로 쿠버네티스 세계의 입구까지 안내해 드립니다. 쿠버네티스의 세계는 너무 크고 광활하기 때문에 입구에 도착해서 어디로 갈지는 나중에 정하면 됩니다. 일단 쿠버네티스의 기본적인 개념과 구성을 알아보고 다음 글에서 클러스터 설치와 기본 사용법을 익혀보겠습니다.

---

* [도커에 대해 모른다면 → 초보를 위한 도커 안내서]({% post_url 2017-01-19-docker-guide-for-beginners-1 %})
* **쿠버네티스 시작하기 - 쿠버네티스란 무엇인가? ✓** <span class="series">SERIES 1/4</span>
* 쿠버네티스 시작하기 - 쿠버네티스 설치 (예정) <span class="series">SERIES 2/4</span>
* 쿠버네티스 시작하기 - 컨테이너 배포 (예정) <span class="series">SERIES 3/4</span>
* 쿠버네티스 시작하기 - 스토리지, 설정, 비밀정보 관리 (예정) <span class="series">SERIES 4/4</span>

{% googleads class_name: 'googleads-content', ads_id: 'google_ad_slot_2_id' %}

---

## 쿠버네티스의 과거, 현재, 미래

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/container-orchestration.png"  | prepend: site.baseurl  }}" alt="container orchestration" style="width: 450px">
</p>

쿠버네티스는 다른 컨테이너 오케스트레이션 도구보다 비교적 늦게 등장했습니다. [도커 스웜](https://docs.docker.com/engine/swarm/)이 쉽고 간단한 사용법~~끼워팔기~~을 앞세워 세력을 넓히고 있었고 AWS에서 [ECS](https://aws.amazon.com/ecs/), 하시코프에서 [Nomad](https://www.nomadproject.io/), 전통의 강호 [Mesos](http://mesos.apache.org/)에서 [Marathon](https://mesosphere.github.io/marathon/)을 발표했습니다.

컨테이너 오케스트레이션이 하는 일은 여러 개의 서버에 컨테이너를 배포하고 운영하면서 서비스 디스커버리<sub>Service discovery</sub>같은 기능을 이용하여 서비스 간 연결을 쉽게 해주는 것입니다. 서버마다 app01, db01, cache01 같은 이름을 지어주고 하나하나 접속하여 관리하는 것이 아니라 server1, 2, 3, 4..를 하나로 묶어 적당한 서버를 자동으로 선택해 애플리케이션을 배포하고 부하가 생기면 컨테이너를 늘리고 일부 서버에 장애가 발생하면 정상 동작 중인 서버에 다시 띄워 장애를 방지합니다. 위에서 이야기한 도구들은 대동소이한 기능을 제공했고 절대 강자 없이 한동안 컨테이너 오케스트레이션 춘추전국시대가 열렸습니다.

이런 상황은 쿠버네티스가 등장하고 1~2년 정도 지나면서 완전히 바뀌었고 현재 쿠버네티스는 사실상의 표준~~원픽~~이 되었습니다. ([CNCF Survey](https://www.cncf.io/blog/2018/08/29/cncf-survey-use-of-cloud-native-technologies-in-production-has-grown-over-200-percent/) 참고) 대규모 컨테이너를 관리했던 구글의 노하우와 강력한 확장성, 마이크로소프트, Red Hat, IBM 등 수많은 기업의 참여, 잘 짜인 설계가 쿠버네티스를 왕좌에 오르게 했습니다.

Rancher 2.0, OpenShift(Red Hat), Tectonic(CoreOS), Docker Enterprise Edition등이 쿠버네티스를 기반으로 플랫폼을 만들어 대세임을 증명하고 있고 AWS, Google Cloud, Azure, Digital Ocean, IBM Cloud, Oracle Cloud 등에서 관리형<sub>Managed</sub>서비스를 내놓음으로써 클라우드 컨테이너 시장을 평정하였습니다. 심지어 [어떤 칼럼](http://www.ciokorea.com/column/40283)에서는 더는 운영체제가 무엇인지 중요하지 않다며 쿠버네티스가 새로운 운영체제처럼 쓰일 것이라고 얘기했습니다. OS에 접속해서 프로그램을 한 땀 한 땀 설치하는 것이 아니라 쿠버네티스에 컨테이너를 배포하고 네트워크와 스토리지 설정을 하면 되는 거죠. ~~클라우드계의 리눅스~~

## 쿠버네티스란?


<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/kubernetes-logo.png"  | prepend: site.baseurl  }}" alt="kubernetes logo" style="width: 450px">
</p>

**쿠버네티스는 컨테이너를 쉽고 빠르게 배포/확장하고 관리를 자동화해주는 오픈소스 플랫폼입니다.** 몇 가지 수식어로 "운영환경에서 사용 가능한(production ready)", "de facto(사실상 표준)", "조타수(helmsman)", "조종사(pilot)", "행성 스케일(Planet Scale)", "~~갓(god)~~" 등을 가지고 있습니다. 쿠버네티스<sub>kubernetes</sub>가 너무 길어서 ~~오타가 많아서~~ 흔히 케이(에이)츠<sub>k8s</sub> 또는 큐브<sub>kube</sub>라고 줄여서 부릅니다.

1주일에 수십억 개의 컨테이너를 생성하는 구글이 내부 배포시스템으로 사용하던 [borg](https://kubernetes.io/blog/2015/04/borg-predecessor-to-kubernetes/)를 기반으로 2014년 프로젝트를 시작했고 여러 커뮤니티의 아이디어와 좋은 사례를 모아 빠르게 발전하고 있습니다.

단순한 컨테이너 플랫폼이 아닌 마이크로서비스, 클라우드 플랫폼을 지향하고 컨테이너로 이루어진 것들을 손쉽게 담고 관리할 수 있는 그릇 역할을 합니다. 서버리스, CI/CD, 머신러닝 등 다양한 기능이 쿠버네티스 플랫폼 위에서 동작합니다.

## 쿠버네티스 특징

컨테이너 오케스트레이션의 기본 기능 외에 쿠버네티스가 가지는 차별화된 특징은 다음과 같습니다.

### 갓구글 + 고오오오급 회사들의 참여 <sub>ECO System</sub>

[![Cloud Native Landscape]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/cncf-map.png)](https://landscape.cncf.io/)

전 세계적 스케일의 경험과 기술이 고스란히 녹아들어 있습니다. 거대한 커뮤니티와 생태계가 있어 잘 안 되는 건 찾아보면 되고 이런 거 만들어 볼까 하면 누군가 만들어 놨습니다. 서비스메시(Istio, linkerd), CI(Tekton, Spinnaker), 컨테이너 서버리스(Knative), 머신러닝(kubeflow)이 모두 쿠버네티스 환경에서 돌아갑니다. 클라우드 네이티브 애플리케이션 대부분이 쿠버네티스와 찰떡궁합입니다.

### 다양한 배포 방식

![쿠버네티스 배포 방식]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/workload.png)

컨테이너와 관련된 많은 예제가 웹(프론트엔드+백엔드) 애플리케이션을 다루고 있지만, 실제 세상엔 더 다양한 형태의 애플리케이션이 있습니다. 쿠버네티스는 `Deployment`, `StatefulSets`, `DaemonSet`, `Job`, `CronJob`등 다양한 배포 방식을 지원합니다. Deployment는 새로운 버전의 애플리케이션을 다양한 전략으로 무중단 배포할 수 있습니다. StatefulSets은 실행 순서를 보장하고 호스트 이름과 볼륨을 일정하게 사용할 수 있어 순서나 데이터가 중요한 경우에 사용할 수 있습니다. 로그나 모니터링 등 모든 노드에 설치가 필요한 경우엔 DaemonSet을 이용하고 배치성 작업은 Job이나 CronJob을 이용하면 됩니다. ~~무슨 기능을 원하는지 몰라서 다 준비해놨어~~

### Ingress 설정

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/ingress.png"  | prepend: site.baseurl  }}" alt="Ingress" style="width: 550px">
</p>

다양한 웹 애플리케이션을 하나의 로드 밸런서로 서비스하기 위해 Ingress~~입장~~기능을 제공합니다. 웹 애플리케이션을 배포하는 과정을 보면 외부에서 직접 접근할 수 없도록 애플리케이션을 내부망에 설치하고 외부에서 접근이 가능한 `ALB`나 `Nginx`, `Apache`를 프록시 서버로 활용합니다. 프록시 서버는 도메인과 Path 조건에 따라 등록된 서버로 요청을 전달하는데 서버가 바뀌거나 IP가 변경되면 매번 설정을 수정해줘야 합니다. 쿠버네티스의 Ingress는 이를 자동화하면서 기존 프록시 서버에서 사용하는 설정을 거의 그대로 사용할 수 있습니다. 새로운 도메인을 추가하거나 업로드 용량을 제한하기 위해 일일이 프록시 서버에 접속하여 설정할 필요가 없습니다.

하나의 클러스터에 여러 개의 Ingress 설정을 할 수 있어 관리자 접속용 Ingress와 일반 접속용 Ingress를 따로 관리할 수 있습니다.

### 클라우드 지원

![Cloud]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/cloud-company.png)

쿠버네티스는 부하에 따라 자동으로 서버를 늘리는 기능<sub>AutoScaling</sub>이 있고 IP를 할당받아 로드밸런스<sub>LoadBalancer</sub>로 사용할 수 있습니다. 외부 스토리지를 컨테이너 내부 디렉토리에 마운트하여 사용하는 것도 일반적인데 이를 위해 클라우드 별로 적절한 API를 사용하는 모듈이 필요합니다. 쿠버네티스는 Cloud Controller를 이용하여 클라우드 연동을 손쉽게 확장할 수 있습니다. AWS, 구글 클라우드, 마이크로소프트 애저는 물론 수십 개의 클라우드 업체에서 모듈을 제공하여 관리자는 동일한 설정 파일을 서로 다른 클라우드에서 동일하게 사용할 수 있습니다.

### Namespace & Label

![Namespace & Label]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/namespace-label.png)

하나의 클러스터를 논리적으로 구분하여 사용할 수 있습니다. 하나의 클러스터에 다양한 프레임워크와 애플리케이션을 설치하기 때문에 기본(`system`, `default`)외에 여러 개의 네임스페이스를 사용하는 것이 일반적입니다. 더 세부적인 설정으로 라벨 기능을 적극적으로 사용하여 유연하면서 확장성 있게 리소스를 관리할 수 있습니다.

### RBAC (role-based access control)

![Role based access control]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/rbac.png)

접근 권한 시스템입니다. 각각의 리소스에 대해 유저별로 CRUD스런 권한을 손쉽게 지정할 수 있습니다. 클러스터 전체에 적용하거나 특정 네임스페이스에 적용할 수 있습니다. AWS의 경우 IAM을 [연동](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)해서 사용할 수도 있습니다.

### CRD (Custom Resource Definitaion)

쿠버네티스가 제공하지 않는 기능을 기본 기능과 동일한 방식으로 적용하고 사용할 수 있습니다. 예를 들어, 쿠버네티스는 기본적으로 SSL 인증서 관리 기능을 제공하지 않지만, [cert-manager](https://github.com/jetstack/cert-manager)를 설치하고 Certificate 리소스를 이용하면 익숙한 쿠버네티스 명령어로 인증서를 관리할 수 있습니다. 또 다른 도구, 방식을 익힐 필요 없이 다양한 기능을 손쉽게 확장할 수 있습니다.

### Auto Scaling

CPU, memory 사용량에 따른 확장은 기본이고 현재 접속자 수와 같은 값을 사용할 수도 있습니다. 컨테이너의 개수를 조정하는 Horizontal Pod Autoscaler(HPA), 컨테이너의 리소스 할당량을 조정하는 Vertical Pod Autoscaler(VPA), 서버 개수를 조정하는 Cluster Autosclaer(CA) 방식이 있습니다.

### Federation, Multi Cluster

클라우드에 설치한 쿠버네티스 클러스터와 자체 서버에 설치한 쿠버네티스를 묶어서 하나로 사용할 수 있습니다. 구글에서 발표한 Anthos를 이용하면 한 곳에서 여러 클라우드의 여러 클러스터를 관리할 수 있습니다.

### 단점

쿠버네티스는 확실히 복잡하고 초반에 개념을 이해하기 어렵습니다. YAML 설정 파일은 너무 많고 클러스터를 만드는 것도 쉽지 않습니다. 하지만 여러 클라우드에서 관리형 서비스를 제공하고 ~~클릭 몇번으로 만들자~~ [Cloud Code](https://cloud.google.com/code) 같은 플러그인을 이용하거나 helm 같은 패키지 매니저를 사용하면 비교적 편리하게 설정파일을 관리할 수 있습니다. 쿠버네티스가 어려운건.. 이 글에서 최대한 쉽게 설명해 보도록 하겠습니다.

## 쿠버네티스 기본 개념

쿠버네티스가 어떻게 동작하는지, 설치는 왜 이리 어려운지, 설정 파일은 왜 그렇게 복잡한지 이해하기 위해 쿠버네티스의 디자인과 구성 요소, 각각의 동작 방식을 알아보겠습니다.

### Desired State

![Desired state]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/desired-state.png)

쿠버네티스에서 가장 중요한 것은 **desired state - 원하는 상태** 라는 개념입니다. 원하는 상태라 함은 관리자가 바라는 환경을 의미하고 좀 더 구체적으로는 얼마나 많은 웹서버가 떠 있으면 좋은지, 몇 번 포트로 서비스하기를 원하는지 등을 말합니다.

쿠버네티스는 복잡하고 다양한 작업을 하지만 자세히 들여다보면 **현재 상태<sub>current state</sub>**를 모니터링하면서 관리자가 설정한 **원하는 상태**를 유지하려고 내부적으로 이런저런 작업을 하는 단순한(?) 로직을 가지고 있습니다.

이러한 개념 때문에 관리자가 서버를 배포할 때 직접적인 동작을 명령하지 않고 상태를 선언하는 방식을 사용합니다. 예를 들어 "nginx 컨테이너를 실행해줘. 그리고 80 포트로 오픈해줘."는 현재 상태를 원하는 상태로 바꾸기 위한 **명령<sub>imperative</sub>**이고 "80 포트를 오픈한 nginx 컨테이너를 1개 유지해줘"는 원하는 상태를 **선언<sub>declarative</sub>** 한 것입니다. ~~더 이해가 안 된다~~

언뜻 똑같은 요청을 단어를 살짝 바꿔 말장난하는 게 아닌가 싶은데, 이런 차이는 CLI 명령어에서도 드러납니다.

{% highlight bash linenos %}
$ docker run # 명령
$ kubectl create # 상태 생성 (물론 kubectl run 명령어도 있지만 잘 사용하지 않습니다)
{% endhighlight %}

쿠버네티스의 핵심은 상태이며 쿠버네티스를 사용하려면 어떤 상태가 있고 어떻게 상태를 선언하는지를 알아야 합니다.

### Kubernetes Object

쿠버네티스는 상태를 관리하기 위한 대상을 오브젝트로 정의합니다. 기본으로 수십 가지 오브젝트를 제공하고 새로운 오브젝트를 추가하기가 매우 쉽기 때문에 확장성이 좋습니다. 여러 오브젝트 중 주요 오브젝트는 다음과 같습니다.

#### Pod

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/pod.png"  | prepend: site.baseurl }}" alt="Pod" style="width: 350px">
</p>

쿠버네티스에서 배포할 수 있는 가장 작은 단위로 한 개 이상의 컨테이너와 스토리지, 네트워크 속성을 가집니다. Pod에 속한 컨테이너는 스토리지와 네트워크를 공유하고 서로 localhost로 접근할 수 있습니다. 컨테이너를 하나만 사용하는 경우도 반드시 Pod으로 감싸서 관리합니다.

#### ReplicaSet

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/replicaset.png"  | prepend: site.baseurl }}" alt="ReplicaSet" style="width: 350px">
</p>

Pod을 여러 개(한 개 이상) 복제하여 관리하는 오브젝트입니다. Pod을 생성하고 개수를 유지하려면 반드시 ReplicaSet을 사용해야 합니다. ReplicaSet은 복제할 개수, 개수를 체크할 라벨 선택자, 생성할 Pod의 설정값(템플릿)등을 가지고 있습니다. 직접적으로 ReplicaSet을 사용하기보다는 Deployment등 다른 오브젝트에 의해서 사용되는 경우가 많습니다.

#### Service

네트워크와 관련된 오브젝트입니다. Pod을 외부 네트워크와 연결해주고 여러 개의 Pod을 바라보는 내부 로드 밸런서를 생성할 때 사용합니다. 내부 DNS에 서비스 이름을 도메인으로 등록하기 때문에 서비스 디스커버리 역할도 합니다.

#### Volume

저장소와 관련된 오브젝트입니다. 호스트 디렉토리를 그대로 사용할 수도 있고 EBS 같은 스토리지를 동적으로 생성하여 사용할 수도 있습니다. 사실상 인기 있는 대부분의 저장 방식을 [지원](https://kubernetes.io/docs/concepts/storage/#types-of-volumes)합니다.

### Object Spec - YAML

{% highlight yaml linenos %}
apiVersion: v1
kind: Pod
metadata:
    name: example
spec:
    containers:
    - name: busybox
        image: busybox:1.25
{% endhighlight %}

오브젝트의 명세<sub>Spec</sub>는 YAML 파일(JSON도 가능하다고 하지만 잘 안 씀)로 정의하고 여기에 오브젝트의 종류와 원하는 상태를 입력합니다. 이러한 명세는 생성, 조회, 삭제로 관리할 수 있기 때문에 REST API로 쉽게 노출할 수 있습니다. 접근 권한 설정도 같은 개념을 적용하여 누가 어떤 오브젝트에 어떤 요청을 할 수 있는지 정의할 수 있습니다.

### 쿠버네티스 배포방식

쿠버네티스는 애플리케이션을 배포하기 위해 원하는 상태(desired state)를 다양한 오브젝트(object)에 라벨<sub>Label</sub>을 붙여 정의(yaml)하고 API 서버에 전달하는 방식을 사용합니다.

"컨테이너를 2개 배포하고 80 포트로 오픈해줘"라는 간단한 작업을 위해 다음과 같은 구체적인 명령을 전달해야 합니다. 
> "컨테이너를 Pod으로 감싸고 type=app, app=web이라는 라벨을 달아줘. type=app, app=web이라는 라벨이 달린 Pod이 2개 있는지 체크하고 없으면 Deployment Spec에 정의된 템플릿을 참고해서 Pod을 생성해줘. 그리고 해당 라벨을 가진 Pod을 바라보는 가상의 서비스 IP를 만들고 외부의 80 포트를 방금 만든 서비스 IP랑 연결해줘."

음.. “정말 뭐 하나 배포할 때마다 저렇게 복잡하게 설정한다고?”라는 의구심이 들 수 있지만 이건 모두 사실입니다. ~~[미친 얘기 같지만 전부 사실이에요.](https://www.google.co.kr/search?hl=en-kr&q=%EB%AF%B8%EC%B9%9C+%EC%96%98%EA%B8%B0+%EA%B0%99%EC%A7%80%EB%A7%8C+%EC%A0%84%EB%B6%80+%EC%82%AC%EC%8B%A4%EC%9D%B4%EC%97%90%EC%9A%94&oq=%EB%AF%B8%EC%B9%9C+%EC%96%98%EA%B8%B0+%EA%B0%99%EC%A7%80%EB%A7%8C+%EC%A0%84%EB%B6%80+%EC%82%AC%EC%8B%A4%EC%9D%B4%EC%97%90%EC%9A%94)~~ Cloud code, Helm, Knative를 사용하면 조금 편해지긴 하지만 기본적으로 너무 복잡하고 러닝 커브가 높은 편입니다.

어쩌다 이렇게 되었을까.. 관리가 쉬워지면서 일자리가 없어지는 걸 걱정한 서버 관리자의 고도의 전략인가 잘 짜인 설계 문제인가. 쿠버네티스의 개념을 어떻게 구현했는지 구체적인 아키텍처를 살펴보겠습니다.

## 쿠버네티스 아키텍처

컨테이너는 아주 심플하고 우아하게 동작합니다. run을 하면 실행되고 stop을 하면 멈춥니다. 서버-클라이언트 구조를 안다면 컨테이너를 관리하는 에이전트를 만들고 중앙에서 API를 이용하여 원격으로 관리하는 모습을 쉽게 그려볼 수 있습니다.

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/server-agent.png"  | prepend: site.baseurl }}" alt="Server - Agent" style="width: 350px">
</p>

쿠버네티스 또한 중앙(Master)에 API 서버와 상태 저장소를 두고 각 서버(Node)의 에이전트(kubelet)와 통신하는 단순한 구조입니다. 하지만, 앞에서 얘기한 개념을 여러 모듈로 쪼개어 구현하고 다양한 오픈소스를 사용하기 때문에 설치가 까다롭고 언뜻 구성이 복잡해 보입니다.

### 마스터 - 노드 구조

<p align="center">
    <img src="{{ "/assets/article_images/2019-05-19-kubernetes-basic-1/master-node.png"  | prepend: site.baseurl }}" alt="Master - Node" style="width: 600px">
</p>

쿠버네티스는 전체 클러스터를 관리하는 **마스터**와 컨테이너가 배포되는 **노드**로 구성되어 있습니다. 모든 명령은 마스터의 API 서버를 호출하고 노드는 마스터와 통신하면서 필요한 작업을 수행합니다. 특정 노드의 컨테이너에 명령하거나 로그를 조회할 때도 노드에 직접 명령하는 게 아니라 마스터에 명령을 내리고 마스터가 노드에 접속하여 대신 결과를 응답합니다.

#### Master

마스터 서버는 다양한 모듈이 확장성을 고려하여 기능별로 쪼개져 있는 것이 특징 ~~고통~~ 입니다. 관리자만 접속할 수 있도록 보안 설정을 해야 하고 마스터 서버가 죽으면 클러스터를 관리할 수 없기 때문에 보통 3대를 구성하여 안정성을 높입니다. AWS EKS 같은 경우 마스터를 AWS에서 자체 관리하여 안정성을 높였고(마스터에 접속 불가) 개발 환경이나 소규모 환경에선 마스터와 노드를 분리하지 않고 같은 서버에 구성하기도 합니다.

#### Node

노드 서버는 마스터 서버와 통신하면서 필요한 Pod을 생성하고 네트워크와 볼륨을 설정합니다. 실제 컨테이너들이 생성되는 곳으로 수백, 수천대로 확장할 수 있습니다. 각각의 서버에 라벨을 붙여 사용목적(GPU 특화, SSD 서버 등)을 정의할 수 있습니다.

#### Kubectl

API 서버는 json 또는 protobuf 형식을 이용한 http 통신을 지원합니다. 이 방식을 그대로 쓰면 불편하므로 보통 `kubectl`이라는 명령행 도구를 사용합니다. 앞으로 엄청나게 많이 ~~지겹게~~ 사용할 예정입니다.
어떻게 읽어야 할지 난감한데 [공식적](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.9.md#kubectl)으로 큐브컨트롤(cube control)이라고 읽지만 큐브씨티엘, 쿱컨트롤, 쿱씨티엘등도 많이 쓰입니다.

### Master 구성 요소

![Master Component]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/kubernetes-master.png)

#### API 서버 kube-apiserver

API 서버는 모오오든 요청을 처리하는 마스터의 핵심 모듈입니다. kubectl의 요청뿐 아니라 내부 모듈의 요청도 처리하며 권한을 체크하여 요청을 거부할 수 있습니다. 실제로 하는 일은 원하는 상태를 key-value 저장소에 저장하고 저장된 상태를 조회하는 매우 단순한 작업입니다. Pod을 노드에 할당하고 상태를 체크하는 일은 다른 모듈로 분리되어 있습니다. 노드에서 실행 중인 컨테이너의 로그를 보여주고 명령을 보내는 등 디버거 역할도 수행합니다.

#### 분산 데이터 저장소 etcd

RAFT 알고리즘을 이용한 key-value 저장소입니다. 여러 개로 분산하여 복제할 수 있기 때문에 안정성이 높고 속도도 빠른 편입니다. 단순히 값을 저장하고 읽는 기능뿐 아니라 watch 기능이 있어 어떤 상태가 변경되면 바로 체크하여 로직을 실행할 수 있습니다.

클러스터의 모든 설정, 상태 데이터는 여기 저장되고 나머지 모듈은 stateless하게 동작하기 때문에 etcd만 잘 백업해두면 언제든지 클러스터를 복구할 수 있습니다. etcd는 오직 API 서버와 통신하고 다른 모듈은 API 서버를 거쳐 etcd 데이터에 접근합니다. [k3s](https://k3s.io/) 같은 초경량 쿠버네티스 배포판에서는 etcd대신 sqlite를 사용하기도 합니다.

#### 스케줄러, 컨트롤러

API 서버는 요청을 받으면 etcd 저장소와 통신할 뿐 실제로 상태를 바꾸는 건 스케줄러와 컨트롤러 입니다. 현재 상태를 모니터링하다가 원하는 상태와 다르면 각자 맡은 작업을 수행하고 상태를 갱신합니다.

**스케줄러** kube-scheduler

스케줄러는 할당되지 않은 Pod을 여러 가지 조건(필요한 자원, 라벨)에 따라 적절한 노드 서버에 할당해주는 모듈입니다.

**큐브 컨트롤러** kube-controller-manager

큐브 컨트롤러는 다양한 역할을 하는 아주 바쁜 모듈입니다. 쿠버네티스에 있는 거의 모든 오브젝트의 상태를 관리합니다. 오브젝트별로 철저하게 분업화되어 Deployment는 ReplicaSet을 생성하고 ReplicaSet은 Pod을 생성하고 Pod은 스케줄러가 관리하는 식입니다.

**클라우드 컨트롤러** cloud-controller-manager

클라우드 컨트롤러는 AWS, GCE, Azure 등 클라우드에 특화된 모듈입니다. 노드를 추가/삭제하고 로드 밸런서를 연결하거나 볼륨을 붙일 수 있습니다. 각 클라우드 업체에서 인터페이스에 맞춰 구현하면 되기 때문에 확장성이 좋고 많은 곳에서 자체 모듈을 만들어 제공하고 있습니다.

### Node 구성 요소

![Node Component]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/kubernetes-node.png)

#### 큐블릿 kubelet

노드에 할당된 Pod의 생명주기를 관리합니다. Pod을 생성하고 Pod 안의 컨테이너에 이상이 없는지 확인하면서 주기적으로 마스터에 상태를 전달합니다. API 서버의 요청을 받아 컨테이너의 로그를 전달하거나 특정 명령을 대신 수행하기도 합니다.

#### 프록시 kube-proxy

큐블릿이 Pod을 관리한다면 프록시는 Pod으로 연결되는 네트워크를 관리합니다. TCP, UDP, SCTP 스트림을 포워딩하고 여러 개의 Pod을 라운드로빈 형태로 묶어 서비스를 제공할 수 있습니다. 초기에는 kube-proxy 자체가 프록시 서버로 동작하면서 실제 요청을 프록시 서버가 받고 각 Pod에 전달해 주었는데 시간이 지나면서 iptables를 설정하는 방식으로 변경되었습니다. iptables에 등록된 규칙이 많아지면 느려지는 문제 때문에 최근 IPVS를 지원하기 시작했습니다.

### 추상화

컨테이너는 도커고 도커가 컨테이너라고 생각해도 무리가 없는 상황이지만 쿠버네티스는 CRI(Container runtime interface)를 구현한 다양한 컨테이너 런타임을 지원합니다. [containerd](https://containerd.io/)(사실상 도커..), [rkt](https://coreos.com/rkt/), [CRI-O](https://cri-o.io/) 등이 있습니다.

CRI 외에 CNI(네트워크), CSI(스토리지)를 지원하여 인터페이스만 구현한다면 쉽게 확장하여 사용할 수 있습니다.

## 하나의 Pod이 생성되는 과정

위에서 이야기한 조각을 하나하나 모아서 전체적인 흐름을 살펴보겠습니다. 관리자가 애플리케이션을 배포하기 위해 ReplicaSet을 생성하면 다음과 같은 과정을 거쳐 Pod을 생성합니다.

![ReplicaSet 만들기]({{ site.url }}/assets/article_images/2019-05-19-kubernetes-basic-1/create-replicaset.png)

흐름을 보면 각 모듈은 서로 통신하지 않고 오직 API Server와 통신하는 것을 알 수 있습니다. API Server를 통해 etcd에 저장된 상태를 체크하고 현재 상태와 원하는 상태가 다르면 필요한 작업을 수행합니다. 각 모듈이 하는 일을 보면 다음과 같습니다.

**kubectl**

- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> ReplicaSet 명세를 yml파일로 정의하고 kubectl 도구를 이용하여 API Server에 명령을 전달
- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> API Server는 새로운 ReplicaSet Object를 etcd에 저장

**Kube Controller**

- <i class="nf nf-fa-refresh" aria-hidden="true"></i> Kube Controller에 포함된 ReplicaSet Controller가 ReplicaSet을 감시하다가 ReplicaSet에 정의된 Label Selector 조건을 만족하는 Pod이 존재하는지 체크
- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> 해당하는 Label의 Pod이 없으면 ReplicaSet의 Pod 템플릿을 보고 새로운 Pod(no assign)을 생성. 생성은 역시 API Server에 전달하고 API Server는 etcd에 저장

**Scheduler**

- <i class="nf nf-fa-refresh" aria-hidden="true"></i> Scheduler는 할당되지 않은(no assign) Pod이 있는지 체크
- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> 할당되지 않은 Pod이 있으면 조건에 맞는 Node를 찾아 해당 Pod을 할당

**Kubelet**

- <i class="nf nf-fa-refresh" aria-hidden="true"></i> Kubelet은 자신의 Node에 할당되었지만 아직 생성되지 않은 Pod이 있는지 체크
- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> 생성되지 않은 Pod이 있으면 명세를 보고 Pod을 생성
- <i class="nf nf-fa-play_circle" aria-hidden="true"></i> Pod의 상태를 주기적으로 API Server에 전달

이제 복잡했던 그림이 이해되시나요? 위의 예제는 ReplicaSet에 대해 다뤘지만 모든 노드에 Pod을 배포하는 DaemonSet도 동일한 방식으로 동작합니다. DaemonSet controller와 Scheduler가 전체 노드에 대해 Pod을 할당하면 kubelet이 자기 노드에 할당된 Pod을 생성하는 식입니다.

각각의 모듈이 각자 담당한 상태를 체크하고 독립적으로 동작하는 것을 보면서 참 잘 만든 마이크로서비스 구조라는 생각이 듭니다.

## 결론

이번 글에서 쿠버네티스의 특징과 기본 개념, 개념을 구현한 아키텍처에 대해 알아보았습니다. 쿠버네티스는 아키텍처와 설치가 반, 설정 파일 작성이 나머지 반입니다. 그러니까 벌써 1/4 정도 했네요. 조금 ~~많이~~ 복잡한 것이 사실이지만 예전에 어떤 걸 배울지 선택조차 어렵고 배워도 금방 옛날 지식이 되는 것보단 상황이 낫습니다. 이제 쿠버네티스만 배우면 되니까요.

쿠버네티스와 관련된 생태계는 빠르게 변하고 발전하고 있습니다. Cloud controller는 원래 Kube controller에 포함되어 있었는데 최근 분리되었고 Node의 모니터링을 위해 cAdvisor라는 것을 기본으로 사용했지만 선택 가능하게 제거되었습니다. 사용법이 바뀌고 계속해서 새로운 기능이 추가되지만 기본 적인 구성과 핵심 아키텍처는 크게 바뀌지 않습니다. 기본 적인 동작 원리를 이해하고 있다면 새로운 버전이 나오고 새로운 프레임워크가 등장해도 쉽게 이해하고 확장하여 사용할 수 있습니다.

이제 기본적인 구조를 살펴보았으니 클러스터를 설치하고 사용해봅시다!

---

* [도커에 대해 모른다면 → 초보를 위한 도커 안내서]({% post_url 2017-01-19-docker-guide-for-beginners-1 %})
* **쿠버네티스 시작하기 - 쿠버네티스란 무엇인가? ✓** <span class="series">SERIES 1/4</span>
* 쿠버네티스 시작하기 - 쿠버네티스 설치 (예정) <span class="series">SERIES 2/4</span>
* 쿠버네티스 시작하기 - 컨테이너 배포 (예정) <span class="series">SERIES 3/4</span>
* 쿠버네티스 시작하기 - 스토리지, 설정, 비밀정보 관리 (예정) <span class="series">SERIES 4/4</span>

---
