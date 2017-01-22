---
published: true
title: 도커를 이용한 웹서비스 무중단 배포하기
excerpt: 홈쇼핑처럼x밀본고기덮밥이 팔리는걸 관리자화면에서 보면서 하루에도 여러번 소스를 업데이트 하고 운영서버로 배포했던 내용이 떠올라 후기로 정리합니다. 배포는 단순히 로컬의 소스를 운영 서버로 복사하는 것입니다. FTP로 파일을 복사하는 방식은 가장 기본이면서 그럭저럭 잘 동작합니다. 배포 중에 서비스가 잠깐 멈추는 문제가 있다면 새벽에 배포하면 되고 굳이 다른 개발할일도 많은데 배포에 신경을 써야 하는 생각도 듭니다. 하지만, 오히려 배포가 탄탄해지면 서비스 개발에 집중할 수 있고 하루에 몇번이라도 배포를 자주, 더 빨리 하는 것이 서비스의 경쟁력이 되는 세상입니다. 서비스가 빠르게 발전하고 있고 서버를 확장하려면 미리미리 신경쓰는 것이 맞다고 생각합니다.
tags: [Docker, DevOps, Server, Deployment]
layout: post
comments: yes
fb_social_baseurl: http://subicura.com
last_modified_at: 2017-01-21T10:00:00+09:00
---

![밀본x고기덮밥]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/milbon.jpg)

[홈쇼핑처럼x밀본고기덮밥](https://www.likehs.com/tvprogram/index/view/id/22/)이 팔리는걸 관리자화면에서 보면서 하루에도 여러번 소스를 업데이트 하고 운영서버로 배포했던 내용이 떠올라 후기로 정리합니다.

배포는 단순히 로컬의 소스를 운영 서버로 복사하는 것입니다. FTP로 파일을 복사하는 방식은 가장 기본이면서 그럭저럭 잘 동작합니다. 배포 중에 서비스가 잠깐 멈추는 문제가 있다면 새벽에 배포하면 되고 굳이 다른 개발할일도 많은데 배포에 신경을 써야 하는 생각도 듭니다.

하지만, 오히려 배포가 탄탄해지면 서비스 개발에 집중할 수 있고 하루에 몇번이라도 배포를 자주, 더 빨리 하는 것이 서비스의 경쟁력이 되는 세상입니다. 서비스가 빠르게 발전하고 있고 서버를 확장하려면 미리미리 신경쓰는 것이 맞다고 생각합니다.

현재 홈쇼핑처럼 운영서버는 크게 웹(+API), 마이크로서비스(배송조회, 우편번호검색), 영상, 채팅, 모니터링으로 구성되어 있습니다. 여기서는 웹 서비스 배포에 대해서 이야기 하려고 합니다.

웹 서비스는 웹서버 1대(nginx + php)와 디비서버 1대(mysql + redis)로 가난하게 구성되어 있습니다. 서버 규모에 맞게 최대한 단순하게 배포 프로세스를 구성하려고 했지만, 추후 서비스가 잘 되었을때를 고려하여 확장가능성도 고려하였습니다.

## 어떻게 배포할까?

배포 프로세스를 만들면서 고민했던 내용입니다.

- 쉽고 관리하기 편한 방법을 선택하자
- 자동으로 배포하자
- 하루에도 여러번 배포하자
- 배포중 서비스가 중단되는 일이 없도록 하자
- 모든 서비스는 도커를 이용해서 컨테이너 형태로 표준화하여 배포하자
- 테스트 서버에 동일한 방법으로 배포하고 테스트하자
- 시작은 서버 한대지만 나중에 여러대(수백대?!)로 확장되었을때를 대비하여 설계를 고민하자

## 왜 도커인가?

배포 프로세스를 고려하면서 가장 중요하게 생각한 개념이 [도커](http://www.docker.com/)입니다. 도커는 굉장히 빠르게 인기를 얻고 있는 기술이지만 생소하거나 잘 모르는 분들을 위해 간단하게 도커를 소개합니다.

**Container**

새로운(깨끗한) 서버에 서비스를 동작시키려면 굉장히 많은 작업이 필요합니다.

php로 만든 서비스를 동작시키려면 일단 php를 설치하고 관련 extention으로 php-mysql, php-curl, php-mcrypt, php-mbstring등등을 설치해야 합니다. nginx를 앞단에 두고 php를 연결하기 위해 php-fpm도 설치합니다.

자, 서버가 한대 더 추가되었습니다. 똑같이 셋팅할 수 있을까요?

물론입니다. 우리 서버 관리자는 굉장히 섬세하고 고오급 개발자여서 기존에 설치된 내용을 기억하고 정리해두었습니다.

이 서버에 다른 php 서비스를 올려봅니다. 엇, 그런데 이 서비스는 php7에서 돌지 않습니다. php7이 속도도 빠르고 기능도 짱짱맨이라 사용하고 있었는데 이번에 올릴 서비스는 php7에서 동작하지 않는 모듈이 포함되어 있습니다.

이렇게 되면 서버 관리자가 굉장히 똑똑하여 슬기롭게 두개를 잘 돌리던가, 아니면 서버가 점점 지저분해 진다던가, 아니면 포기하고 다른 서버에 서비스를 띄우게 됩니다.

그리고 3년후 서버 관리자가 퇴사하고 이 서버들은 레거시가 되고 가끔 오류가 발생하지만 아무도 왜 그런지 모르고 재부팅하면 운 좋게 동작하는 서버가 되버립니다.

php를 예로 들었지만, ruby on rails나 nodejs, java기반의 프로젝트도 비슷한 문제를 가지고 있습니다.

하지만, 도커라면?

![Docker Container]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/container-docker-blue-whale.jpg)

도커 컨테이너는 가상의 공간을 만들어서 호스트OS와는 전혀 별개의 환경에서 프로세스들이 동작하는 기술입니다.

도커는 가상의 공간을 이미지로 만들어 저장한 후 하나의 이미지에서 여러개의 컨테이너를 생성할 수 있는데, 이 말은 한번 이미지를 만들어 놓으면 마구 컨테이너를 띄울 수 있다는 의미입니다. 그것도 완전히 독립된 가상의 공간에서 실행이 됩니다. 관리자는 컨테이너가 어떻게 구성되어 있는지 신경쓸 필요가 없습니다. 그냥 이 컨테이너는 (예를들어)80포트가 열려 있으니 호스트의 80포트를 컨테이너의 80포트로 연결만 하면 바로 동작하게 됩니다.

도커 이미지를 만드는 방법은 Dockerfile이라는 파일로 관리하기 때문에 원한다면 이미지 생성 과정을 보거나 수정할 수 있습니다.

**vmware 가상머신같은건가?**

마치 가상머신 같지만 분명 가상머신과는 다릅니다.

- 호스트OS 위에 또다른 OS를 가상화 하는 것이 아니라 같은 OS에서 프로세스를 격리 시켜 마치 독립적으로 실행한 것 처럼 사용
- 단지, 독립된 공간을 만들어 프로세스를 실행하기 때문에 실행속도가 빠르고(띄우는데 1초) 일반적으로 cpu, memory, network 성능저하가 거어어의 없음(호스트 대비 99% 성능 나옴)
- 도커를 도와주는 생태계가 엄청남. 편리한 툴과 다양한 문서들이 많고 커뮤니티가 활발함
- 이미지파일을 git처럼 변경분만 저장하기 때문에 컨테이너를 여러개 띄워도 추가적인 용량은 거의 0M임. 실제로 이미지를 원격 저장소에 저장할 때도 push, pull같은 명령어를 이용함

**왜 인기있을까?**

도커가 나오기 전에 가장 인기 있었던 가상화 시스템은 Xen, KVM등이 있습니다. 이러한 기술들은 일부 고오급 개발자들만 사용이 가능했고 가상화에 따른 성능이슈도 존재했습니다.

도커는 프로세스 격리라는 개념을 적극 도입하여 성능 이슈를 줄이고, 일반 개발자들도 굉장히 사용하기 쉽게 개발하였습니다. 그리고 큰 용량의 이미지를 쉽게 다운받고 저장할 수 있게 [docker hub](https://hub.docker.com/)와 같은 서비스도 같이 오픈하였고 전세계적으로 커뮤니티 또한 적극적으로 지원하였습니다.(티셔츠랑 스티커!) 한국에서 온 처음만나는 개발자에게 회사의 [고오오오급 개발자](https://twitter.com/jpetazzo)가 직접 궁금증을 풀어주는 경우가 흔치는 않겠죠.

![Docker office에서 만난 Jérôme Petazzoni]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/docker-jpetazzo.jpg)

**단점**

단점이 있을테니 단점을 찾아봅시다.

- (사실상)리눅스에서만 사용함
- 리눅스 커널에 따라 이슈가 약간 있음(최신 커널을 못 쓰는 클라우드에서 문제가 있을수 있음)
- 도커 버전업할때 컨테이너가 쥬금 ㅠ (단순하게 만드는 unix철학이 아닌 도커데몬이 모든걸 관리하고 제어하기때문..)
- 포트 포워딩에 iptable을 사용하면서 생기는 보안상 제약사항이 있음

## 도커를 이용한 배포

도커를 이용한 배포가 갖는 특징입니다.

**확장성**

- 이미지만 만들어 놓으면 컨테이너는 그냥 띄우기만 하면됨
- 다른 서버로 서비스를 옮기거나 새로운 서버에 서비스를 하나 더 띄우는건 `docker run` 명령어 하나로 끝
- 개발서버 띄우기도 편하고 테스트서버 띄우기도 간편

**표준성**

- 도커를 사용하지 않는 경우 ruby, nodejs, go, php로 만든 서비스들의 배포 방식은 제각각 다름
- 컨테이너라는 표준으로 서버를 배포하므로 모든 서비스들의 배포과정이 동일해짐
- capistrano? fabric? ftp? 바이바이~

**이미지**

- 이미지에서 컨테이너를 생성하기 때문에 반드시 이미지를 만드는 과정이 필요
- 이미지를 저장할 곳이 필요
- 빌드 서버에서 이미지를 만들면 해당 이미지를 [distribution](https://github.com/docker/distribution)에 저장하고 운영서버에서 이미지를 불러옴

**설정**
  
- 설정은 보통 환경변수로 제어함
- `MYSQL_PASS=password`와 같이 컨테이너를 띄울때 환경변수를 같이 지정
- 하나의 이미지가 환경변수에 따라 동적으로 설정파일을 생성하도록 만들어져야함

**공유자원**

- 컨테이너는 삭제 후 새로 만들면 모든 데이터가 초기화됨
- 업로드 파일을 외부 스토리지와 링크하여 사용하거나 S3같은 별도의 저장소가 필요
- 세션이나 캐시를 파일로 사용하고 있다면 memcached나 redis와 같은 외부로 분리

**힙**

- 왠지 최신기술을 쓰는 느낌을 갖음
- 힙한 개발자가 된 느낌을 갖음

## 도커 이미지 만들기

이제 본격적으로 이미지를 만들어 봅니다.

![홈쇼핑처럼 도커 이미지]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/likehs-docker-image.png)

**likehs-nginx**

{% gist subicura/8d50a2337e1e3bb6bc43a10e005c5709 %}

- Base Image
  - [subicura/nginx](https://github.com/subicura/Dockerfiles/tree/master/nginx)
  - nginx 최신버전
  - ssl + http2 + stream + realip + ngx pagespeed와 같은 흔히 사용하는 모듈 컴파일
- nginx pagespeed 모듈을 활성화하기 위한 설정파일 추가
- php7-fpm 연동을 위한 설정파일 추가

**likehs-app**

{% gist subicura/0ebe5370d8e52dd2a48aa9df53f66b00 %}

- Base Image
  - [subicura/php7-fpm](https://github.com/subicura/Dockerfiles/blob/master/php7-fpm)
  - php7-fpm 최신버전
  - mysql, curl, mcrypt, mbstring등 php 익스텐션 설치
  - v8, xdebug 선택적 사용가능
- base 이미지에 소스파일과 php custom 설정파일을 추가함
- `start.sh` 파일은 환경변수에 따라 데이터베이스 정보등을 설정하고 php7-fpm 프로세스를 실행함


## 컨테이너 구성

이미지를 만들었으니 사실상 90% 작업은 완료되었습니다. 이제 생성된 이미지를 컨테이너로 실행만 하면 됩니다.

![홈쇼핑처럼 도커 컨테이너 구성]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/likehs-docker-container.png)

{% gist subicura/d888929d311a680e7d64a51b03e569ff %}

컨테이너를 실행할때 [docker compose](https://github.com/docker/compose)를 이용하면 힘들게 명령어를 기이일게 입력하지 않아도 되고 컨테이너간 의존성도 알아서 체크하여 순서대로 실행해줍니다.

**nginx container**

- `likehs-app`컨테이너에서 `/var/www/magento`디렉토리와 `/var/run/php`디렉토리가 볼륨으로 설정되어 있으므로 마치 내 컨테이너에 있는 디렉토리처럼 자동으로 마운트됨
- nginx 설정파일은 `unix:/var/run/php/php7.0-fpm.sock`여기를 바라보게 셋팅되어 있고 `/var/www/magento`디렉토리를 루트로 바라봄
- 컨테이너 내부의 `80포트`를 호스트의 `8080포트`로 연결함

**app container**

- 데이터베이스와 redis설정을 환경변수로 제어함
- 업로드 디렉토리를 호스트의 디렉토리로 연결하여 컨테이너를 새로 띄워도 파일을 유지할 수 있음

이제 운영서버에 접속한 후 `docker-compose up -d`를 실행하면 원격에서 이미지를 다운받고 서비스가 실행됩니다. 이제 배포를 위한 모든 준비가 끝났습니다.

## 웹서비스 배포하기

도커생태계에서 배포는 뜨거운 이슈입니다. 그만큼 다양한 방법이 존재하고 다양한 툴들이 있습니다. 배포 프로세스를 설계하면서 고려해봤던 툴들입니다.

- [coreos/fleet](https://coreos.com/)
  - coreos는 컨테이너를 호율적으로 실행하기 위해 굉장히 가볍게 설계된 리눅스 배포판임
  - 보안에 신경을써 기본적으로 OS가 자동으로 업데이트됨(자동 재부팅 ㄷㄷ)
  - 애초에 여러대의 서버에 어플리케이션이 동적으로 배포되는걸 가정하고 만들어짐. 하나가 죽어도 다른 서버에서 살아남!
  - [fleet](https://coreos.com/using-coreos/clustering/)은 systemd의 cluster버전으로 사용법이 쉽고 systemd의 장점을 그대로 가지고 있음
  - fleet을 운영하기 위해서는 [etcd](https://coreos.com/etcd/)가 필요하고 etcd는 최소 3대 이상의 서버가 필요함
  - [테스트](http://www.slideshare.net/subicura/launching-containers-with-fleet)만 해보고 소규모에는 적합하지 않다고 생각하여 패스
- [apache mesos](http://mesos.apache.org/)
  - UC Berkeley에서 연구를 시작하여 Twitter, Facebook, Apple, Airbnb등 여러곳에서 안정적으로 사용중
  - [zookeeper](https://zookeeper.apache.org/)를 백엔드로 사용. 이거 관리어떻게 하지...
  - 최근 도커 컨테이너를 적극 지원하고 있음
  - [테스트](http://www.slideshare.net/subicura/mesos-on-coreos)만 해보고 역시나 소규모에는 적합하지 않다고 생각하여 패스
- [kubernetes](http://kubernetes.io/)
  - 구글에서 개발하고 있는 컨테이너 배포, 확장, 운영 툴
  - fleet과 마찬가지로 etcd를 백엔드로 사용
  - 예전에 테스트 해봤을때 아직 프로덕션에 사용은 어려워 보였음
  - 역시나 소규모에는 적합하지 않음 ㅠ
- [docker swarm](https://docs.docker.com/swarm/)
  - docker에서 밀고 있는 컨테이너 배포 툴
  - 호스트 OS에 Agent만 설치하면 간단하게 작동하고 빠름
  - 소규모에 적합해보임

결론적으로, 배포와 관련된 테스트와 스터디는 추후 대규모로 서버가 확장되었을때 사용하는 것으로..하고(언젠가 쓸모있겠지 ㅠ) 시작은 가볍게 갑니다.

**Docker 원격 API**

도커는 기본적으로 원격 API를 호출하기 쉬운 구조입니다. 도커 명령어를 실행할때 의식하고 있지는 않지만 자동으로 `unix:///var/run/docker.sock` 여기를 바라보고 명령을 하고 있습니다. 도커 데몬을 실행할때 `-H tcp://0.0.0.0:2375` 옵션을 주게 되면 원격에서 명령을 보낼 준비가 완료됩니다.

> 쉽다는건 보안적으로 엄청난 구멍일 수 있다는 뜻입니다. 방화벽 정책은 필수!

- 도커 원격명령 실행
  - DOCKER_HOST 환경변수를 셋팅합니다.
  - `DOCKER_HOST=tcp://192.168.0.100:2375 docker run`
- Docker Compose 원격명령 실행
  - DOCKER_HOST 환경변수를 셋팅합니다.
  - `DOCKER_HOST=tcp://192.168.0.100:2375 docker-compose up -d`

**원격 API를 이용한 배포**

원격으로 도커 명령어를 실행하는 방법을 이용해 간단하게 스크립트를 만듭니다.

{% gist subicura/f39d180842b2f3bd6323bb467dec75cb %}

기존에 실행중인 컨테이너를 멈추고(down) 최신버전을 내려 받고(pull) 실행하면(up) 끝입니다.

## Blue-Green 배포

도커 이미지를 만들고 컨테이너를 배포하는데 성공했지만 배포할때마다 서비스가 잠시 중단(down하고 up하는 사이)되는 치명적인 단점이 있습니다. 이부분을 [blue-green 배포 방식](http://martinfowler.com/bliki/BlueGreenDeployment.html)을 이용하여 무중단으로 배포해봅니다.

**nginx load balance 기능 이용하기**

![nginx]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/nginx-load-balance.png)

nginx는 무료면서 훌륭한 성능을 자랑하는 로드밸런서입니다. `80포트`로 들어온 요청을 `8080포트`, `8081포트`로 분산할 수 있고 health check를 통해 포트가 죽어있다면 살아있는 포트로 요청을 보내게 됩니다.

보통은 서로다른 IP의 서버를 로드밸런스 하기 위해 사용하지만 한 IP에서 서로 다른 포트를 지정하는 것도 가능합니다. 도커를 사용하지 않는다면 같은 서비스를 하나의 서버에 여러개 띄운다는 걸 상상하기 어렵지만 도커이기 때문에 쉽게 적용할 수 있습니다.

{% gist subicura/fff289e766a73b0dfb498eadc0d2f9ec %}

작은 규모에 맞는 아주 적절한 스크립트를 만들었습니다. 포트를 다르게 설정한 compose 파일을 2개 만들고 어떤 compose가 떠있는지 확인합니다. 실행중이 아닌 compose를 실행하여 컨테이너를 띄운 후 다른 컨테이너를 멈춥니다.

어떤 디펜던시도 필요 없고 어떤 에이전트도 없지만 확실하게 동작하는 스크립트 입니다.

## Service Discovery

nginx를 이용해 2개의 포트를 바라보고 둘중에 동작하는 포트에 요청을 보내는 방법은 몇가지 단점이 있습니다.

- 서버를 추가하거나 변경할 경우 설정파일을 수정하고 재시작하는 과정이 필요
- 프록시 대상 IP와 PORT가 항상 고정이여야 한다는 점
- 죽어 있는 포트가 살아 있는지 계속해서 체크하면서 생기는 (작지만 문제 있어보이는) 오버헤드

이런 문제를 해결하기 위해 Service Discovery라는 개념이 있습니다. 서버들의 정보(IP, Port등등)를 포함한 다양한 정보를 저장하고 가져오고 값의 변화가 일어날때 이벤트를 받아 자동으로 서비스의 설정 정보를 수정하고 재시작하는 개념입니다.

![service discovery]({{ site.url }}/assets/article_images/2016-06-07-zero-downtime-docker-deployment/service-discovery.png)

1. 새로운 서버가 추가되면 서버 정보를 `key/value store`에 추가함
2. `key/value store`는 directory 형태로 값을 저장함. /services/web 하위를 읽으면 전체 web 서버 정보를 읽을 수 있음
3. `key/value store`를 watch하고 있던 `configuration manager`가 값이 추가되었다는 이벤트를 받음
4. 이벤트를 받으면 템플릿 파일을 기반으로 새로운 설정파일을 생성
5. 새로운 설정파일을 만들어 기존파일을 대체하고 서비스를 재시작함

이러한 개념을 구현한 다양한 서비스와 툴이 존재하고 각기 다른 특징을 갖습니다. 여러가지 서비스에 대해선 다음기회에.. 알아보고 여기서는 `docker-gen`에 대해서 알아봅니다.

**docker-gen**

[docker-gen](https://github.com/jwilder/docker-gen)은 docker의 기본 기능을 적극 활용한 service discovery 툴입니다. docker외에 디펜던시는 없기 때문에 구성이 간단하고 편리하지만 하나의 서버에 속한 컨테이너끼리만 동작한다는 단점이 있습니다. 홈쇼핑처럼은 아직 작은 서비스이기 때문에 적합하다고 할 수 있습니다.

- key/value store
  - 도커 데몬이 가지고 있는 컨테이너의 정보를 그대로 이용
  - 컨테이너를 실행할때 입력한 환경변수를 읽음
  - `VIRTUAL_HOST=www.likehs.com`과 같이 환경변수를 지정하면 이를 보고 nginx의 virtual host 설정파일들을 구성함
- configuration manager
  - 도커 데몬은 컨테이너의 생성/삭제에 대한 이벤트를 발생시킴
  - docker-gen이 해당 이벤트를 받아서 처리함
  - template은 go의 [text/template language](https://golang.org/pkg/text/template/)을 그대로 사용하여 매우 자유롭게 구성가능
  - 조건식/반복문등을 이용하여 template 파일 구성
  - template 파일을 가지고 설정파일을 만든 후 원하는 명령어를 수행
  - 명령어는 보통 서비스 재시작 (`nginx -s reload`)

**적용**

홈쇼핑처럼의 웹서비스는 컨테이너 앞단에 nginx를 두고 docker-gen을 이용하여 nginx의 설정파일을 변경하고 프로세스를 재시작하고 있습니다.

`blue 컨테이너 실행` > `docker-gen 이벤트 수신` > `nginx 설정파일에 blue container 정보 추가` > `nginx 재시작`

이어서,

`green 컨테이너 중지` > `docker-gen 이벤트 수신` > `nginx 설정파일에 green container 정보 제거` > `nginx 재시작`

## 자동화

이제 무중단 배포까지 완료되었으니 배포를 자동화합니다.

**git branch**

현재 소스는 총 3가지 타입의 브랜치로 관리하고 있습니다.

- 기능별 브랜치
  - `send-sms-after-order`와 같이 기능별로 브랜치를 만듬
  - master 브랜치로 머지 후 제거됨
- master
  - 메인 개발소스
  - 바로 push할 수 없음
  - 작업별 브랜치를 pull request 보내고 코드 리뷰 후 머지함
  - master 브랜치는 바로 스테이징서버로 배포
- production
  - 운영서버에서 사용중인 브랜치
  - master 브랜치가 스테이징서버로 배포되고 테스트가 끝나면 수동으로 master 브랜치를 production 브랜치로 머지
  - production 브랜치가 푸시되면 바로 운영서버로 배포

**gitlab webhook**

gitlab에는 푸시가 될때마다 이벤트를 보낼 수 있는 [webhook](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/web_hooks/web_hooks.md)기능이 있고 jenkins는 webhook이 호출되면 자동으로 빌드를 시작하는 [plugin](https://wiki.jenkins-ci.org/display/JENKINS/Gitlab+Hook+Plugin)이 존재합니다. gitlab은 모든 푸시 이벤트마다 jenkins를 호출하게 되고 jenkins는 branch를 보고 master일 경우는 staging 배포, production일 경우는 운영서버에 배포하게 됩니다.

**jenkins**

jenkins에 [slack플러그인](https://wiki.jenkins-ci.org/display/JENKINS/Slack+Plugin)을 설치하면 시작, 배포 후 성공/실패 여부를 슬랙 메시지로 받을 수 있습니다.

jenkins는 `테스트` > `이미지 빌드` > `배포` 과정을 수행합니다.

## 롤백

배포된 이미지에 문제가 심각할 경우 이전 이미지로 되돌릴 수 있어야 합니다. 도커를 이용하면 이미지에 태그를 걸 수 있어, 손쉽게 구현할 수 있습니다.

{% gist subicura/bd3b275d5330b9eef983ce4e626b6edd %}

jenkins에서 이미지를 빌드할때 현재 `git commit hash`로 태그로 만듭니다. 그리고 해당 이미지를 다시 배포하려면 해당 git commit hash를 latest로 태그한 후 다시 배포하면 됩니다.

## 그래서

도커를 이용한 배포에 대해 전반적인 내용을 살펴보았습니다. 어쩌다보니 도커에 대한 내용이 더 많아진 느낌입니다. 이미 도커를 알고 계신분은 심심한 포스트일지도.. 하지만, 도커를 몰랐던 분들은 꼭 써보세요. 좋습니다! 도커에 대한 내용은 [여기](http://documents.docker.co.kr/)에서 더 많이 볼 수 있습니다.

배포는 다양한 기술이 존재하고 서버 규모나 개발팀의 규모에 따라 여러가지 방법이 있으니 자신의 팀에 딱 맞는 방법을 찾아 적용하는 것이 중요한 것 같습니다. 더 쉽거나 나은 방법 있으면 추천해주세요.

지난번 떡볶이에 이어 **고기덮밥** 메뉴도 추가되었으니 서비스에 관심있으신분은 [https://www.likehs.com/](https://www.likehs.com/) 에 방문해 주시구요.

개발자 상시 모집중입니다. 연락주세요 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))


