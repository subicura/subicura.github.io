---
published: true
title: Go언어로 오픈소스 배송조회 서비스 만들기
excerpt: 홈쇼핑처럼에서 세번째로 런칭한 돈까스를 구매해 주시는 분들을 보면서 *아.. 받은 만큼 나도 뭔가 베풀어야겠구나* 라는 생각에 배송조회 서비스를 오픈소스로 공개하는 과정을 정리해봅니다. github이라는 소셜코딩 플랫폼이 등장하면서 오픈소스에 참여할 수 있는 장벽이 많이 낮아졌습니다. 사용하던 오픈소스에서 버그를 발견하면 이슈를 살펴보고 수정한 소스를 슬쩍 풀 리퀘스트 하면 됩니다. 내가 작성한 소스가 커미터 마음에 들면 머지가 될 것이고 그렇게 우리는 오픈소스 컨트리뷰터가 되고 인류에 조금이라도 공헌한 사람이 됩니다.
layout: post
comments: yes
---
![돈까스먹는용만이x칠리등심돈까스]({{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/yongman-pork.jpg)

[홈쇼핑처럼](https://www.likehs.com)에서 세번째로 런칭한 [돈까스](https://www.likehs.com/tvprogram/index/view/id/24/)를 구매해 주시는 분들을 보면서 *아.. 받은 만큼 나도 뭔가 베풀어야겠구나* 라는 생각에 배송조회 서비스를 오픈소스로 공개하는 과정을 정리해봅니다.

[github](https://github.com/)이라는 소셜코딩 플랫폼이 등장하면서 오픈소스에 참여할 수 있는 장벽이 많이 낮아졌습니다. 사용하던 오픈소스에서 버그를 발견하면 이슈를 살펴보고 수정한 소스를 슬쩍 풀 리퀘스트 하면 됩니다. 내가 작성한 소스가 커미터 마음에 들면 머지가 될 것이고 그렇게 우리는 오픈소스 컨트리뷰터가 되고 인류에 조금이라도 공헌한 사람이 됩니다.

이러한 활동은 실력도 늘고 이력도 쌓고 재미도 느낄수 있습니다.

이제 컨트리뷰터는 해봤으니 커미터가 되어봅시다. 아쉽게도 인기있는 오픈소스의 커미터는 꽤 많은 노력이 필요하고 고오급 개발자만 가능한 것 같습니다.
그럼 오픈소스 프로젝트를 직접 운영해보는건 어떨까요? 직접 오픈소스 프로젝트를 운영하면 커미터가 될 수 있고 리뷰어도 될 수 있고 프로젝트를 운영하면서 많은 노하우를 배울수도 있습니다. 아참, 오픈소스에 참여하면 IntelliJ IDE도 [무료](https://www.jetbrains.com/buy/opensource/)로 사용할 수 있고 JIRA도 [무료](https://ko.atlassian.com/software/views/open-source-license-request)로 쓸 수 있습니다.

## 어떤걸 만들까?

커머스에서 상품이 배송되면 배송상태를 추적해야합니다. 배송이 완료되면 구매확정 버튼을 누르게 할수도 있고, 배송정보 화면을 커스터마이징 할 수도 있습니다. 많은 배송업체가 API를 제공하지 않기 때문에 자동화하기가 까다롭습니다.(대체 다른 서비스들은 어떻게 추적하는거지...?) 그래서 결국 HTML을 파싱하는 방법을 선택합니다. 택배사와 송장번호를 입력하면 택배 사이트에 접속하여 HTML을 읽고 DOM을 파싱하여 정리된 포멧으로 택배정보를 조회하는 서비스를 만듭니다

혹시 누가 만들어 놓지 않았을까 검색을 해보니 무료에 오픈소스로 공개된 건 없는것 같습니다. 질문글도 많고 원하는 사람도 있는거 같으니 오픈소스로 하기 딱인 프로젝트인것 같습니다. 아무도 안쓰는 기능을 만들면 힘들게 오픈해도 반응이 없어서 슬픔 ㅠ

## 왜 서비스를 따로 분리하여 오픈소스에 Go로 만드는가?

배송조회 서비스는 기존 웹서비스에 하나의 액션으로 구현하는게 아니라 완전히 독립적으로 구현합니다. 몇가지 검토끝에 오픈소스로 공개하기로 하였고 가벼운 프로젝트라 Go언어로 구현합니다.

**왜 [마이크로서비스](http://martinfowler.com/articles/microservices.html)인가?**

![monoliths / microservices]({{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/monolith-microservice.png)

마이크로서비스와 비교되는 방식으로 모놀리식이라는 서비스 개발 방법이 있습니다.

- 다양한 기능을 하는 하나의 큰 프로그램을 만드는 것 (우리가 잘알고 있고 매우 전통적인 개발스타일)
- 하나의 웹서버를 띄우면 회원가입도 되고 정보조회도 되고 메일도 보낼 수 있고 푸시도 보낼 수 있고 통계도 보고 안되는게 없음
- 하나의 작은 기능을 수정해도 전체를 재배포해야하고 특정 기능에 트래픽이 몰려도 전체 서비스를 여러개 띄워야함
- 코드가 커질수록 유지보수가 어려워짐
- 새로운걸 추가하고 싶은데 기존 로직/데이터에 어떤 문제가 있을지 모름
- 기존 기술(버전, 언어, 프레임웍)외에 새로운 기술을 쓰기 어려움

그렇다면, 마이크로서비스 방식은 어떤걸까요?

- 최근 많이 사용되는 마이크로서비스는 기능별로 서비스를 분리하고 독립적으로 동작하게 구성하는 방식
- 기존 웹서비스에 영향을 미치지 않고 독립적으로 개발/유지보수가 가능
- 서버 확장, 배포, 적절한 기술사용, 조직구성등이 유연해짐
- 물론, 관리할게 많아지고 테스트가 어려워지는 단점존재
- 쪼개는 범위와 전략은 서비스에 따라 다름. 무조건 잘게 쪼갠다고 좋지 않음
- 아.. 우리서비스도 이런식인데? 라는 분은 용어는 처음이라도 이미 마이크로 서비스방식으로 개발하고 있을 확률이 높음

배송조회 서비스는 SMS나 Email서비스를 호출하듯이 독립적으로 분리하고 싶었습니다. 별도의 서버로 띄우고 REST API를 요청하여 정보를 가져오는 방식으로 구성합니다. 분리되서 좋고 나중에 다른 서비스에서 사용할 수도 있을겁니다.


**왜 오픈소스 인가**

처음 얘기한 개발자 스스로에게 도움이 되는 장점외에 배송조회의 특성상 오픈소스가 어울린다고 생각합니다.

- 택배사가 너무 많음. 우리나라만 20개정도에 외국까지 포함하면 100개가 넘음 > 혼자 모든 택배사의 배송정보를 구현할 순 없지만, 각자 필요한 사람들이 구현한다면?!
- 공식 API가 아닌 비공식적인 방법이라 언제 막힐지 모름 > 누군가 수정사항을 발견하고 개선해 나간다면?!
- 우체국 택배만 필요한 사람도 있을거고 CJ대한통운만 필요한 사람이 있듯이 각자의 필요에 따라 조금씩 수정 보완하여 개발하면 서로 윈윈!

**왜 [Go](https://golang.org/)인가**

![languages]({{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/languages.png)

- 구글이 개발한 가장 핫한 언어
- [Go를 사용중인 회사들](https://github.com/golang/go/wiki/GoUsers)
- [uber의 Go언어 사용사례](https://eng.uber.com/go-geofence/), [parse의 ruby에서 go로 전환사례](http://blog.parse.com/learn/how-we-moved-our-api-from-ruby-to-go-and-saved-our-sanity/)(루비야 아프지마.. ㅠ)
- 코딩이 재밌고 속도도 괜찮음
- 정적언어지만 동적언어의 장점을 많이 가져옴
- 빠른 컴파일 빠른 실행
- 가비지컬랙션, 메모리 처리 안정성(nil 참조등), methods, interfaces, type assertions, reflection 지원
- VM사용안함. 바로 실행가능한 바이너리 파일로 생성됨
- 심플하고 간결한 문법
  - 클래스가 없고
  - 상속이 없고
  - 생성자가 없고
  - final이 없고
  - exception이 없고
  - annotation이 없고
  - generic이 없음
- 쉽고 훌륭한 동시성 처리
- code style을 강제하여 협업과 유지보수에 유리함
- 단점으로 검색이 어렵고 (구글에서 go를 입력해보자) 패키지관리 시스템이 npm, gem처럼 안정되지 않음

배송조회는 `http요청` > `html조회` > `parsing` > `응답`하는 과정을 가진 굉장히 단순한 서비스입니다. 새로운 언어를 적용하고 배우는데 가장 좋은 방법은 프로젝트를 한번 해보는 것이고 굉장히 적절한 사이즈의 프로젝트입니다.

## Go로 개발하기

Go언어에 대해 설명하는 포스트는 아니지만 Go를 처음 접하는분들을 위해 몇가지 팁을 공유합니다.

- 공부
  - [A Tour of go](https://tour.golang.org/welcome/1) - golang에서 공식으로 제공하는 방법으로 실습위주의 방법. 지하철 출퇴근때 하기 딱 좋음
  - 공식문서([How to Write Go Code](https://golang.org/doc/code.html), [Effective Go](https://golang.org/doc/effective_go.html)) - 역시 지하철 출퇴근때 보면 좋음
  - 책 - 이미 한글로 된 책이 꽤 많이 출간되었고 번역서가 아닌 책도 많아 대부분 내용이 딱딱하지 않고 읽기 좋음([무료공개서적](http://pyrasis.com/go.html)도 있음)
  - [배송조회 오픈소스](https://github.com/purpleworks/delibird) 참여 고고 - 직접 만들어보는게 배우기 가장 좋음
- IDE
  - [IntelliJ IDEA Community](https://www.jetbrains.com/idea/) 추천
  - 무료고 일반적으로 사용하기 쉽고 기능이 강력함
  - GO, File watchers plugin 설치 필수
  - File watcher는 파일을 저장할때마다 `goimports`를 실행하여 코드스타일을 정리함

## 개발

이제 본격적으로 개발을 해 봅니다. 전체 소스는 [https://github.com/purpleworks/delibird](https://github.com/purpleworks/delibird)에 공개되어 있습니다. 상세한 내용은 따로 설명하지 않고 어떤점을 주의하면서 개발하였는지 고민했던 과정을 정리합니다.

**웹서버선택**

Go는 다른 언어와 마찬가지로 다양한 웹프레임워크/미들웨어 오픈소스가 존재합니다. Ruby는 [Rails](http://rubyonrails.org/)가 유명하고 Python은 [Django](https://www.djangoproject.com/)가 유명하고 Node는 [Express](http://expressjs.com/)가 유명하지만 Go는 대표적인게 없고 아직까지 춘추전국시대입니다. 아마 계속해서 대표적인게 없을수도 있습니다. 이는 Go언어의 특성에 기인을 하는데..

배송조회 서비스에서 선택한 웹서버 미들웨어는 [negroni](https://github.com/urfave/negroni)입니다. negroni는 스스로 할 수 있는게 거의 없는 굉장히 라이트한 미들웨어입니다. 라우팅도 다른 라이브러리를 조합해야 하고 응답 렌더링도 여러 라이브러리중에 하나를 선택해야 합니다. 당연히 디비접속관련이나 ORM도 포함하고 있지 않습니다. 하지만 굉장히 유연하게 **조합**할 수 있도록 설계되어 있습니다. 

물론, Go언어도 풀프레임워크가 존재합니다. [martini](https://github.com/go-martini/martini)(8,521 stars)라던가 [revel](https://github.com/revel/revel)(6,895 stars)이 엄청난 인기를 끌고 있습니다. 그런데, negroni는 martini를 개발했던 [codegangsta](https://github.com/codegangsta)가 [martini 디자인 설계는 잘못](https://codegangsta.io/blog/2014/05/19/my-thoughts-on-martini/)이라고 말하고 개발한 미들웨어입니다. 풀프레임워크는 Go언어에 맞는 디자인 설계가 아니라고 생각한겁니다.

실제로 지금도 다양한 형태의 라우팅 라이브러리가 개발되고 있습니다. 서로 이런기능이 좋고 속도가 좋다고 주장하고 있는데 negroni를 사용하면 이를 적용하기가 굉장히 간단합니다. 이번 프로젝트는 아이디도 간지나고 star 8,000개 프로젝트 따위 맘에 안들면 버릴수도 있고 실력도 고오급인 codegangsta가 주장하는데로 negroni를 선택합니다. 라우팅은 [gorilla/mux](https://github.com/gorilla/mux), 렌더링은 [unrolled/render](https://github.com/unrolled/render)를 선택했습니다.

**테스트**

Go는 특별한 라이브러리를 설치하지 않아도 바로 `xxxx_test.go`파일을 작성해서 테스트코드를 작성할 수 있습니다. 하지만 고오급 기능을 위해 [goconvey](http://goconvey.co/)를 사용합니다. UI도 이쁘고 코드도 간결합니다. Go언어는 나온지 얼마 되지도 않았는데 이런툴이 있다는게 놀랍..

HTML을 파싱하는게 주임무이기 때문에 테스트코드는 직접 택배사 서버로 HTTP요청을 하지 않고 [HTTP mocking](https://github.com/jarcoal/httpmock)을 이용합니다. 목업을 사용하면 매번 실제서버로 요청을 날리지 않아도 되고 택배정보에 있는 개인 프라이버시도 숨길 수 있어 좋습니다. 샘플을 모으는게 관건!

**주석**

Go는 간단하게 주석을 작성하는걸 추천합니다. 구글이 개발해서 그런지 github에 소스를 공개하면 잽싸게 공식 문서 사이트에 소스와 주석을 추출하여 문서로 등록해버립니다.(ㄷㄷㄷ 크롤링하나?;) 배송조회서비스도 공식사이트([godoc.org](https://godoc.org/))에서 [문서](https://godoc.org/github.com/purpleworks/delibird)를 볼 수 있습니다.

**코딩**

웹서버과 테스트 방법을 정했으니 본격적으로 코딩을 합니다. HTML DOM을 조회하기 위해 [goquery](https://github.com/PuerkitoBio/goquery)를 사용했습니다. jQuery처럼 체이닝메소드를 지원하고 비슷한 API를 제공합니다.

홈쇼핑처럼은 CJ대한통운만 이용하지만 사용자수 1위인 우체국택배도 구현하였습니다. 뭔가 Go 초보티가 많이 나는 소스지만 동작은 합니다. 일단 완성! 버전 0.1.0으로 등록합니다.

## 오픈소스로

어떤 프로젝트를 오픈소스화 한다는건 코딩이외에 추가적인 작업들을 필요로 합니다. 단순히 코드를 정리하고 공개하는것 외에 다른 개발자들의 참여를 유도하고 지속가능한 개발을 하기 위해 소스 품질에 신경을 써야 합니다.

github은 [explore](https://github.com/explore)메뉴와 [trending](https://github.com/trending)메뉴를 제공합니다. 여기서 인기있는 오픈소스들은 어떤식으로 프로젝트를 구성하고 있는지 참고하면 많은 도움이 됩니다. 몇가지 프로젝트를 참고하여 오픈소스에 필요한 작업들을 해봅니다.

**이름/로고만들기**

개발자들의 코딩시간 대부분을 잡아먹는다는 이름짓기 시간입니다. `shipment tracking library`보다는 뭔가 그럴듯한 이름을 짓는것이 좋습니다. 개인적으로 생명체가 마스코드인것이 성공하는 오픈소스라고 생각되는데 (github의 [octocat](https://octodex.github.com/), golang의 [gopher](https://blog.golang.org/gopher), docker의 [moby dock](https://blog.docker.com/2013/10/call-me-moby-dock/)등..) 그에 따라 적당히 동물을 가지고 이름을 지었습니다. 배송이니까 새가 생각났고 delivery와 bird의 조합인 **Delibird**가 탄생하였습니다.

이제 이름을 지었으니 로고를 만듭니다. 직접 그릴순 없으니 심플한 무료 아이콘이 많은 [icons8.com](https://icons8.com/#/ios)에서 새 아이콘을 하나 고르고 이쁘장한 색샘플을 모아놓은 [flatuicolors.com](http://flatuicolors.com/)에서 보라색계열을 하나 선택합니다. 폰트도 밋밋하지 않게 [구글웹폰트](https://www.google.com/fonts)에서 하나 고릅니다.

<p align="center">
<img src="{{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/delibird.logo.png" alt="Delibird Logo" title="Delibird Logo" />
</p>

짠, 포샵을 쓱싹하여 그럴싸한 이름에 로고가 만들어졌습니다.

**문서화**

오픈소스 프로젝트는 문서가 중요합니다. 문서에 오픈소스를 소개하고 발전 의지를 잘 표현해야 다른 개발자를 참여하게 만들 수 있고 잘 운영되는 듯한 느낌을 줍니다.

첫번째로 필요한 건 [`README.md`](https://github.com/purpleworks/delibird/blob/master/README.md)파일 입니다. 이 파일은 github 첫화면에 보여지기 때문에 매우 중요합니다. 다음과 같은 항목을 기본으로 넣어줍니다.

- 기본소개 - 어떤 프로젝트인지 소개
- 설치방법 - 바로 사용해볼 수 있도록 설치방법 소개
- 사용방법 - 샘플을 포함한 사용방법 소개
- 테스트방법 - 전체 테스트를 하는 방법 소개
- 기여방법 - 기여에 대한 설명
- 라이센스 - 라이센스 소개

두번째로 필요한 건 [`LICENSE`](https://github.com/purpleworks/delibird/blob/master/LICENSE)파일입니다. 라이센스는 [다양한것들](http://choosealicense.com/)중에 선택할 수 있는데 가장 심플한 MIT 라이센스를 선택합니다.

추가적으로 [`CHANGELOG.md`](https://github.com/purpleworks/delibird/blob/master/CHANGELOG.md)파일등을 추가합니다.

**웹페이지**

github은 [page](https://help.github.com/articles/user-organization-and-project-pages/)라는 기능으로 정적인(html, image, css, js) 페이지를 무료로 만들수 있습니다. 

{% gist subicura/56599a77c63ea929f413a7ab8052c61e %}

프로젝트에 `gh-pages`라는 브랜치를 만들고 html파일과 js,css파일등을 넣으면 끝입니다. 인터넷에서 무료 bootstrap landing 테마를 하나 다운받아 쓱싹 만들고 push합니다. github 조직이름이 purpleworks이고 프로젝트명이 delibird라면 [purpleworks.github.io/delibird](http://purpleworks.github.io/delibird/)라는 URL로 자동으로 연결됩니다. 이를 통해 README.md로는 부족한 내용을 보여줄 수 있습니다.

여기서는 배송조회 테스트를 해볼수 있으면 좋을것 같아 테스트 폼을 넣었습니다.

**Github 외부서비스 연동**

github은 다양한 외부 서비스와 연동이 가능합니다. 보통 github 저장소에 소스를 푸시하면 연동된 서비스가 소스를 테스트하고 결과를 알려줍니다. 공개 저장소는 무료로 제공하고 비공개 저장소에 대해서만 과금을 취하는 경우가 일반적입니다.

유용한 서비스를 연동해 놓으면 코드 품질과 테스트 결과를 자동으로 알 수 있어 매우 유용합니다.

- [travis-ci](https://travis-ci.org)
  - 대표적인 Test and Deploy 서비스
  - [`.travis.yml`](https://github.com/purpleworks/delibird/blob/master/.travis.yml) 파일을 만들고 빌드 정보 입력
  - 매 빌드마다 `go test`를 수행하고 결과를 알려줌
  - 매 빌드가 끝나면 커버리지 정보를 coveralls로 전송하게 함
- [coveralls](https://coveralls.io/)
  - 대표적인 코드 커버리지 서비스
  - travis-ci에서 정보를 전달하도록 설정
- [codeclimate](https://codeclimate.com)
  - 대표적인 코드품질 검사 서비스
  - 다양한 항목으로 코드를 검사하여 학점처럼 점수를 매겨줌
  - Go는 아직 지원 안하는듯하여 다른 서비스 사용
- [goreportcard.com](https://goreportcard.com/)
  - Go전용 코드품질 검사 서비스
  - go_vet, gocyclo, gofmt, golint, ineffassign, license, misspell등을 돌려 점수를 매겨줌
  - 다행히 A+! (점수가 후한듯..)

**뱃지**

![github badge]({{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/github-badge.png)

github은 상단에 각종 상태를 뱃지아이콘으로 보여주는 특별한 문화(?)가 있습니다. 라이센스라던가 문서링크, 코드 품질이나 커버리지, 빌드결과(테스트) 여부등이 있습니다. 이외에도 커뮤니티 게시판 링크라던가 채팅링크등 다양한 뱃지가 있습니다. [shields.io](http://shields.io/)에서는 다양한 뱃지아이콘을 제공하고 있고 각 서비스마다 자체적으로 뱃지 링크를 제공하기도 합니다.

- license
  - [shields.io](http://shields.io/) 라이센스 뱃지 사용
  - 소스 저장소의 LICENSE파일을 보고 이미지 생성
  - https://img.shields.io/github/license/{id}/{project}
- godoc
  - [godoc.org](https://godoc.org/) 뱃지 사용
  - Go프로젝트는 godoc이 자동으로 생성됨
  - https://godoc.org/github.com/{id}/{project}?status.svg
- 코드품질
  - [goreportcard.com](https://goreportcard.com/) 뱃지 사용
  - 소스 품질 결과를 A+, B, C등의 뱃지로 생성함
  - http://goreportcard.com/badge/{id}/{project}
- 커버리지
  - [shields.io](http://shields.io/) coveralls 뱃지 사용
  - coveralls 결과를 뱃지로 생성함
  - http://img.shields.io/coveralls/{id}/{project}.svg
- 빌드결과
  - [travis-ci](https://travis-ci.org) 뱃지 사용
  - https://travis-ci.org/{id}/{project}.svg?branch=master


**heroku**

[heroku](https://www.heroku.com/)는 소스빌드/배포/스케일이 자유로운 클라우드 서비스입니다. 다른 웹호스팅 서비스와 차별점은 소스를 업로드만 하면 알아서 웹서버를 띄워준다는 점입니다. 이게 무슨 말이냐면 Rails, Django, Express등은 고유한 파일 구조가 있습니다. 이러한 디렉토리구조나 파일의 확장자를 보고 [알아서](https://devcenter.heroku.com/articles/buildpacks) 서버를 띄운다는 신박한 서비스입니다.

<p align="center">
<img src="{{ site.url }}/assets/article_images/2016-06-13-start-go-shipment-tracking-opensource/heroku.png" alt="heroku free plan" title="heroku free plan" />
</p>

더 놀라운건 무료 플렌입니다. 30분간 요청이 없으면 자동으로 서버가 중지되고 그 이후 요청이 들어오면 다시 서버를 시작합니다. 예전에는 시간제한이 없었는데 이제 시간제한이 생겨서 아쉽긴 하지만 테스트로 배송조회 서비스를 켜놓기에는 부족함이 없습니다. heroku에 로그인을 하고 서버를 만든 후 github 소스를 연동하니 바로 서버가 뜹니다. 정말 뜹니다.

<p align="center">
<a href="https://heroku.com/deploy?template=https://github.com/purpleworks/delibird">
<img src="https://www.herokucdn.com/deploy/button.svg" alt="Heroku button" title="Heroku button" />
</a>
</p>

게다가, 누구든 쉽게 오픈소스로 부터 서버를 만들 수 있게 [heroku button](https://devcenter.heroku.com/articles/heroku-button) 기능을 제공합니다. 소스폴더에 [`app.json`](https://github.com/purpleworks/delibird/blob/master/app.json) 파일만 만들어 놓으면 됩니다. 저 버튼을 클릭하면 바로 테스트 서버를 띄워볼 수 있습니다. 언제 이렇게 서버 띄우기 쉬운 세상이 되었나요? ㄷㄷ

**커뮤니티**

오픈소스에서 중요한건 건전하고 활발한 커뮤니티를 만드는 것입니다. 기본적으로 github에서 제공하는 이슈기능을 사용하면 되지만, 포럼이나 IRC, 메일링리스트를 사용하면 더 효과적으로 관리할 수 있습니다. Delibird는 아직 작은 프로젝트이기 때문에 기본적인 이슈기능만 사용합니다.

**홍보**

오픈소스가 생명을 얻고 발전하려면 홍보가 필수 입니다. 아무리 유용한 프로젝트라고 해도 홍보가 없으면 사람들이 찾을수가 없습니다. 그래서 제가 지금 이렇게 블로그를 통해 홍보를 하고 있는거 아니겠습니까..

[https://github.com/purpleworks/delibird](https://github.com/purpleworks/delibird)오셔서 star한번씩 눌러주시고 관심갖어 주시면 감사하겠습니다. ㅠㅠ

## 그래서

내부적으로 사용하던 소스를 오픈하기위에 적절히 리팩토링을 하고 문서를 추가하여 [https://github.com/purpleworks/delibird](https://github.com/purpleworks/delibird)에 공개하였습니다. Go에 관심있으신분이나 배송조회에 관심있으신분은 별 눌러주시고 참여해주세요. 열려있습니다!

많은 사람들이 오픈소스에 참여하고 오픈소스 프로젝트를 하고 있습니다. 하지만, 어떻게 만드는지에 대해서는 정리된 글이 잘 없는 것 같아 포스트를 작성하였습니다.

사실, 널리 사랑받는 프로젝트는 위에 나열한 겉치례(?)보다는 얼마나 유용하고 얼마나 잘 설계되어 얼마나 자아알 짜여졌는지가 중요합니다. 최신 트렌드를 아는것과 잘 개발하는 것이 정비례하지는 않지만 여러가지 최신 트렌드를 알면 지금보다 조금 더 나은 개발자가 되는데는 도움이 된다고 생각합니다.

그리고 중요한점은 오픈소스는 생각보다 시간과 노력이 많이 필요한 작업이라는 점입니다. 지금 몇가지 공개 저장소를 관리하고 있는데 여간 손이 많이 가는게 아닙니다. 이슈가 올라오면 체크하고 확인하고 수정하고 버전업하고 npm이나 bower에 등록하고.. 겨우 star수 200개도 이정도인데 다른 프로젝트들은 상상도 못할 것 같습니다. 오픈소스 커미터분들에게 감사드립니다.

배송조회 서비스를 만든 홈쇼핑처럼에서 지난번 고기덮밥에 이어 돈까스 메뉴도 추가되었으니 서비스에 관심있으신분은 [https://www.likehs.com/](https://www.likehs.com/) 에 방문해 주시구요.
개발자 상시 모집중입니다. 연락주세요 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))
