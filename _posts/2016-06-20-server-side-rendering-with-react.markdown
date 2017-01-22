---
published: true
title: 왜 React와 서버 사이드 렌더링인가?
excerpt: 홈쇼핑처럼 4번째 상품인 튀김을 기름에 튀기면서 React를 적용하느라 고생했던 순간이 떠올라 React와 서버 사이드 렌더링 적용과정을 정리해봅니다. 여기서는 어떻게보다는 왜에 대해 설명합니다.
tags: [FrontEnd, Javascript, React, Angular]
layout: post
comments: yes
fb_social_baseurl: http://subicura.com
last_modified_at: 2017-01-21T10:00:00+09:00
---

### 2016/12/29 수정

- AngularJS의 단점으로 적었던 IE8지원은 React 또한 15.0.0에서 지원 중단되었습니다. ;ㅁ;
- AngularJS의 단점으로 적었던 비표준 태그는 data-* 형태로 대체 가능합니다.
- Angular v2 등장에 따른 v1 지원 중단 우려는 큰 문제는 없어보입니다. (최근 12/23일 업데이트)
- Angular2는 TypeScript가 메인이긴 하나 자바스크립트 또는 Dart로 작성가능합니다.

---

![튀김과불맛쌀떡볶이x홈쇼핑처럼]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/fried_things.jpg)

[홈쇼핑처럼](https://www.likehs.com) 4번째 상품인 [튀김](https://www.likehs.com/tvprogram/index/view/id/25/)을 기름에 튀기면서 [React](https://facebook.github.io/react/)를 적용하느라 고생했던 순간이 떠올라 React와 서버 사이드 렌더링 적용과정을 정리해봅니다. 여기서는 **어떻게**보다는 **왜**에 대해 설명합니다.

현재 홈쇼핑처럼의 커머스 백엔드는 PHP로 만든 Magento를 사용하고 있고 프론트엔드는 일부 화면에서 React를 사용하고 있습니다. 웹서버에 v8js extention을 설치하여 서버 사이드 렌더링을 지원하고 있습니다. 그리고 홈쇼핑처럼에서 사용중인 채팅은 [Rails](http://rubyonrails.org/)로 만든 별도의 서비스로 분리하여 운영하고 있고 관리자 페이지 프론트엔드는 역시 React에 [therubyracer](https://github.com/cowboyd/therubyracer)라는 V8 javascript interpreter를 이용하여 서버 사이드 렌더링을 지원하고 있습니다. 이전에 작업했던 .NET 프로젝트에도 프론트엔드는 React에 [ReactJS.NET](http://reactjs.net/)를 이용하여 서버 사이드 렌더링을 지원하였습니다.

백엔드는 프로젝트마다 달라도 프론트엔드는 React에 서버사이드 렌더링을 지원하는 방식으로 통일하고 있습니다. React가 뭐길래, 서버사이드 렌더링이 뭐가 좋길래 이런 결정을 한걸까요?

먼저, 자바스크립트를 이용한 웹 개발의 발전방향을 살펴봅니다.

## ajax가 없던 시절

지금은 Javascript를 이용하여 동적인 웹페이지를 자연스럽게 만들고 있지만 10년전 [ajax](https://en.wikipedia.org/wiki/Ajax_(programming))가 등장하기 전에는 서버에서 전체 HTML을 만드는 방식이 일반적이였습니다.

{% gist subicura/427978fd79fa14e6cfd70644f6a5f4bd %}

조금 복잡해보이고 뷰에 여러가지 로직이 들어가 있지만 지금도 어디선가는 사용하고 있는 전통적인 개발 방식입니다. 이때까지만 해도 javascript는 일부 고오급 웹 개발자들이 사용하는 언어였고 웹페이지의 컨텐츠보다는 무언가를 꾸며주거나 화려한 느낌을 주는데 사용했습니다.

## ajax의 등장

<p align="center">
<img src="{{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/google-auto-complete.png" alt="Google 추천검색어" title="Google 추천검색어" />
</p>

처음 ajax가 등장했을때 충격은 정말 엄청났습니다. Google의 추천 검색어 따라하기가 유행했는데 검색어 입력란에 `web`을 입력하면 추천 검색어가 실시간으로 보였습니다. 이게 정말 웹에서 가능하다니?!

그때는 Javascript의 J도 모르고 눈 내리는 소스를 복사 붙여넣기하며 좋아하던 시절이라 그 충격은 더 했습니다. 구글이 대중적으로 실시간 추천검색어 기능을 선보였고 곧 수많은 포털, 웹사이트에서 따라하기 시작합니다. 비슷한 시기에 [prototype.js](http://prototypejs.org/)와 [jQuery](https://jquery.com/)가 나왔고 웹 세계는 대 Javascript 시대를 맞이하게 됩니다.

Javascript 라이브러리를 안쓰는 페이지는 없었고 ajax를 이용한 동적인 컨텐츠 구성도 일반적으로 사용되기 시작했습니다. 하지만 제대로 된 표준이라던가 프레임워크는 없었고 이를 화면에서 표현하기 위해 다양한 방법이 등장합니다.

## Javascript 뷰 렌더링

예전에 뷰는 서버 프로그램에 찰싹 달라붙어 있었지만 이제 Javascript를 이용하여 동적으로 HTML을 만드는 시대가 왔습니다. 동적으로 HTML을 만드는 방법을 하나씩 알아봅니다.

### String concatenation

{% gist subicura/dc7630ef6346f5108e2c5fc789615387 %}

가장 쉬운방법은 HTML을 string을 붙이고 붙이고 붙여서 특정 DOM에 넣는 것 입니다. 굉장히 심플하고 잘 동작합니다. 그런데 쓰다보니 몇가지 문제가 있습니다. `data.name`에 태그(`<script>`)가 들어갈 수 있어 XSS<sub>Cross-Site Scripting</sub> Injection에 노출되어 있습니다. 이를 보완한 좀더 복잡해진 예를 봅니다.

{% gist subicura/34bb24f334004572ddedc1b3162aaf56 %}

음 점점 따옴표를 사용할때마다 신경이 곤두서고 동작은 하지만 뭐가 뭔지 모르게 되어 갑니다. 태그를 치환하는 부분을 실수로 빼먹기라도 하면 심각한 보안 문제가 발생할 수 있습니다. 뷰는 더 복잡해지고 상황은 더 심각해지고 HTML은 Javascript에 섞이며 퍼블리셔는 포기하고 우리는 더 많은 야근을 하게 됩니다.

### Template engine

이러한 상황을 해결하기 위해 각종 템플릿 엔진이 등장하기 시작합니다. 제가 가장 오랜시간 애용했던 [doT.js](http://olado.github.io/doT/index.html)를 비롯해 twitter에서 만든 [hogan.js](http://twitter.github.io/hogan.js/), [mustach](https://mustache.github.io/), [handlebars](http://handlebarsjs.com/)등등등등 너무너무너무 다양한 템플릿 엔진이 (지금도 계속해서) 등장합니다.

![template engine compile]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/template-engine.png)

각각 라이브러리마다 파일 사이즈, 성능, 부가기능등의 차이가 있지만 하는 일은 동일합니다. 중괄호(`{ > 콧수염 > mustach`)를 이용하여 반복문, 조건문 등을 넣은 템플릿파일을 만들고 Data를 연동하여 HTML을 생성합니다. 이러한 방법은 string을 붙이고 붙이고 붙이는 방법보다 훨씬 나은 환경을 보여줍니다.

지금도 새로운 템플릿엔진이 계속해서 나오고 있고 동적으로 작은 view를 처리하거나 큰 프레임워크의 일부로 사용되고 있습니다.

## Framework

이러한 상황에서 javascript MVC(MV*?) framework들이 등장하게 됩니다. MVC? 왜???? 서버도 MVC로 짜기 바쁜데 왠 client side mvc?

웹환경은 점점 더 리치해지고 고객들은 점점 더 편하게 웹 사이트를 이용하려고 합니다. 지메일이나 구글 캘린더와 같은 서비스는 일반적인 방식으로는 거의 짜기가 불가능할 정도로 복잡해졌습니다.

이때, [Backbone.js](http://backbonejs.org/)가 엄청나게 히트합니다. 템플릿과 모델, 이벤트를 분리하여 작업할 수 있게 도와주었고 미니멀한 구조와 빠른 속도, 이해하기 쉬운 코드로 많은 인기를 얻습니다. 심플해서 좋았지만 심플하다는건 기능이 부족했다는 뜻이고 부족한 기능을 보완하기위해 marionette과 같은 Backbone 플러그인이 등장하여 같이 인기를 얻습니다. 이전보다는 많이 진일보했지만 아직 **프레임워크**라고 부르기에는 기능이 조금 부족합니다.

Backbone.js가 인기를 끌기 시작할때 **제대로 된** 프론트엔드 프레임워크들이 등장합니다. [Ember](http://emberjs.com/), [Knockout](http://knockoutjs.com/)등이 등장하였는데 예전부터 각자의 프로젝트에서 활용하고 있던 것들을 잘 정리하여 오픈소스로 공개하였습니다. 이러한 프레임워크들은 소스사이즈가 컸고 성능은 무겁고 기능은 복잡하고 러닝커브는 마구 올라갔습니다. 뭔가 좋아보이기는 하는데 쓰기엔 너무 무거워 보였고 굳이 프론트엔드를 MVC로 구성해야 하는 생각도 듭니다.

그때 끝판왕 AngularJS가 나타납니다.

## [AngularJS](https://angularjs.org/)

AngularJS는 React를 돋보이게 하기 위함이니 좀더 상세하게 설명합니다.

![Google Trends]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/google-trend-angularjs.png)

AngularJS는 기존의 라이브러리나 프레임워크들과는 다르게 DOM을 조작하거나 제어하는 방식에 초점을 맞추지 않고 데이터의 변화에 초점을 맞추는 완전히 새로운 접근법을 사용합니다. 데이터에 초점을 맞추는 이러한 방식자체는 완전히 새로운게 아니였으나 정말 **잘** 구현하여 사용하기 쉽게 공개한 겁니다. HTML에 작성해야 하는 코드는 조금 늘었지만 Javascript쪽 코드는 정말 놀라울정도로 단순해지고 저를 포함한 웹 프론트엔드 개발자들은 열광합니다.

AngularJS의 장점을 구체적으로 살펴봅니다.

{% gist subicura/1b2d30907d648357876834eddb205075 %}

**개발속도가 빠름**

- 특별한 추가 코드 없이 변수 할당만으로 양방향 데이터 바인딩 지원. get/set 함수 필요없음
- 별도의 템플릿 코드 분리 없이 뷰-데이터 연동. 기본 HTML이 곧 템플릿파일
- DI<sub>Dependency Injection</sub> 패턴사용. new같은 없고 그냥 인자로 넘기기만 하면됨
- 모듈화가 잘되어 있어 재사용이 용이함
- 플러그인이 엄청나게 많음

**유지보수가 쉬움**

- Javascript 코드량이 적음
- MVC 패턴이 잘 정리되어 있어 개발자간 코드가 비슷함
- Controller, Directive, Filter, Service 모듈 구분이 명확

**테스트 코드 작성 용이**

- 모듈별 테스트 작성이 쉬움. 튜토리얼도 테스트코드부터 시작함
- 데이터 로딩 시점이 비동기인 경우 E2E<sub>end-to-end</sub> 테스트가 까다로운 경우가 있는데 [Protractor](http://www.protractortest.org/)를 사용하면 간단함

**프로젝트 분리**

- 백엔드를 API서버로 사용하여 프론트엔드와 완전히 분리할 수 있음
- 템플릿을 스크립트 태그나 Javascript에서 관리하지 않고 HTML을 그대로 사용하여 퍼블리셔 협업도 좋음

**구글이 관리함**

- 오오, 구글에서 지메일, 캘린더 이런걸로 만드는건가??
- 망하진 않겠다!

장점이 어마어마 합니다. 그럼 단점을 알아볼까요?

**AngularJS의 단점**

- 속도가 느림. 특히 모바일
- IE8지원안함 [^1]
- 러닝커브가 높음. 특히 Directive는 공부할수록 헬
- 비표준 태그 사용의 찝찝함. (대부분의 브라우져가 잘 처리하긴 하지만서도..)
- 페이지 깜빡임 이슈([FOUC](https://en.wikipedia.org/wiki/Flash_of_unstyled_content)<sub>Flash of unstyled content</sub>) [^2]
- 묘한 애니메이션 적용. 컨텐츠가 그려지는 시점을 정확하게 제어하기 어려워 애니메이션 적용이 쉽지 않음
- SEO 이슈. 크롤링 봇은 컨텐츠 로딩전 빈페이지만 바라봄. title, meta tag도 처음 페이지것만 바라봄 [^3]
- 뒤로가기 하면 페이지 새로 로딩함. history API를 이용한 페이지 이동이 실제로는 페이지를 동적으로 로딩하는 구조. 스크롤도 최상단으로 이동 [^4]
- 외부 서비스 콜백처리
  - 외부(페이스북, 구글, ...) 로그인 후 돌아오는 페이지는 어떻게 처리하나?
  - 이메일 회원가입 확인 페이지는 어떻게 하나?
  - 결제 페이지 이동은 어떻게 하나?
  - 결국 백엔드쪽에 뷰 페이지를 만들어야 하나?
- [Angular 2](https://angular.io/)와의 호환성
  - Angular 2는 완전히 다르다?!
  - 기존 1버전은 곧 지원 중단?!
  - 호환이 안된다? 업데이트가 안된다?!
  - [TypeScript](https://www.typescriptlang.org/)만 지원한다? 그게 뭔데 ㅠ
- <del>구글도 자기 서비스에 안씀</del>
  - 안쓰는 줄 알았는데 사용하고 있었네요 (강규현님 감사합니다)
  - [https://www.madewithangular.com/#/categories/google](https://www.madewithangular.com/#/categories/google)

엄청난 장점만큼 단점을 같이 보았는데 사실 대부분의 단점은 AngularJS의 단점이라기 보다는 **웹앱**의 단점입니다. AngularJS는 앱용 웹에 적합한 프레임워크입니다. 가만보니 공식사이트 메인에 *HTML enhanced for web apps!* 라고 적혀있습니다.

이런 사실을 무시하고 일반적인 서비스에 쓴적이 있습니다. 속도가 느린건 핸드폰이 빠르게 발전하면서 해결될거라 믿었고 위에 나열한 단점은 열심히 꼼수(?)로 해결할 수 있을것 같았습니다.

하지만, 결국 Angular 2가 공개되고 업데이트를 포기하게 됩니다. 여러가지 꼼수를 다시 적용하고 테스트하고 관리하기가 너무 힘들고 이미 이전 프로젝트도 꼼수로 인해 너덜너덜해진 상태입니다. 기술적으로 안되는건 없겠지만(<del>안되는 것도 있음</del>) 결국 유지보수와 호환성에 문제가 생깁니다. 웹앱이 아니라면 브라우저가 알아서 해주는 것들을 웹앱이기 때문에 여러가지 추가적인 셋팅이 필요하게 됩니다.

AngularJS는 좋지만, 웹앱용에 한정이고 성능이 크게 중요치 않은 어드민이나 내부서비스에 적합하다고 결론을 내립니다.

## [ReactJS](https://facebook.github.io/react/)

끝판왕(<del>인줄알았던</del>) AngularJS말고 다른거 없나 찾고 있을때 거짓말처럼 페이스북에서 React를 발표합니다. React는 MVC프레임워크는 아니고 User Interface(View)를 만드는 라이브러리입니다. AngularJS처럼 MVC를 표방하는 것이 아니라 V(iew)에 집중하였고 훨씬 가벼웠습니다.

**React의 장점**

- 쉽다. API가 몇개 없다. 일단 시작하긴 쉽다.
- 빠르다. 느린 DOM대신 Virtual DOM이라는 걸 이용.
- 단순하다. 2-way 바인딩 대신 1-way를 지원하고 Component 구성하기 쉬움.
- 서버 사이드 렌더링 지원이 좋음
- ES6지원 좋음
- 일부페이지에 큰 수정없이 바로 적용할 수 있음

사실 React는 갑자기 등장한 라이브러리가 아닙니다. 페이스북은 PHP를 사용하는 대표적인 회사로 PHP의 성능을 개선하기 위해 [Hack](http://hacklang.org/)이라는 언어를 자체적으로 만들고 [HHVM](http://hhvm.com/)이라는 가상머신도 만든 고오오오급 개발 회사입니다. 그리고 PHP의 문법을 변경하여 뷰 렌더링을 좀더 쉽게 한 [XHP](http://facebook.github.io/xhp-lib/)를 2010년에 발표하기도 하였습니다.

{% gist subicura/85b3d6f54af7be72df149463f7b142bb %}

간단한 XHP 코드 샘플을 보면 PHP변수에 HTML태그를 바로 할당하여 사용하는 걸 볼 수 있습니다. XSS 이슈를 방지해주고 커스텀 태그를 쓸 수 있어 코딩이 더 단순해지고 쉬워집니다.

태그를 바로 할당해서 사용할 수 있는 아이디어를 Javascript로 가져오기로 하고 2013년에 [JSX](https://facebook.github.io/react/docs/jsx-in-depth.html)를 만듭니다. 여기에 Virtual DOM이라는 걸 도입하여 DOM을 직접 계산하지 않고 내부적으로 빠르게 diff를 계산하는 알고리즘을 만들어냅니다. 마치 git을 사용하듯이 변경된 부분만 샤샤샤 찾아주어 빠르게 화면을 렌더링 할 수 있게 해줍니다. 첫 알고리즘은 O(n<sup>3</sup>) 이였으나 결국 O(n)으로 완성합니다. ㄷㄷㄷ 게다가 React는 처음부터 서버 사이드 렌더링을 고려하여 설계합니다. 이런 짱짱맨..

서버 사이드 렌더링을 지원하므로 웹앱때문에 생기는 단점이 거의 없고 컴포넌트를 이용한 구조는 개발속도를 빠르게 하고 유지보수를 용이하게 도와줍니다. 그리고 이미 facebook, instagram, airbnb, netflix, flipboard, dropbox등에서 사용하고 있습니다. 운영 환경에 사용할 수 있는 **현실적인 끝판왕**이 등장했습니다.

전체 구조를 바꾸지 않더라도 적용하기 쉽기 때문에 진행중인 서비스에서 일부 동적 로직이 필요한 페이지에 React를 사용하고 서버 사이드 렌더링을 적용하기로 합니다.

## Isomorphic Javascript

![Isomorphic Javascript]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/isomorphic-javascript.png)

동형 자바스크립트라는 어색한 말로 해석되는 Isomorphic Javascript는 서버와 클라이언트가 같은 코드를 사용한다는 뜻입니다. 웹브라우져에서만 동작할 것 같았던 Javascript가 [V8엔진](https://developers.google.com/v8/)이 등장하고 [Node.js](https://nodejs.org/)가 나타나면서 서버에서도 Javascript를 사용하기 시작합니다. 클라이언트에서 동작하던 라이브러리를 서버에서 똑같이 돌릴수 있게 됩니다.

![Client vs Server rendering from airbnb]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/client-side-vs-server-side.png)

**서버 사이드 렌더링의 장점**

- 유저가 처음으로 컨텐츠를 보는 속도가 빨라짐
- 서버따로 클라이언트따로 작성하던 코드가 하나로 합쳐짐
- SEO 적용도 OK
- 웹앱의 단점 대부분 없어짐!

## React 서버 사이드 렌더링

React는 서버 사이드 렌더링을 염두에 두고 설계되었습니다.

[`ReactDOMServer.renderToString`](https://facebook.github.io/react/docs/top-level-api.html#reactdomserver.rendertostring) 함수는 서버 사이드에서 사용하는 렌더링 함수입니다. 이 함수는 HTML을 생성하는데 클라이언트에서 동적으로 생성하는 것과 동일한 HTML을 생성합니다. 다른점은 `data-react-checksum`과 같은 attribute가 추가되었다는 점입니다.

서버 사이드에서 생성된 HTML에는 이벤트 속성이 없기 때문에 반드시 `ReactDOM.render()`과 같은 클라이언트 사이드 렌더링을 다시 한번 수행해야 합니다.

{% gist subicura/6e9c87c3395f599a80da8e21ebbed822 %}

**두번 렌더링한다구요?** 네.

두번째 렌더링을 할때 이미 서버 사이드 렌더링이 되어 있다면 attribute값을 보고 다시 렌더링 하지 않고 생성된 DOM에 오직 이벤트 속성만 추가합니다. checksum을 보고 판단하기 때문에 속도가 굉장히 빠릅니다.

이러한 부분이 이미 React는 서버 사이드 렌더링을 염두에 두고 설계되었다는 점입니다.

## 서버 사이드 렌더링 적용

그럼 실제로 서버 사이드 렌더링을 사용하려면 어떻게 해야 할까요?

**1. 서버가 Node.js일때**

![Node.js server]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/isomorphic-js-node-only.png)

서버가 Node.js일 경우 바로 React 코드를 실행할 수 있습니다. 그냥 `renderToString` method를 실행하여 view에 그리면 됩니다. 와우!

**2. V8엔진 라이브러리를 사용**

![Use V8 engine]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/isomorphic-js-v8.png)

서버가 Node.js가 아닐 경우 각 언어에서 제공하는 V8 engine을 사용할 수 있습니다.

1. V8 engine을 만들고
2. React와 Component 소스를 전부 입력하여 컴파일을 한 뒤
3. Data를 인자로 실행하여 HTML 얻음

서버에 V8 engine만 설치되어 있다면 비교적 쉽게 구현할 수 있습니다. 특히 [react-rails](https://github.com/reactjs/react-rails), [React-PHP-V8Js](https://github.com/reactjs/react-php-v8js), [React.NET](https://github.com/reactjs/React.NET)는 React에서 직접 관리하는 라이브러리로 바로 사용할 수 있습니다.

**3. 별도의 Node.js 서버 구축**

![Node.js render server]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/isomorphic-js-node-backend.png)

React 코드만 실행하고 렌더링하는 별도의 Node.js 서버를 띄우는 방법입니다.

1. 원래 웹서버로 요청이 들어오면
2. 다시 Node.js 서버로 렌더링을 위한 정보(module, props JSON)를 HTTP request하고
3. Node.js 서버에서는 renderToString한 결과 string을 HTTP response

서버를 하나 더 관리해야 하는 번거로움과 HTTP 통신으로 인한 overhead가 발생하여 좋지 않은 방법이라고 생각하는데 의외로 사용하는 곳이 많은 것 같습니다. Airbnb에서 만든 [hypernova](https://github.com/airbnb/hypernova)를 이용하면  Express.js등을 사용할 필요 없이 렌더링 전용 서버를 구축할 수 있습니다.

**4. 기존 서버가 API 구성하기 용이할때**

![Node.js frontend server]({{ site.url }}/assets/article_images/2016-06-20-server-side-rendering-with-react/isomorphic-js-node-front.png)

기존 서버가 API를 잘 제공하고 있다면 앞단에 Node.js를 두고 기존 서버를 API서버로 사용하는 방법이 있습니다. 이럴 경우 쿠키라던가 인증 토큰등을 추가로 관리하고 라우팅을 다시 셋팅해야 합니다.

## 그래서

현재 React를 즐겨 사용하고 있긴 하지만, 사실 언제 또 바뀔지 모릅니다. 최근에는 [meteor](https://www.meteor.com/)라는 걸출한 Javascript App Platform이 나와서 인기를 얻고 있습니다. 빠르게 변하는 웹환경만큼 새로운 라이브러리, 프레임워크도 계속해서 나옵니다. 왜 프론트엔드 개발자는 끊임없이 공부해야 하는가? 대체 언제 좀 편하게 예전에 배웠던거 슬렁슬렁 쓰면서 개발할 수 있을까? 라는 질문을 해보지만, 포기하고 적당히 하는 순간 빠르게 변하는 웹 세계에서 뒤쳐진다고 생각합니다.

하지만, 공부하는 것과 운영환경에 적용하는 것은 다른 이야기로 React가 쉽고 간단한 라이브러리인 것처럼 묘사했지만 redux가 들어가고 좀 더 리치하게 사용하려고 하면 결코 쉽지 않다는걸 알게 됩니다. 그리고 많이 빨라졌다고 하지만 역시 라이브러리는 무겁고 아직 모바일 환경에서는 느릴 수 밖에 없습니다.

결론적으로, 무조건 새로운 기술을 도입하는 것 보다는 정말 필요한지 고려해보고 도입하는 것이 중요합니다. 그리고 모든 페이지에 적용하려고 하지 말고 정말 필요한 일부 페이지에 적용하는 것이 속도면에서나 유지보수면에서나 호환성면에서 나은 결과를 보여줍니다. 1-2년이 지나면 결국 또 바뀌게 됩니다. 누가, 어떻게 업데이트 합니까?

아무쪼록 React는 좀 오래가길 빌면서, 이번에 출시한 튀김 맛있으니 서비스에 관심있으신분은 [https://www.likehs.com/](https://www.likehs.com/) 에 방문해 주시구요.
개발자 상시 모집중입니다. 연락주세요 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))

----

### 주석

[^1]: [angular.js-ie8-build](https://github.com/fergaldoyle/angular.js-ie8-builds)를 이용하면 IE8에서도 돌긴돔
[^2]: [ng-cloak](https://docs.angularjs.org/api/ng/directive/ngCloak)으로 어느정도 극복가능
[^3]: [prerender](https://prerender.io/)를 이용하면 어느정도 극복가능. meta tag 업데이트도 디렉티브를 만들면 됨
[^4]: 스크롤 위치를 기억했다가 뒤로가기라고 인지되면 다시 강제로 이동시켜주는 방법 있음
