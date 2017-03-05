---
published: true
title: Docker Swarm을 이용한 쉽고 빠른 분산 서버 관리
tags: [Docker, Swarm, DevOps, Server, Container, Cluster]
layout: post
excerpt: 도커 스웜은 오케스트레이션 툴은 관리가 어렵고 사용하기 복잡하다는 편견을 완전히 바꿔놓았습니다. 구축 비용이 거의 들지 않고 관리 또한 쉬우며 다양한 기능을 쉽게 제공하고 가볍게 사용할 수 있습니다. 도커 스웜의 핵심내용인 노드와 서비스에 대해 알아보고 ingress 네트워크와 자체 내장된 로드밸런서, DNS 서버를 살펴봅니다.
comments: yes
last_modified_at: 2017-03-05T20:30:00+09:00
---

![docker swarm]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/docker-swarm.png)

제가 일하고 있는 퍼플웍스에서는 여러 대의 서버에 다양한 애플리케이션을 설치하여 사용하고 있습니다. ~~아직도 미완성인~~ [홈페이지](http://www.purpleworks.co.kr/) 를 비롯하여 [LDAP](https://ko.wikipedia.org/wiki/LDAP), [Gitlab](https://about.gitlab.com/), [Jenkins](https://jenkins.io/), [Docker Registry](https://docs.docker.com/registry/), [Sensu](https://sensuapp.org/), [Grafana](http://grafana.org/), DB와 같은 업무용 프로그램이 여기저기 설치되어 있고 개발 중인 서비스들의 테스트/스테이징 서버도 여러 대 있습니다.

많은 서비스를 효율적으로 관리하기 위해 서버마다 역할을 부여하였는데 1번 서버는 CI, 2번 서버는 모니터링, 3번 서버는 웹, 4번 서버는 디비, 5번 서버는 큐 이런 식으로 서비스의 종류에 따라 서버를 구분하였습니다. 이런 방식은 효율적이고 정리가 잘된 것처럼 보였지만 서버가 늘어나고 컨테이너가 추가될 때마다 비효율적이라는 걸 알게 되었습니다.

서버가 역할에 따라 나뉘어 있었기 때문에 특정 서버에 컨테이너가 몰리는 상황이 발생했고 역할이 모호한 애플리케이션의 경우는 어디에 설치할지 고민되고 설치하고도 찝찝한 경우가 많았습니다. 리소스가 여유 있는 서버로 컨테이너를 옮기고 싶어도 다른 컨테이너와 의존성이 있어 쉽게 못 옮기는 경우도 있고 IP, Port와 같은 설정 파일을 수정하는 것도 문제였습니다. 컨테이너는 굉장히 유연하여 확장이나 이동이 쉬운데 그런 장점을 거의 못 살리고 있었습니다.

도커덕분에 애플리케이션 설치 자체가 굉장히 편해져 이런 작업은 사소해 보일 수 있지만, 인간의 욕심은 끝이 없고 더욱 격렬하게 아무것도 안 하고 싶기 때문에 컨테이너를 실행할 서버를 고르는 것부터 정보를 관리하는 것까지 모든 과정을 자동화하면 좋겠다는 생각을 했습니다.

다행히 비슷한 고민을 미리한 고오급 개발자들이 있었고 이러한 작업을 [오케스트레이션](https://en.wikipedia.org/wiki/Orchestration_(computing))<sub>Orchestration</sub>이라고 합니다.

## 서버 오케스트레이션 <sub>server orchestration</sub>
![container orchestration]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/container-orchestration.png)

서버 오케스트레이션이라는 용어는 모호한 의미를 가지고 있습니다. 간단하게 정의하면 **여러 대의 서버와 여러 개의 서비스를 편리하게 관리해주는 작업**이라고 할 수 있고 실제로는 스케줄링<sub>scheduling</sub>, 클러스터링<sub>clustering</sub>, 서비스 디스커버리<sub>service discovery</sub>, 로깅<sub>logging</sub>, 모니터링<sub>monitoring</sub> 같은 일을 합니다.

그냥 여러 대의 서버를 편하게 관리하고 싶을 뿐인데 새로운 용어가 많이 등장합니다.

**스케줄링**: 컨테이너를 적당한 서버에 배포해 주는 작업입니다. 툴에 따라서 지원하는 전략이 조금씩 다른데 여러 대의 서버 중 가장 할일 없는 서버에 배포하거나 그냥 차례대로 배포 또는 아예 랜덤하게 배포할 수도 있습니다. 컨테이너 개수를 여러 개로 늘리면 적당히 나눠서 배포하고 서버가 죽으면 실행 중이던 컨테이너를 다른 서버에 띄워주기도 합니다.

**클러스터링**: 여러 개의 서버를 하나의 서버처럼 사용할 수 있습니다. 클러스터에 새로운 서버를 추가할 수도 있고 제거할 수도 있습니다. 작게는 몇 개 안 되는 서버부터 많게는 수천 대의 서버를 하나의 클러스터로 만들 수 있습니다. 여기저기 흩어져 있는 컨테이너도 가상 네트워크를 이용하여 마치 같은 서버에 있는 것처럼 쉽게 통신할 수 있습니다.

**서비스 디스커버리**: 말 그대로 서비스를 찾아주는 기능입니다. 클러스터 환경에서 컨테이너는 어느 서버에 생성될지 알 수 없고 다른 서버로 이동할 수도 있습니다. 따라서 컨테이너와 통신을 하기 위해서 어느 서버에서 실행중인지 알아야 하고 컨테이너가 생성되고 중지될 때 어딘가에 IP와 Port같은 정보를 업데이트해줘야 합니다. 키-벨류 스토리지에 정보를 저장할 수도 있고 내부 DNS 서버를 이용할 수도 있습니다.

**로깅, 모니터링**: 여러 대의 서버를 관리하는 경우 로그와 서버 상태를 한곳에서 관리하는게 편합니다. 툴에서 직접 지원하는 경우도 있고 따로 프로그램을 설치해야 하는 경우도 있습니다. [ELK](https://www.elastic.co/kr/webinars/introduction-elk-stack)와 [prometheus](https://prometheus.io/)등 다양한 툴이 있습니다.

오케스트레이션 툴은 서버를 중앙에서 관리하고 많은 것들을 자동화해주기 때문에 여러 대의 서버를 관리한다면 무조건 도입해야 할 굉장히 환상적인 방법이라고 할 수 있습니다. 

하지만, **이렇게 좋은 게 있는지 알면서도 여러 가지 이유로 도입하기 어려운 게 현실**입니다. ~~시무룩~~

가장 큰 이유는 설치와 관리가 어렵다는 건데 보통 오케스트레이션 툴들은 수백-수천-수만 대의 엄청나게 많은 서버를 관리하기 위한 목적으로 만들어졌습니다. 기본적으로 설치와 관리가 꽤 어려운 편이고 일부 고오오오급 회사들이 아니면 도입하는 비용이 수작업으로 관리하는 비용보다 훨씬 큽니다. 툴에 대해 공부도 많이 해야 하고 뭔가 장애가 생기면 전체 서버에 문제가 생길 수 있어서 도입이 조심스러울 수밖에 없습니다. ~~이거 누가 도입하자고 했어?!~~

이런 상황에서 등장한 도커 스웜은 오케스트레이션 툴은 관리가 어렵고 사용하기 복잡하다는 편견을 완전히 바꿔놓았습니다. **구축 비용이 거의 들지 않고 관리 또한 쉬우며 다양한 기능을 쉽게 제공하고 가볍게 사용**할 수 있습니다.

## 컨테이너 오케스트레이션 툴 <sub>Container Orchestration Tool</sub>

![orchestration tools]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/orchestration-tools.png)

본격적인 스웜 설명에 앞서 다른 컨테이너 오케스트레이션 툴에 대해 살펴보겠습니다. 다양한 툴이 다양한 특징을 가지고 만들어졌으니 가볍게 비교해보면 좋을 것 같습니다.

### fleet by CoreOS
[링크](https://github.com/coreos/fleet) / 설치 및 관리 ★★★★★ / 사용법 ★★★★ / 기능 ★

- CoreOS(Container OS)에 기본으로 내장되어 있는 [systemd](https://www.freedesktop.org/wiki/Software/systemd/)의 cluster 버전
- 스케줄링 외에 특별한 기능이 없어 전체 서버에 무언가(agent류)를 bootstrap 하는 용도에 적당

### Mesos by Apache
[링크](http://mesos.apache.org/) / 설치 및 관리 ★★ / 사용법 ★★★ / 기능 ★★★★

- 역사와 전통의 범용적인 클러스터 툴로 Twitter, Airbnb, Apple, Uber등 다양한 곳에서 사용하여 안정성이 검증됨
- [Zookeeper](https://zookeeper.apache.org/)를 기반으로 여러 대의 서버를 하나의 클러스터로 관리
* 설치와 관리가 어렵고 컨테이너를 사용하기 위해 추가적으로 [Marathon](https://github.com/mesosphere/marathon)이라는 프레임워크를 사용함

### kubernetes by Cloud Native Computing Foundation (with google)
[링크](https://kubernetes.io/) / 설치 및 관리 ★★ / 사용법 ★★★ / 기능 ★★★★★

- 15년 동안 쌓인 구글의 노하우로 만든 "Production-Grade Container Orchestration"으로 기능이 매우 매우 훌륭함
- 자체적으로 구축하려면 설치와 관리가 까다롭지만, [Google Cloud](https://cloud.google.com/), [Azure](https://azure.microsoft.com), [Tectonic](https://coreos.com/tectonic/), [Openshift](https://www.openshift.com/)같은 플랫폼을 이용하면 조금 편해짐
- 구성 및 개념에 대한 이해가 필요하고 새로운 툴과 사용법을 익히는데 시간이 좀 걸림

### EC2 Container Service (ECS) by AWS
[링크](https://aws.amazon.com/ko/ecs/) / 설치 및 관리 ★★★★★ / 사용법 ★★★★ / 기능 ★★

- AWS를 사용 중이라면 쉽게 사용할 수 있고 개념도 간단함
- 기능이 매우 심플하지만 사실 대부분 시스템에서 복잡한 기능은 필요하지 않으므로 단순한 구성이라면 이 이상 편한툴은 없음

### Nomad by HashiCorp
[링크](https://www.nomadproject.io/) / 설치 및 관리 ★★★ / 사용법 ★★★★ / 기능 ★★★★

- [Vagrant](https://www.vagrantup.com/), [Consul](https://www.consul.io/), [Terraform](https://www.terraform.io/), [Vault](https://www.vaultproject.io/)등을 만든 DevOps 장인 [HashiCorp](https://www.hashicorp.com/)의 제품
- 같은 회사의 Consul과 Vault를 연동해서 사용할 수 있고 기능은 다양하고 좋지만 반대로 공부할 게 많고 관리가 복잡할 수 있다는 뜻
- 도커외에 rkt, java 애플리케이션을 지원하고 커맨드라인 명령어는 직관적이고 매우 이쁘게 동작함

### 그외

- [Cattle](https://github.com/rancher/cattle) by rancher, [Cockpit](http://cockpit-project.org/)  by Redhat, [Diego](https://docs.cloudfoundry.org/concepts/diego/diego-architecture.html) by Cloud Foundry, [Flynn](https://flynn.io/)등등 다양한 툴이 있고 딱히 안 써봐서 정확한 내용을 모르지만 괜찮을 것 같음

### 결론

- 적당한 규모(수십 대 이내)에서는 `swarm`
- 큰 규모의 클러스터에서는 `kubernetes`
- AWS에서 단순하게 사용한다면 `ECS`
- HashiCorp팬이라면 `Nomad`


## 도커 스웜 살펴보기

![docker swarm mode]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/swarmnado.gif)

이제 본격적으로 스웜에 대해 알아보겠습니다. 

### 도커 스웜의 등장

스웜은 도커와 별도로 개발되었지만 도커 1.12 버전부터 스웜 모드<sub>Swarm mode</sub>라는 이름으로 합쳐졌습니다. 도커에 모오오오오든게 내장되어 다른 툴을 설치할 필요가 없고 도커 명령어와 compose를 그대로 사용할 수 있어 다른 툴에 비해 압도적으로 쉽고 편리합니다. 

기능이 단순하고 필요한 것만 구현되어 있어 세부적인 컨트롤은 어렵습니다. 갑툭튀한 것 같지만 꽤 오랫동안 개발되었고(2015년 1.0버전) 1,000개 노드에 50,000개 컨테이너도 문제없이 테스트하여 안전성이 검증되었습니다.

### 도커 스웜에서 사용하는 용어

**스웜<sub>swarm</sub>**: 직역하면 떼, 군중이라는 뜻을 가지고 있습니다. 도커 1.12버전에서 스웜이 스웜 모드로 바뀌었지만 그냥 스웜이라고도 하는듯 합니다. 스웜 클러스터 자체도 스웜이라고 합니다. (스웜을 만들다. 스웜에 가입하다. = 클러스터를 만들다. 클러스터에 가입하다)

**노드<sub>node</sub>**: 스웜 클러스터에 속한 도커 서버의 단위입니다. 보통 한 서버에 하나의 도커데몬만 실행하므로 서버가 곧 노드라고 이해하면 됩니다. 매니저 노드와 워커 노드가 있습니다.

**매니저노드<sub>manager node</sub>**: 스웜 클러스터 상태를 관리하는 노드입니다. 매니저 노드는 곧 워커노드가 될 수 있고 스웜 명령어는 매니저 노드에서만 실행됩니다.

**워커노드<sub>worker node</sub>**: 매니저 노드의 명령을 받아 컨테이너를 생성하고 상태를 체크하는 노드입니다. 

**서비스<sub>service</sub>**: 기본적인 배포 단위입니다. 하나의 서비스는 하나의 이미지를 기반으로 생성하고 동일한 컨테이너를 한개 이상 실행할 수 있습니다.

**테스크<sub>task</sub>**: 컨테이너 배포 단위입니다. 하나의 서비스는 여러개의 테스크를 실행할 수 있고 각각의 테스크가 컨테이너를 관리합니다.


### 도커 스웜이 제공하는 기능

Docker 1.13을 기준으로 어떤 기능을 제공하는지 하나하나 살펴봅니다.

**스케줄링 <sub>scheduling</sub>**: 서비스를 만들면 컨테이너를 워커노드에 배포합니다. 현재는 균등하게 배포<sub>spread</sub>하는 방식만 지원하며 추후 다른 배포 전략이 추가될 예정입니다.
노드에 라벨을 지정하여 특정 노드에만 배포할 수 있고 모든 서버에 한 대씩 배포하는 기능(Global)도 제공합니다. 서비스별로 CPU, Memory 사용량을 미리 설정할 수 있습니다.

**고가용성 <sub>High Available</sub>**: [Raft 알고리즘](https://raft.github.io/)을 이용하여 여러 개의 매니저노드를 운영할 수 있습니다. 3대를 사용하면 1대가 죽어도 클러스터는 정상적으로 동작하며 매니저 노드를 지정하는 방법은 간단하므로 쉽게 관리할 수 있습니다.

**멀티 호스트 네트워크 <sub>Multi Host Network</sub>**: Overlay network로 불리는 SDN(Software defined networks)를 지원하여 여러 노드에 분산된 컨테이너를 하나의 네트워크로 묶을수 있습니다. 컨테이너마다 독립된 IP가 생기고 서로 다른 노드에 있어도 할당된 IP로 통신할 수 있습니다. (호스트 IP를 몰라도 됩니다!)

**서비스 디스커버리 <sub>Service Discovery</sub>**: 서비스 디스커버리를 위한 자체 DNS 서버를 가지고 있습니다. 컨테이너를 생성하면 서비스명과 동일한 도메인을 등록하고 컨테이너가 멈추면 도메인을 제거합니다. 멀티 호스트 네트워크를 사용하면 여러 노드에 분산된 컨테이너가 같은 네트워크로 묶이므로 서비스 이름으로 바로 접근할 수 있습니다. Consul이나 etcd, zookeeper와 같은 외부 서비스를 사용하지 않고 어떠한 추가 작업도 필요 없습니다. 스웜이 알아서 다 해 줍니다.

**순차적 업데이트 <sub>Rolling Update</sub>**: 서비스를 새로운 이미지로 업데이트하는 경우 하나 하나 차례대로 업데이트합니다. 동시에 업데이트하는 작업의 개수와 업데이트 간격 시간을 조정할 수 있습니다.

**상태 체크 <sub>Health Check</sub>**: 서비스가 정상적으로 실행되었는지 확인하기 위해 컨테이너 실행 여부 뿐 특정 쉘 스크립크가 정상으로 실행됐는지 여부를 추가로 체크할 수 있습니다. 컨테이너 실행 여부로만 체크할 경우 아직 서버가 실행 되지 않아 접속시 오류가 날 수 있는 미묘한 타이밍을 잡는데 효과적입니다.

**비밀값 저장 <sub>Secret Management</sub>**: 비밀번호를 스웜 어딘가에 생성하고 컨테이너에서 읽을 수 있습니다. 비밀 값을 관리하기 위한 외부 서비스를 설치하지 않고 쉽게 사용할 수 있습니다.

**로깅 <sub>Logging</sub>**: 같은 노드에서 실행 중인 컨테이너뿐 아니라 다른 노드에서 실행 중인 서비스의 로그를 한곳에서 볼 수 있습니다. 특정 서비스의 로그를 보려면 어느 노드에서 실행 중인지 알필요도 없고 일일이 접속하지 않아도 됩니다.

**모니터링 <sub>Monitoring</sub>**: 리소스 모니터링 기능은 제공하지 않습니다. 3rd party 서비스([prometheus](https://prometheus.io/), [grafana](http://grafana.org/))를 사용해야 합니다. 설치는 쉽지만 은근 귀츈...

**크론, 반복작업 <sub>Cron</sub>**: 크론, 반복작업도 알아서 구현해야 합니다. 여러 가지 방식으로 해결할 수 있겠지만 직접 제공하지 않아 아쉬운 부분입니다.


## 스웜실습

본격적으로 스웜 클러스터를 만들고 여러 가지 서비스를 생성해보면서 도커 스웜에 빠져보겠습니다. 전체적인 내용은 다음과 같습니다.

0. 준비
1. 스웜 클러스터 만들기
2. 기본 웹 애플리케이션 서비스
3. 방문자 수 체크 애플리케이션 (with redis)
4. 비밀키 조회 애플리케이션
5. Traefik 리버스 프록시 서버
6. 스웜 서버 모니터링

### 준비

[Vagrant](https://www.vagrantup.com/)를 이용하여 3개의 [CoreOS(Container Linux)](https://coreos.com/os/docs/latest)가상머신을 만듭니다. 각각 1 CPU와 1G Memory를 할당하고 매니저 노드 하나와 워커 노드 2개를 설정하여 사용합니다.

![virtual machines]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/create-virtual-machine.png)

- core-01 (manager) / 172.17.8.101 / 1 cpu / 1G memory
- core-02 (worker) / 172.17.8.102 / 1 cpu / 1G memory
- core-03 (worker) / 172.17.8.103 / 1 cpu / 1G memory

> Vagrant는 VirtualBox, VMWare, Parallels같은 가상머신을 쉽게 만들고 관리해주는 툴입니다. CoreOS는 도커가 내장된 가벼운 OS입니다.  

가상머신을 만드는 방법은 다음과 같습니다.

1. virtual box 설치 [다운로드](https://www.virtualbox.org/)
2. Vagrant 설치 [다운로드](https://www.vagrantup.com/downloads.html)
3. [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin 설치 
    `vagrant plugin install vagrant-hostsupdater`
4. 데모 파일 다운로드 [GitHub - docker swarm demo](https://github.com/subicura/docker-swarm-demo)
5. 가상머신 생성
데모 디렉토리에서 `vagrant up` 명령어 실행 -> 자동으로 생성!

가상머신이 정상적으로 생성되었는지 확인하려면 `vagrant status`, 가상머신을 삭제하려면 `vagrant destroy` 를 실행합니다. 가상머신에 접속하는 명령어는  `vagrant ssh [가상머신이름]`입니다.

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/vagrant-up.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>vagrant up</figcaption>
</div>

### 스웜 클러스터 만들기

가상머신이 정상적으로 생성되었으면 스웜 클러스터를 만들어보겠습니다. 스웜 클러스터는 매니저 노드를 먼저 만들고 매니저 노드가 생성한 토큰을 가지고 워커 노드에서 매니저 노드로 접속하면 됩니다.

먼저, `core-01`서버를 매니저 노드로 설정합니다. `swarm init`명령어를 사용합니다.

{% highlight bash linenos %}
# vagrant ssh core-01
docker swarm init --advertise-addr 172.17.8.101
{% endhighlight %}

output: 

{% highlight bash linenos %}
Swarm initialized: current node (gjm2fxwcx29ha4rfzkw3zskvt) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-1la23f7y6y8joqxz27hac4j79yffyixcp15tjtlrnei14wwd1t-5tlmx4q9fm46drjzzd95g1l4q \
    172.17.8.101:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
{% endhighlight %}

순식간에 매니저 노드가 생성되었습니다. `swarm init`명령어를 실행하면 친절하게 워커 노드에서 실행할 명령어를 알려줍니다. ~~친절한도커씨~~ 명령어를 그대로 복사하여 2, 3번 서버에서 각각 실행합니다.

{% highlight bash linenos %}
# vagrant ssh core-02
docker swarm join \
    --token SWMTKN-1-1la23f7y6y8joqxz27hac4j79yffyixcp15tjtlrnei14wwd1t-5tlmx4q9fm46drjzzd95g1l4q \
    172.17.8.101:2377
{% endhighlight %}

output:
 
{% highlight bash linenos %}
This node joined a swarm as a worker.
{% endhighlight %}

워커 노드가 정상적으로 만들어졌는지 매니저 노드에서 확인합니다. 

{% highlight bash linenos %}
docker node ls
{% endhighlight %}

output:

{% highlight bash linenos %}
ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS
gjm2fxwcx29ha4rfzkw3zskvt *  core-01   Ready   Active        Leader
mu6l92w2dzjmsbucvar1bl9mg    core-03   Ready   Active
q5pa26ik11g9surws03quvrsk    core-02   Ready   Active
{% endhighlight %}

명령어 3줄로 클러스터가 생성되었습니다. 도커 외에 아무것도 설치하지 않았고 어떤 agent도 실행하지 않았습니다. 이렇게 쉽게 생성되는 클러스터 보셨나요?

> 매니저 노드가 관리하는 정보는  `/var/lib/docker/swarm`에 저장됩니다.  

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/swarm-cluster.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>init swarm cluster</figcaption>
</div>

### 기본 웹 애플리케이션

클러스터가 생성되었으니 간단한 웹 애플리케이션 서비스를 생성해보겠습니다.

서비스를 생성하려면 `service create`명령어를 이용합니다. `run`명령어와 아주 유사합니다.

{% highlight bash linenos %}
docker service create --name whoami \
  -p 4567:4567 \
  subicura/whoami:1
{% endhighlight %}

output:

{% highlight bash linenos %}
beepr6q5kdm724vdvgmb2awxg
{% endhighlight %}

`subicura/whoami:1` 이미지는 서버의 hostname을 출력하는 단순한 웹 애플리케이션입니다. 서비스의 이름을 `whoami` 로 지정했고 4567 포트를 오픈하였습니다.

서비스가 잘 생성되었는지 `service ls`명령어로 확인해보겠습니다.

{% highlight bash linenos %}
docker service ls
{% endhighlight %}

output:

{% highlight bash linenos %}
ID            NAME    MODE        REPLICAS  IMAGE                               
beepr6q5kdm7  whoami  replicated  0/1       subicura/whoami:1 
{% endhighlight %}

`whoami`라는 서비스가 보입니다. 아직 컨테이너가 생성되지 않아 REPLICAS 상태가 `0/1`입니다. 좀 더 상세한 상태를 확인하기 위해 `service ps`명령어를 입력합니다.

{% highlight bash linenos %}
docker service ps whoami
{% endhighlight %}

output:

{% highlight bash linenos %}
ID            NAME      IMAGE              NODE     DESIRED STATE  CURRENT STATE            ERROR  PORTS
wnt5m97ci36t  whoami.1  subicura/whoami:1  core-01  Running        Preparing 7 seconds ago
{% endhighlight %}

서비스의 상태와 어떤 노드에서 실행 중인지를 상세하게 확인할 수 있습니다. 현재 상태가 `Preparing`인걸 보니 이미지를 다운 받는 중인 것 같습니다. 조금만 기다리고 컨테이너가 실행되면 상태가 `Running`으로 바뀝니다.

정상적으로 서비스가 실행되었는지 HTTP 요청으로 테스트해보겠습니다.

{% highlight bash linenos %}
curl core-01:4567

#output
cfb152786b87
{% endhighlight %}

와우! 첫번째 서비스를 성공적으로 생성하였습니다.

`core-01`에서 테스트를 했는데 다른 서버도 테스트해볼까요?

{% highlight bash linenos %}
curl core-02:4567
curl core-03:4567

#output
cfb152786b87
cfb152786b87
{% endhighlight %}

분명 컨테이너는  `core-01`노드에서 실행중인데 모든 노드에서 정상적으로 응답하고 있습니다. 어떻게 된일일까요?

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/basic-web-application.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>basic web application</figcaption>
</div>

### Ingress network

도커 스웜은 서비스를 외부에 쉽게 노출하기 위해 모든 노드가 [ingress](https://docs.docker.com/engine/swarm/ingress/)라는 가상 네트워크에 속해있습니다. ingress는 routing mesh라는 재미있는 개념을 가지고 있는데 이 개념은 서비스가 포트를 오픈할 경우 모오오든 노드에 포트가 오픈되고 어떤 노드에 요청을 보내도 실행 중인 컨테이너에 자동으로 전달해줍니다. 

> Ingress는 (어떤 장소에) 들어감, 입장이라는 뜻을 가지고 있습니다.

![ingress network]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/ingress-network.png)

위의 예제에서는 4567 포트를 오픈했기 때문에 3개의 노드 전체에 4567 포트가 오픈되었고 어디에서 테스트를 하든 간에 core-01노드에 실행된 컨테이너로 요청이 전달됩니다. 컨테이너가 여러 개라면 내부 로드밸런서를 이용하여 여러 개의 컨테이너로 분산처리됩니다.

뭔가 어색한 개념이라고 생각할 수 있지만, 어느 서버에 컨테이너가 실행 중인지 알 필요 없이 외부에서 그 어떤 방법보다 쉽게 접근할 수 있습니다.

> 실제 운영시에는 외부에 nginx 또는 haproxy같은 로드발란서를 두고 전체 스웜 노드를 바라보게 설정할 수 있습니다. [관련링크](https://docs.docker.com/engine/swarm/ingress/#/configure-an-external-load-balancer)

### 서비스 복제 replication

앞에서 생성한 웹 애플리케이션에 부하가 발생했다고 가정하고 컨테이너를 5개로 늘려보겠습니다. 노드가 3개인데 컨테이너를 5개로 늘리면 서버 한 개에 2개의 컨테이너가 생성됩니다. 어차피 각각은 독립된 컨테이너이기 때문에 여러 개를 생성해도 상관없고 ingress 네트워크가 알아서 요청을 분산처리해줍니다.

![service replication]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/replication.png)

`service scale`명령어를 이용하여 서비스 개수를 늘려보겠습니다.

{% highlight bash linenos %}
docker service scale whoami=5
{% endhighlight %}

output:

{% highlight bash linenos %}
whoami scaled to 5 
{% endhighlight %}

`serivice ps`명령어를 이용하여 상태를 확인합니다.

{% highlight bash linenos %}
docker service ps whoami
{% endhighlight %}

output:

{% highlight bash linenos %}
ID            NAME      IMAGE              NODE     DESIRED STATE  CURRENT STATE            ERROR  PORTS
z5mcfb0lcizi  whoami.1  subicura/whoami:1  core-01  Running        Running 11 minutes ago
nwkduapf1kvk  whoami.2  subicura/whoami:1  core-03  Running        Preparing 4 seconds ago
vhxmipcdht6c  whoami.3  subicura/whoami:1  core-03  Running        Preparing 4 seconds ago
mntns383mnhz  whoami.4  subicura/whoami:1  core-01  Running        Running 4 seconds ago
xga086cubnj3  whoami.5  subicura/whoami:1  core-02  Running        Preparing 4 seconds ago
{% endhighlight %}

처음 컨테이너를 생성하는 노드에서 이미지를 다운받는동안 Pending인 상태가 보이고 조금 기다리면 모두 실행됩니다. 이제 테스트해볼까요?

{% highlight bash linenos %}
curl core-01:4567
curl core-01:4567
curl core-01:4567
curl core-01:4567
curl core-01:4567
curl core-01:4567

#output
7590556fb196
7d5e26679eb8
a2c04acee702
88498091561a
e970ff9ed9c6
7590556fb196
{% endhighlight %}

5개의 컨테이너에 아주 이쁘게 요청이 분산되었습니다. 아무런 설정 없이 ingress 네트워크가 알아서 로드 밸런서 역할을 해주고 있습니다. Nginx나 haproxy같은 설정이 필요 없습니다. 너무 편하지 않나요?

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/replication.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>replication</figcaption>
</div>

### HEALTHCHECK

![container running status]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/healthcheck.png)

스웜은 컨테이너가 실행되면 ingress에서 해당 컨테이너로 요청을 보내기 시작하는데 웹 서버가 부팅되는 동안 문제가 있습니다. 바로 위에 시연 리플레이를 보면 curl 테스트를 하는 도중 에러가 발생하는 걸 확인할 수 있습니다. ingress는 컨테이너가 실행되면 요청을 보내기 때문에 문제가 없을거라고 생각할 수 있지만 컨테이너가 실행되고 웹 서버가 완전히 실행되기 전에 요청을 보내면 서버를 찾을 수 없다는 메시지를 볼 수 있고 이러한 문제를 해결하기 위해 좀 더 자세한 상태 체크 방식이 필요하게 되었습니다.

도커 1.12버전에서  `HEALTHCHECK`명령어가 추가되었고 쉘 스크립트를 작성하여 좀 더 정확한 상태를 체크 할 수 있습니다.

{% gist subicura/57557d89ebc64005988e260515413b2a %}

아주 익숙한 도커파일샘플에 HEALTHCHECK 명령어를 추가했습니다. HEALTHCHECK 부분을 보면 10초마다 wget을 이용하여 4567 포트를 체크하는 걸 볼 수 있습니다. 스크립트(wget)가 0을 리턴하면 정상이라고 판단하고 그때서야 요청을 보내게 됩니다.

처음 테스트로 생성한 서비스를 `subicura/whoami:2`이미지로 업데이트 해보겠습니다. 버전 1과 차이점은 HEALTHCHECK 유무입니다. HEALTHCHECK 옵션이 없다면 업데이트하는 동안 순간적으로 에러가 발생할 수 있는데 그런 문제를 방지해 줍니다.

`service update`명령어를 이용하여 서비스를 업데이트합니다.

{% highlight bash linenos %}
docker service update \
--image subicura/whoami:2 \
whoami
{% endhighlight %}

output: 

{% highlight bash linenos %}
whoami scaled to 5
{% endhighlight %}

`service ps`명령어로 업데이트 상태를 확인해보겠습니다.

{% highlight bash linenos %}
docker service ps whoami
{% endhighlight %}

output: 

{% highlight bash linenos %}
ID            NAME          IMAGE              NODE     DESIRED STATE  CURRENT STATE           ERROR  PORTS
kv2jddl0bsfw  whoami.1      subicura/whoami:2  core-01  Ready          Ready 2 seconds ago
z5mcfb0lcizi   \_ whoami.1  subicura/whoami:1  core-01  Shutdown       Running 11 seconds ago
nwkduapf1kvk  whoami.2      subicura/whoami:1  core-03  Running        Running 9 minutes ago
vhxmipcdht6c  whoami.3      subicura/whoami:1  core-03  Running        Running 9 minutes ago
mntns383mnhz  whoami.4      subicura/whoami:1  core-01  Running        Running 11 minutes ago
xga086cubnj3  whoami.5      subicura/whoami:1  core-02  Running        Running 9 minutes ago
{% endhighlight %}

하나씩 하나씩 이쁘게 업데이트되는 과정을 볼 수 있고 접속 테스트를 하면 문제 없이 업데이트되는걸 확인 할 수 있습니다.

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/healthcheck.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>service update</figcaption>
</div>

### 방문자수 체크 웹 애플리케이션

아주아주 간단한 실습에 이어 조금 복잡한 구성을 살펴봅니다. 실제 세상에서는 웹 애플리케이션이 혼자 실행되는 경우가 거의 없죠. redis와 함께 웹 애플리케이션을 실행하고 서버에 접속할 때마다 카운트를 +1 하는 서비스를 만들어 보겠습니다.

먼저, 웹 애플리케이션과 redis가 통신할 수 있는 오버레이 네트워크를 만듭니다. 오버레이 네트워크를 사용하면 redis는 외부에 포트를 오픈하지 않아도 되고 웹 애플리케이션과 다른 노드에 있어도 같은 서버에 있는 것처럼 통신할 수 있습니다.

![overlay network]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/overlay-network.png)

`network create`명령어로 오버레이 네트워크를 생성합니다.

{% highlight bash linenos %}
docker network create --attachable \
  --driver overlay \
  backend
{% endhighlight %}

output:

{% highlight bash linenos %}
k7ayhk5hqbxnk8zbb959txh6h  
{% endhighlight %}

잘 생성되었는지 `network ls`명령어로 확인해보겠습니다.

{% highlight bash linenos %}
docker network ls
{% endhighlight %}

output:

{% highlight bash linenos %}
NETWORK ID          NAME                DRIVER              SCOPE
k7ayhk5hqbxn        backend             overlay             swarm
c420312e4c9b        bridge              bridge              local
c3ef285ed639        docker_gwbridge     bridge              local
244840dc44fd        host                host                local
4biz947vsmez        ingress             overlay             swarm
f41f0c773519        none                null                local
{% endhighlight %}

backend라는 이름의 오버레이 네트워크가 생성되었습니다. 그 외에 네트워크는 기본으로 생성되는 네트워크들입니다. 이제 redis를 backend네트워크에 생성하겠습니다.

![redis with overlay network]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/overlay-network-redis.png)


{% highlight bash linenos %}
docker service create --name redis \
  --network=backend \
  redis
{% endhighlight %}

output

{% highlight bash linenos %}
cjqrmjqfvj8zyr7k9skih01g4
{% endhighlight %}

`--network` 옵션으로 어느 네트워크에 속할지 정의하였습니다. backend 네트워크에 속한 redis 서비스는 외부 네트워크에서는 접근할 수 없고 backend 네트워크 상에서 원래 포트인 6379로 접속할 수 있습니다.

redis 서비스가 제대로 생성되었다면 telnet명령어로 테스트해보겠습니다.

{% highlight bash linenos %}
docker run --rm -it \
  --network=backend \
  alpine \
  telnet redis 6379

# test
KEYS *
SET hello world
GET hello
DEL hello
QUIT
{% endhighlight %}

외부 네트워크에서는 redis 서버에 접근할 수 없으므로 접속 테스트용 컨테이너를 생성하였습니다. `--network`옵션으로 backend 네트워크에 접속하였고 redis 서비스의 이름이 곧 도메인명이므로 바로 접속할 수 있습니다.

> 스웜은 서비스가 실행되면 내부 DNS에 자동으로 도메인 정보를 등록합니다. 따로 IP를 관리할 필요 없이 서비스명으로 접근할 수 있습니다.  

이제 방문자 수를 체크하는 웹 애플리케이션 서비스를 생성해보겠습니다.

![web application + redis]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/overlay-network-redis-counter.png)

{% highlight bash linenos %}
docker service create --name counter \
  --network=backend \
  --replicas 3 \
  -e REDIS_HOST=redis \
  -p 4568:4567 \
  subicura/counter
{% endhighlight %}

output:

{% highlight bash linenos %}
nlq75mhritr3hj4tibm8ka9d8
{% endhighlight %}

redis 서버와 통신해야 하므로 backend 네트워크를 지정했고 `--replicas`옵션을 이용하여 3개를 생성하도록 했습니다. 외부의 4568 포트로 접근할 수 있도록 포트를 오픈 했고 redis 서버의 도메인명을 환경변수로 전달했습니다.

이제 테스트해볼까요?

{% highlight bash linenos %}
curl core-01:4568

#output
50bec9ce8874 > 1

curl core-01:4568

#output
50bec9ce8874 > 1
6705a6272a4a > 1

curl core-01:4568

#output
50bec9ce8874 > 1
6705a6272a4a > 1
92b471d0d741 > 1

curl core-01:4568

#output
50bec9ce8874 > 2
6705a6272a4a > 1
92b471d0d741 > 1

curl core-01:4568

#output
50bec9ce8874 > 2
6705a6272a4a > 2
92b471d0d741 > 1

curl core-01:4568

#output
50bec9ce8874 > 2
6705a6272a4a > 2
92b471d0d741 > 2
{% endhighlight %}

웹 애플리케이션 서버와 redis가 backend오버레이 네트워크를 통해 연결되었고 ingress 네트워크가 3개의 웹 컨테이너에 이쁘게 부하를 분산하였습니다. 

스웜은 서로 통신이 필요한 서비스를 같은 이름의 오버레이 네트워크로 묶고 내부 DNS 서버를 이용하여 접근할 수 있습니다. 여러 개의 네트워크를 쉽게 만들 수 있고 하나의 서비스는 여러 개의 네트워크에 속할 수 있습니다. 모든 것은 스웜이 알아서 하고 관리자는 네트워크와 서비스만 잘 만들면 됩니다.

> 내부 DNS에서 counter의 IP는 10.0.0.4로 3개 컨테이너의 로드 벨런서용 IP를 가리키고 있습니다. 실제 각각의 IP는 tasks.counter의 A Record에 기록되어 있고 10.0.0.5~7을 가지고 있습니다.  

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/overlay.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>service with overlay</figcaption>
</div>

### 비밀키 조회 애플리케이션

이번에는 1.13에 추가된 비밀키 관리 기능을 이용해보겠습니다. 먼저 비밀키를 생성합니다. 파일 또는 파이프를 이용한 stdin입력만 가능합니다.

{% highlight bash linenos %}
echo "this is my password!" | docker secret create my-password -
{% endhighlight %}

output:

{% highlight bash linenos %}
8rsw3eu74xea4q2e8mnhuw6lu
{% endhighlight %}

`my-passsword`라는 이름의 비밀키에 `this is my password!`라는 내용을 저장하였습니다. 이제 이 키를 사용할 서비스를 하나 생성하겠습니다.

{% highlight bash linenos %}
docker service create --name secret \
  --secret my-password \
  -p 4569:4567 \
  -e SECRET_PATH=/run/secrets/my-password \
  subicura/secret
{% endhighlight %}

output:

{% highlight bash linenos %}
nmyk5647bv4mfneafwhpg7o4t
{% endhighlight %}

`--secret`옵션으로 어떤 키를 사용할지 지정하면 `/run/secrest`디렉토리 밑에 키 이름의 파일로 마운트 됩니다. `subicura/secret` 이미지는 파일의 내용을 출력해주는 웹 애플리케이션으로 4569포트로 오픈하였습니다.

잘 동작하는지 테스트해보겠습니다.

{% highlight bash linenos %}
curl core-01:4569
{% endhighlight %}

output:

{% highlight bash linenos %}
this is my password!
{% endhighlight %}

아주 잘 동작합니다. 도커를 이용하여 서비스를 구축하면 패스워드 정보를 어떻게 할지 고민일 때가 있는데 아주 유용하게 사용할 수 있습니다.

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/secret.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>docker secret</figcaption>
</div>

### Traefik 리버스 프록시 서버

스웜은 매니저 노드에서 모든 서비스를 관리할 수 있고 서비스가 생성된 것을 체크하면 무언가를 자동화할 수 있습니다. [Traefik](https://traefik.io/)은 이러한 아이디어를 이용해 웹 애플리케이션이 생성되면 자동으로 도메인을 만들고 내부 서비스로 연결해줍니다.

예를 들어 `whoami`라는 서비스를 만들면 `whoami.local.dev`도메인으로 접속할 수 있게 해주고 `counter`라는 서비스를 만들면 `counter.local.dev`도메인으로 접속할 수 있게 해줍니다.

테스트를 위해 도메인 정보를 `/etc/hosts`에 추가합니다.

{% highlight bash linenos %}
172.17.8.101 portainer.local.dev counter.local.dev
{% endhighlight %}

프록시로 연결하기 위해 `frontend`라는 네트워크를 생성합니다.

{% highlight bash linenos %}
docker network create --driver overlay frontend
{% endhighlight %}

이제 `traefik`서비스를 frontend네트워크에 연결합니다.

{% highlight bash linenos %}
docker service create --name traefik \
  --constraint 'node.role == manager' \
  -p 80:80 \
  -p 8080:8080 \
  --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
  --network frontend \
  traefik \
  --docker \
  --docker.swarmmode \
  --docker.domain=local.dev \
  --docker.watch \
  --web
{% endhighlight %}

`--constraint` 옵션을 이용하여 매니저 노드에서 실행하게 배포를 제한하였습니다. 스웜 서비스 정보를 얻기 위해서는 반드시 매니저 노드에서 실행되어야 합니다. 그리고 `--mount` 옵션을 이용해 호스트의 도커 소켓을 마운트 하였습니다. `docker run -v` 옵션과 유사한데 service를 만들 때는 `--mount` 옵션을 사용합니다. 80포트는 실제 웹 서비스를 제공하기 위해 사용할 포트고 8080은 관리자용 포트입니다.

관리자 페이지에 접속해보겠습니다.

![traefik dashboard]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/traefik.png)

뭔가 그럴싸한 관리자 화면이 보입니다. 아직 아무것도 실행하지 않아 휑한 모습입니다. [portainer](http://portainer.io/) 웹 애플리케이션을 실행하여 자동으로 연결해보겠습니다.

{% highlight bash linenos %}
docker service create --name portainer \
  --network=frontend \
  --label traefik.port=9000 \
  --constraint 'node.role == manager' \
  --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
  portainer/portainer
{% endhighlight %}

traefik과 접속할 수 있도록 frontend네트워크에 연결했고 `--label`옵션으로 내부적으로 사용하는 웹 포트를 알려주었습니다. traefik은 `traefik.port`라벨의 값을 읽어 해당 포트로 리버스 프록시를 연결합니다. portainer는 스웜을 관리해주는 툴이기 때문에 매니저 노드에 실행하도록 했습니다.

서비스 이름을 portainer로 했기 때문에 서비스가 실행되면 traefik서비스가 자동으로 `portainer.local.dev`도메인 정보를 생성하고 portainer컨테이너의 9000번 포트로 연결합니다. 서비스를 생성하고 잠시 기다리면 프록시 설정이 자동으로 완료됩니다.

![traefik dashboard - portainer]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/traefik-portainer.png)

traefik 관리자 화면에 portainer가 등록된 모습이 보입니다! 이제 실제로 `portainer.local.dev`에 접속해보겠습니다.

![portainer dashboard]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/portainer-1.png)
![portainer services]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/portainer-2.png)
![portainer swarm]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/portainer-3.png)

portainer도 역시 접속 성공입니다! 이제 어떤 서비스도 frontend네트워크를 연결하고 `traefik.port` 라벨만 지정하면 자동으로 외부에 노출됩니다. 내친김에 아까 만든 `counter`서비스도 붙여보겠습니다.

{% highlight bash linenos %}
docker service rm counter
docker service create --name counter \
  --network=frontend \
  --network=backend \
  --replicas 3 \
  --label traefik.port=4567 \
  -e REDIS_HOST=redis \
  subicura/counter
{% endhighlight %}

기존에 생성되어 있던 서비스를 삭제하고 새로운 옵션으로 서비스를 생성하였습니다. frontend와 backend 두개의 네트워크에 모두 속해있고 label을 주어 traefik에서 자동으로 인식할 수 있도록 했습니다. 이제 테스트해볼까요?

{% highlight bash linenos %}
curl counter.local.dev

# output

50bec9ce8874 > 2                                                                
5cbd7ecbb5b8 > 1                                                                
6705a6272a4a > 2                                                                
92b471d0d741 > 2 
{% endhighlight %}


![this is magic!]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/magic.gif)

마법과 같은 일이 옵션 몇줄로 일어났습니다. 음.. 스웜 정말 좋지 않나요?

<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-02-25-container-orchestration-with-docker-swarm/traefik.json" poster="npt:0:15" speed="2"></asciinema-player>
  <figcaption>traefik</figcaption>
</div>

### 스웜 서버 모니터링

스웜은 자체적인 모니터링 서비스를 제공하지 않습니다. 따라서 적당한 툴을 선택하여 직접 운영해야 합니다. [prometheus](￼https://prometheus.io/)와 [grafana](￼http://grafana.org/)를 이용하면 아주 그럴듯한 모니터링 시스템을 만들 수 있습니다. 게다가 `docker stack`명령어를 이용하면 여러 개의 서비스를 일일이 생성하지 않고 하나의 docker-compose 설정 파일로 관리할 수 있습니다. 명령어 한 줄로 모든 서버에 정보를 수집하는 서비스를 생성하고 모니터링 툴을 설치할 수 있습니다.

![grafana]({{ site.url }}/assets/article_images/2017-02-25-container-orchestration-with-docker-swarm/grafana.png)

스크린샷이 그럴듯해 보이지 않나요? 이부분에 대한 자세한 내용은 prometheus와 더불어 다음 기회에 따로 포스팅하도록 하겠습니다. 

- <a class="waiting-post">[준비중] 도커 스웜과 prometheus를 이용한 서버 모니터링</a>

## 결론
도커 스웜의 핵심내용인 노드와 서비스에 대해 알아보았고 ingress 네트워크와 자체 내장된 로드밸런서, DNS 서버를 사용해봤습니다.

도커 스웜은 어떠한 툴도 추가적으로 설치할 필요 없이 굉장히 간단하고 빠르게 클러스터를 구성할 수 있습니다. 기능적으로 아쉬운 부분이 조금 있지만 작은 규모에서 일반적인 작업을 하기에는 무리가 없습니다. (오토스케일링 같은 기능을 많은 곳에서 쓰진 않겠죠)

기존에 오케스트레이션 도입을 꺼렸던 많은 소규모 개발팀에서는 스웜이 아주 매력적인 선택이 될 것 같습니다.

