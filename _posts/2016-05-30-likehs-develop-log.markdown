---
published: true
title: 홈쇼핑처럼 개발후기
layout: post
comments: yes
---
![서울스낵x불맛쌀떡볶이]({{ site.url }}/assets/article_images/2016-05-30-likehs-develop-log/dduk.png)

홈쇼핑처럼x불맛쌀떡볶이를 배송받으면서 그동안 "[홈쇼핑처럼](https://www.likehs.com/)"을 개발했던 내용이 떠올라 후기로 정리합니다.

그동안 주로 SI관련일을 하다가 이번에 처음으로 일반 고객을 대상으로 서비스를 만들게 되었습니다. 처음부터 끝까지 만들어야 하다보니 정말 일이 많고 힘드네요. 모든 대한민국의 스타트업에게 존경을...

밑에 내용은 서비스를 만들면서 기술적으로 고민했던 것과 어떤 기술들을 사용했는지를 중점으로 정리해 보았습니다. "아, 이 스타트업은 이렇게 일을 하고 이런식으로 서비스를 개발했구나" 하고 봐주시면 감사할 것 같습니다. 더 나은 대안이 있다면 추천해주셔도 좋습니다.

## 어떤걸 만들까?

대략적인 서비스 개요입니다

**맛집음식을 집에서 간편하게 먹자**

- 입소문이 난 맛집과 협력하여 처음부터 함께 간편식을 개발하자
- 개발부터 패키징, 냉장보관, 배송까지 관리하여 빠르고 편리하게 제품을 전달하자

**BJ가 실시간 동영상을 통해 제품을 알리자**

- BJ를 섭외하고 일주일에 한번씩 실시간으로 제품을 홍보하고 소통하자
- 그외에 맛집정보와 조리법등을 영상으로 편집하여 볼 수 있게 하자

**채팅을 넣자**

- 실시간 채팅이 가장 편한 커뮤니케이션 도구다
- 질문/답변 및 제품에 대한 이야기를 게시판이나 댓글이 아닌 채팅으로 얘기하자

**단순하게 만들자**

- 제품을 보고 구매하고 확인 하는 단순한 과정에 집중하자
- 구매자가 최대한 편하고 짧은 시간에 구매할 수 있도록 하자

## 어떻게 개발해야 할까?

기술 스택 소개입니다

**APP**

- 안드로이드와 아이폰 - 한국은 안드로이드 사용자가 압도적이지만 아이폰 사용자를 포기할 수 없음. 우리 회사도 한명 빼곤 전부 아이폰이라.. 같이 런칭하기로 결정
- 안드로이드는 Android Studio에 Java를 이용하고 아이폰은 Xcode에 swift를 이용
- [RxAndroid](http://reactivex.io/)
    - 뭔가 좋아보이니 도입
    - timeout, loading 상황이라던가 채팅 메시지를 받는 부분에 적용 => 생각보다 쓰기가 어려웠음
    - 뭐하나 할때마다 문서를 찾아봐야하고 이렇게 쓰는게 맞나 싶은 상황이 많음
    - 좋은 샘플이 많이 나오고 베스트 프렉티스라던가 문서들이 더 성숙해져야 할 것 같음
    - 조금 더 지나면 좋아질 것 같은데 아직 좀 이른느낌
- [swift](https://developer.apple.com/swift/)
    - 플러그인들 개발이 많이 되어서 몇년 전에 비해 실제 제품을 개발하는데 무리가 없어짐
    - Objective-C 안녕
- [xamarin](https://www.xamarin.com/), [react native](https://facebook.github.io/react-native/), [ionic](http://ionicframework.com/), [rubymotion](http://www.rubymotion.com/)
	- 한번 소스 작성으로 아이폰과 안드로이드 앱을 가능하게 하는 녀석들
	- 비지니스용 앱에는 적합해 보이나 고객용 앱으로는 적용이 어렵다고 판단
    - 개발자들이 기본 언어에 기본 SDK 선호
    - 고려해봤지만 결국 안쓰는것으로

**WEB / Backend**
    
- 제품관리부터 배송, 환불, 재고, 이벤트, 쿠폰등 일련의 커머스 시스템을 전부 만들수는 없으니 유명한 프레임워크를 찾아보고 커스터마이징 하기로함
- 오픈 소스 커머스 후보
    - .net 기반의 [nopCommerce](http://www.nopcommerce.com/)
        - 좋은 설계
        - 개발환경이 좀 느림
        - 윈도우 visual studio 필수 => 다들 mac을 사용해서 가상환경에서 해야함
    - rails기반의 [spree](https://spreecommerce.com/)
        - 가벼움
        - 커스터마이징 방식이 맘에 들지 않음
        - 생각보다 기능이 부실함
        - 유/무료 플러그인이 적음
    - php기반의 [magento](https://magento.com/)
        - php지만 자체 프레임웍을 잘 구성해 놓음 => 프레임웍 꽤 공부해야함
        - (프레임웍을 잘 이해하고 있다면) 기존 기능 확장과 커스터마이징이 쉬움
        - 유/무료 플러그인 많음 => 맘에 쏙드는 플러그인은 없고 결국 커스터마이징 해야함
        - ebay에서 인수하고 세계적으로 널리 쓰임
        - 최종 선택
- magento
    - 한국 페이먼트 솔루션이 잘 안되어 있어서 이니시스를 사용했는데 결제, 환불, 부분환불을 전부 구현해야했음. (플러그인으로 오픈하면 좀 팔릴까?)
    - [xdebug](https://xdebug.org/), [code sniffer](https://github.com/squizlabs/PHP_CodeSniffer), [phpunit](https://phpunit.de/)을 이용해서 잘 케어해줘야 오류가 안나고 신중하게 코드를 관리해야 유지보수가 수월함
    - 개발환경 셋팅하는데 애먹음
        - magento는 왜 [gem](https://rubygems.org/)이나 [npm](https://www.npmjs.com/)같은 방식으로 제공하지 않는가?
        - [rails](http://rubyonrails.org/)나 [express](http://expressjs.com/)같은 경우는 core소스가 개발소스와 완전히 분리되어 개발 가능한데 마젠토는 전체 소스를 가지고 있어야 했음
        - 결국 코어랑 커스터마이징을 분리하기는 했는데 맞는 방법인지 모르겠음

**Web / Frontend**

- [gulp](http://gulpjs.com/)+[webpack](https://webpack.github.io/)+[babel](http://babeljs.io/)+[react](http://facebook.github.io/react/)+[redux](https://github.com/reactjs/redux)+[jquery](https://jquery.com/)
- [PHP v8js](https://github.com/phpv8/v8js)를 설치하여 [react 서버 사이드 렌더링](http://blog.remotty.com/blog/2015/08/30/react-server-rendering-on-rails/) 사용
- redux 생각보다 공부하기 어려웠음
- [SCSS](http://sass-lang.com/) / [bootstrap 3](http://getbootstrap.com/)
    - bootstrap은 style중 base와 일부분만 사용
    - javascript plugin은 제외함
- 앱 기반이라 웹은 아직 많이 사용하지 않는데.. 구성이 과해졌음;;
- 나중에 웹 개발 들어가면 감사하겠지

**개발환경**

- [vagrant](https://www.vagrantup.com/)와 [docker](https://www.docker.com/)를 이용하여 구성
- vagrant안에 nginx, php7, mysql, redis docker container를 띄워서 개발
- 배포도 도커를 사용하기때문에 배포환경이랑 99% 일치하는 장점
- 매번 힘들게 개발환경 구성할 필요 없음 `vagrant up`하고 커피한잔 마시면 됨
- 빨리 [docker for mac](https://blog.docker.com/2016/03/docker-for-mac-windows-beta/)이 안정화되길 기다리는중
    - docker때문에 리눅스를 개발환경으로 써볼까 까지도 생각했지만 IDE와 한글궁합, 폰트 구성이 너무 힘듬 ㅠㅠ

**채팅**

- [여러가지 솔루션](https://www.google.co.kr/?#newwindow=1&q=chat+sdk) 검토 후 최종결정은 자체 개발
    - 주문 상황을 채팅창에 공유하거나, 바로 구매하기 링크 버튼등 채팅창에 넣을 요소를 고려
    - 커스터마이징이 필요한데 기존 솔류션들은 자유도가 떨어져 보였음
    - 만드는김에 별개의 서비스로 개발하고 홈쇼핑처럼이 해당 서비스를 사용하는 방식으로 구현 => 여유 생기면 채팅 솔루션 개발업체로 변신
    - 덕분에 프로젝트가 하나 더 생긴 느낌
- 채팅같은 개발은 처음이라 안전성보다는 좋아보이는 최신 기술스택을 대거 채용함
- 기본적인 관리자 페이지와 API
    - rails / react+redux조합
- 채팅 스트림 소켓 접속
    - [Vert.x](http://vertx.io/)
    - Java기반에 netty사용으로 믿음직함
    - stream과 확장성에 최적화됨
    - TCP/websocket등을 쉽게 처리해줘서 코어만 단순하고 심플하게 개발할 수 있음
    - 자잘한 버그가 있음 ㅠ 3.3이 빨리 나오길 기다리는 중
- 메시지 파싱 및 큐, 디비 전송
    - [go](https://golang.org/)로 구현한 워커
    - 큐에서 메시지를 받고 검증 후 채팅창에 돌려주고 디비에 저장함
    - 처음 go를 써봤는데 굉장히 만족스러움
    - 개발속도도 빠르고 버그도 많이 없고 속도 빠른 ruby 쓰는 느낌
- 디비
    - [mysql](https://www.mysql.com/)
    - [mongo](https://www.mongodb.com/)나 nosql류를 쓰면 좋을것 같긴한데 익숙하지 않아 관리할 자신이 없어서 포기
- 큐
    - [kafka](http://kafka.apache.org/)
    - [rabbitmq](https://www.rabbitmq.com/)를 썼다가 퍼포먼스 이슈가 발생해서 옮김
    - kafka는 [linkedin](https://linkedin.com/)에서 만들었고 메모리 방식이 아닌 하드 저장 방식임 => 메모리가 아니다! 메시지 유실걱정이 없음!
    - 하드를 백엔드로 하지만 캐시와 random access를 제한하여 굉장히 빠름
    - 기능은 굉장히 부실하지만 속도가 극강임
    - 버전별 호환성이 너무 안좋아서 특정 라이브러리에 같은 버전을 지원하도록 잘 써야함
        - java, ruby, go 라이브러리가 찰싹 붙어야하는 상황
    - 빨리 버전 안정화 되길


**실시간 동영상**

- 실시간으로 영상을 전송하는게 우리 서비스의 핵심
- [wowza](https://www.wowza.com/)
    - 적극 고려했으나 그냥 이쁜 UI에 유료로 [ffmpeg](https://www.ffmpeg.org/) 쓰는 느낌
    - 결국 테스트할때만 사용하고 ffmpeg 사용함
- [RTMP](https://en.wikipedia.org/wiki/Real_Time_Messaging_Protocol)/[RTSP](https://en.wikipedia.org/wiki/Real_Time_Streaming_Protocol)/[HLS](https://developer.apple.com/streaming/) 프로토콜만 지원하면  대부분 문제 해결됨
- 오리진 서버와 엣지 서버를 어떻게 구성하는지가 중요
- 트래픽이 어마어마하여 속도와 비용을 고려하여 클라우드 선택. 아직도 여러 클라우드 테스트중
    - 트래픽을 무제한으로 주는 어떤 클라우드의 경우 속도도 빨라서 최종결정했었으나 방송직전 속도가 떨어짐 => 트래픽이 많다는 이유로 강제로 제한당함
- [유튜브](https://www.youtube.com/)와 [페이스북 라이브](https://live.fb.com/), [비메오](https://vimeo.com/) 사용중
- 비메오 유료계정은 광고 없이 자체 플레이어를 쓸수 있고 트래픽이 무제한임

**배송조회**
    
- [CJ대한통운](https://www.doortodoor.co.kr/main/) 이용
    - api을 제공하지 않음
    - [sweettracker](http://sweettracker.github.io/)와 [aftership](https://www.aftership.com/)은 유료
- 오픈소스
    - go로 그냥 만듬
    - 다른 택배사도 지원가능한 구조
    - 곧, 오픈소스 공개할 예정

**우편번호검색**

- [daum API](http://postcode.map.daum.net/guide)가 최고
    - 키 발급도 없고 무제한 트래픽에 속도도 빠름!
    - 하지만, 웹만 제공하고 커스터마이징이 어려운 단점
- [postcodify](https://postcodify.poesis.kr/)
    - php기반의 오픈소스 프로젝트
    - 구주소, 신주소 동시 검색 지원
    - 상세한 결과 API
    - 굉장히 유연한 검색을 지원
    - 대신 좀 느림 ㅠ 맴캐시 걸어도 새로운 주소는 느림 ㅠ

**API Gateway**

![API Gateway란?]({{ site.url }}/assets/article_images/2016-05-30-likehs-develop-log/api-gateway.png)

- 배송조회 및 우편번호검색에서 사용
- 배송조회와 우편번호검색이 따로 인증 기능이 없기 때문에 앞단에 gateway를 둠
- 위 사진처럼, 호출개수 제한, 키등록, 캐싱, 로깅, 분석등을 해줌
- tyk
    - [kong](https://getkong.org/)을 고려해봤으나 gui가 유료임
	- [tyk](https://tyk.io/)는 go 기반의 gateway로 전직 구글러들이 만듬
    - 서버 한대까지 무료고 GUI도 제공
	- 설치가 간단하고 사용법도 쉬움
	- tyk에 api를 호출하면 tyk가 다시 원래 api를 호출하는 방식임

**푸시**

- [pushbot](https://pushbots.com/)
    - 다른 솔루션들은 기기등록 제한이 있는 경우가 많은데, pushbot은 기기등록 수 제한없음
    - 무료 발송 건수가 엄청나게 많음
    - 푸시는 광고성 푸시가 대부분일거라 생각해 대량의 기기에 소량의 건수라 우리한테 딱임
    - 문서가 조금 부실함 => 안드로이드 상태바 아이콘 바꾸는 법 문서에 없는데 기능은 있음;

**메일**

- [mailgun](https://www.mailgun.com/)
    - 발송용으로 사용
    - 비슷한 서비스들 사이에 딱히 장점/단점은 모르겠음
- [네이버웍스](https://www.worksmobile.com/kr/)
    - 메일 수신/발송용으로 사용
    - 구글웍스가 유료화되어 아쉬움 ㅠ
- 템플릿
    - 데스크탑, 모바일, 앱에서 이메일이 깨지지 않는지 확인함
	- [litmus](https://litmus.com/) => 최대 테스트 개수가 제한되어 있긴 한데 쓸만함
	- [Grunt Email Design Workflow](https://github.com/leemunroe/grunt-email-workflow)
        - 이메일은 css class를 지원하지 않아 전부 inline으로 넣어야함 그런걸 자동으로 해줌
        - class 지원과 scss지원, 미리보기등을 지원함
        - express 기반이라 변수설정등도 가능함

**SMS**

- [olleh API Store](http://www.apistore.co.kr/api/apiView.do?service_seq=151)
    - 타사 대비 저렴함
        - SMS 9.9원 / LMS 28원 / MMS 110원
    - REST API 사용 간단함
    - 서비스 신청시 계약서를 등기로 보내야하는 번거로움. 원래 다 이런식으로 계약하는건가?

**CS**

- [카카오톡 옐로우아이디](https://yellowid.kakao.com/)
    - 상담은 채팅으로 유도
    - 한 아이디에 여려명 관리자 등록 가능하고 데스크탑에서도 잘 동작함
- SK 브로드밴드 1670-xxxx
    - 02번호 대신 대표 번호로 사용

**이슈관리/코드검수**

- [phabricator](http://phabricator.org/)
    - facebook의 오픈소스 코드리뷰, 테스크 관리, 프로젝트 관리툴
    - 기능은 짱짱 많고 좋은듯 하지만 세부적으로 꼭 필요한 몇몇 기능은 부족한 느낌임
    - 일반 이슈 관리시스템 대비 기능이 부족하여 무조건 추천하지는 못하겠음
    - 기능이 부족한 부분은 phabricator 방식에 맞춰야함
- [gitlab](https://gitlab.com/)
    - gitlab에 [github flow](https://guides.github.com/introduction/flow/) 방식을 사용
        - [git flow](http://danielkummer.github.io/git-flow-cheatsheet/index.ko_KR.html)와는 다르고 [gerrit](https://code.google.com/p/gerrit/)과는 다르다!
        - gitlab이 master push를 제한할수 있기때문에 쉽게 적용가능
    - 기능단위로 브랜치를 따고 pull request를 보내면 팀장이 코드 검수 후 auto merge
    - 팀장이 부지런해야 빨리빨리 동작
    - 안드로이드, 아이폰은 개발자가 각각 한명이라 코드 검수 없이 진행함 / 간혹 특이하거나 괜찮은 부분은 따로 공유

**서버**
    
- 회사자체서버
    - IBM System x3650 M4
        - Intel(R) Xeon(R) CPU E5-2640 0 @ 2.50GHz * 2 / Memory - 96G
        - 각종 내부 툴들과 gitlab, 모니터링등이 돌고 있음
        - 채팅 서비스도 여기서 도는중
- [KT 클라우드](https://ucloudbiz.olleh.com/)
    - 클라우드는 아마존은 생각보다 너무 비쌌고 KT가 저렴하고 속도도 빨랐음
    - 커머스와 영상은 KT 클라우드에서 운영중
- [chef](https://www.chef.io/chef/)
    - ruby에 익숙하고 웹 GUI를 무료로 제공하여 선택했고 [puppet](https://puppet.com/)이나 [saltstack](https://saltstack.com/), [ansible](https://www.ansible.com/)같은 다른 툴들도 기능은 비슷비슷한듯함
    - 기본적인 방화벽 설정과 도커, sensu monitoring client를 설치하는게 주된 용도
    - 방화벽은 [ufw](https://help.ubuntu.com/community/UFW)사용중. iptables 너무 어렵 ㅠ
- Docker
    - web application
    - nginx
    - mysql
    - sensu
    - ... 모든건 컨테이너로.. 짱짱맨

**웹서버**
    
- [nginx](http://nginx.org/)
    - http/tcp/websocket reverse proxy용도
    - [nginx pagespeed module](https://developers.google.com/speed/pagespeed/module/) 적용하여 정적 파일 최적화
        - 단순히 `pagespeed on;`만 해주면 이미지를 알아서 압축해서 내려보내줌
        - chrome은 webp로 jpeg보다 더 좋은 압축률에 좋은화질임
        - 그외에 최적화에 대한 많은 기능들 포함
- [cloudflare](https://www.cloudflare.com/)
    - 앞단에 적용하여 cdn과 방화벽 용도로 사용
    - 단점을 모르겠음
    - dns server 설정도 엄청나게 편하고 cdn cache도 엄청나게 간단함
    - 땅파서 장사하는건지.. 그래서 유료 플랜 가입함

**모니터링**

- [sensu](https://sensuapp.org/)
    - 한곳에서 서버상황과 자원을 모니터링함
    - 슬랙 플러그인을 사용하여 서버가 죽거나 자원을 많이 사용하면 경고메시지 날라옴
    - 확장성이 좋고 [플러그인](https://github.com/sensu-plugins)이 다양하고 ruby기반에 수정하기도 편함. 게다가 구조도 간단해서 선택함
    - rabbitmq 통신을 암호화하고 방화벽을 적용하면 설정 끝
- [grafana](http://grafana.org/)
    - sensu가 influxdb에 서버 모니터링 정보를 저장
    - 데이터를 그래프로 보여주고 있음. 한눈에 보기 좋고 다양한 커스터마이징이 가능함
- 전통의 강호 [구글 애널리틱스](https://analytics.google.com/) 적용

**배포**

- [gitlab](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/web_hooks/web_hooks.md)+[jenkins](https://jenkins.io/)
    - gitlab에 push하면 webhook을 통해 jenkins 자동 배포
    - 빌드 / 테스트 / 도커라이징 / 배포
- [docker compose](https://docs.docker.com/compose/)
    - 서버쪽은 전부 도커! docker compose를 적극 활용함 도커 만세
- [blue green deployment](http://martinfowler.com/bliki/BlueGreenDeployment.html) 방식사용
    - 한서버에 8090, 8091 포트를 사용중
    - 8090이 떠있을때 배포를 하면 8091로 배포를 하고 nginx가 8091을 바라보게 한 후 8090을 죽임 => 8090, 8091 왔다갔다 하는 방식임
    - 덕분에, 하루에도 수십번 이상없이 배포중
- [fabric](https://fabric.io/home)
    - 아이폰/안드로이드 앱 테스트 배포
    - 사용법이 쉽고 오류로깅도 해줌
- [서울앱비지니스센터](http://seoulappcenter.co.kr/)
    - 다양한 안드로이드 및 iOS 기기를 빌려줌
    - 이전한지 얼마 안되서 정식 오픈은 안했고 무료에 쾌적함

**디자인**

- [sketch](https://www.sketchapp.com/)
    - 디자인은 이제 거의다 sketch로 하고 포토샵은 일부만 사용함
- [zeplin](https://zeplin.io/)
    - sketch와 찰떡 궁합인 zaplin을 사용하여 웹/앱 디자인 공유

## 커뮤니케이션은 어떻게?

개발자와 기획자 / 디자이너

**[slack](https://slack.com/)**

- 요즘 대부분 사용하고 있는 슬랙
- 주제별로 채널을 만들어서 사용중
    - app, web, marketing, cs, video, ci, bug, bot 등으로 구성

**[airtable](https://airtable.com/)**

- 웹/앱 기반 스프리드시트 서비스
- 자유도가 높고 간단한 내용은 데이터베이스를 대체하여 사용할 수 있음
- 자료성 정보 공유는 여기서 이루어짐

## 그래서

이번 프로젝트에서 기획/디자인/영업을 제외한 순수 개발파트는 4명이 풀로 투입되고 2명이 다른 일과 병행하면서 진행하였습니다. 다들 기술적인 부분을 좋아하다보니 여러가지 기술이 사용되면서 단순할 수 있는 부분도 복잡해진 느낌이 있습니다.

결국 집에서 **떡볶이 하나**를 먹기 위해 생각보다 많은 작업을 한것 같습니다. 개발과 관련된 내용만 정리했지만 BJ를 섭외하고 영상을 촬영하고 편집하고 상품을 기획하고 영업하고 만들고 배송하고 CS를 운영하고 마케팅을 하는 부분도 엄청난 노력이 필요했습니다.

서비스에 관심있으신분은 [https://www.likehs.com/](https://www.likehs.com) 에 방문해 주시구요. (현재 서울스낵x불맛쌀떡볶이 **무료 구매 이벤트**중!)

아참, 개발자도 모집합니다. 연락주세요 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))

홈쇼핑처럼팀 다들 수고하셨어요. 모두 화이팅! 앱도 화이팅 ㅋㅋ