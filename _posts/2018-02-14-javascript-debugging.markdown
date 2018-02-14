---
published: true
title: 크롬 개발자 도구를 이용한 자바스크립트 디버깅
tags: [Chrome, Devtools, javascript, debug, node]
layout: post
excerpt: 자바스크립트 디버깅 어떻게 하시나요? alert()을 사용하시나요? 아니면 console.log()를 선호하시나요? 크롬 개발자 도구는 일반적으로 알고 있는 것 보다 더 강력한 기능을 제공합니다. 많은 개발자들이 버그로 고생하지만 따로 디버깅을 공부하거나 누군가 자세히 알려주는 경우는 잘 없습니다. 여기 자바스크립트 디버깅의 일반적인 작업흐름과 꿀팁을 소개합니다.
comments: yes
toc: true
last_modified_at: 2018-02-14T09:40:00+09:00
---

자바스크립트 디버깅 어떻게 하시나요? 과거의 저를 포함하여 많은 웹 프론트엔드 개발자들이 소스 사이사이에 `alert()` 또는 `console.log()`를 사용하여 상태를 출력하고 변수를 모니터링 합니다. 이러한 ~~노가다식~~ 디버깅 방식이 널리 퍼진 이유는 자바스크립트의 역사와 관련이 있는데 IE<sup>Internet Explorer</sup>가 인기 있던 시절 IE는 제대로 된 디버그 도구를 제공하지 않았고 로그도 출력할 수 없었기 때문에 어쩔수 없이 경고창을 사용했습니다. HTML에 스크립트 코드를 입력하는 인라인 방식이 널리 쓰였고 모듈화는 자바스크립트랑 거리가 먼 이야기 였습니다.

척박한 개발환경에서 등장한 Firefox의  [Firebug](https://getfirebug.com/) 플러그인은 엄청나게 인기를 끌었고 후에 등장하는 브라우저의 개발자 도구에 많은 영향을 끼쳤습니다. 최근에는 크롬, 파이어폭스, 사파리, IE 등 대부분의 브라우저에서 강력한 개발자 도구를 기본으로 제공하고 있습니다. 

웹 브라우저에 내장된 개발자 도구는 웹이라는 특성에 맞게 로그나 라인 중단점<sup>Breakpoint</sup>을 이용한 디버깅 뿐 아니라 `click`, `submit` 이벤트를 체크 할 수 있고 특정 DOM 객체의 class가 변경되는지 감시하다가 변경 되는 순간 변경을 유발한 소스에 자동으로 중단점을 걸 수도 있습니다.

![Visual Studio Code + Chrome Devtools 조합]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/code_chrome_devtools.gif)

이 글에선 디버깅이란 무엇인지 간단하게 살펴보고 크롬 개발자 도구의 실용적이고 강력한 기능을 3가지 예제와 함께 소개합니다. 그리고 Visual Studio Code(VSCode)와 크롬 브라우저를 연동하는 방법도 알아보겠습니다.

{% googleads class_name: 'googleads-content', ads_id: 'google_ad_slot_2_id' %}

---

## 디버깅이란


![Grace Hopper's 107th Birthday - 나방(버그) 디테일에 주목]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/google-debug-doodle.gif)

버그란 프로그램 내의 결함이나 문제점을 이야기하는 것으로 프로그래밍 언어 COBOL의 개발을 주도한 [그레이스 호퍼](https://ko.wikipedia.org/wiki/%EA%B7%B8%EB%A0%88%EC%9D%B4%EC%8A%A4_%ED%98%B8%ED%8D%BC)가 1945년 Mark II의 오작동 원인을 찾다가 컴퓨터에 나방이 껴있는걸 발견한 것을 최초의 버그라고 기록하고 있습니다.

![역사적인 버그 발견 기록]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/bug.png)

버그를 해결하는 것을 디버깅<sup>debugging</sup>이라고 하고 주요 전략으로 인터렉티브 디버깅, 컨트롤 분석, 유닛 테스트, 통합 테스트, 로그 파일 분석, 모니터링, 메모리 덤프, 프로파일링등이 있습니다. 

> Debugging tactics can involve interactive debugging, control flow analysis, unit testing, integration testing, log file analysis, monitoring at the application or system level, memory dumps, and profiling.
> - from wikipedia

여기선 인터렉티브 디버깅 전략에 대해 알아봅니다.

디버깅을 하기 위해서는 도구가 필요한데 특정 기기/프로그램의 경우 특별한 하드웨어가 필요한 경우도 있지만 웹 어플리케이션은 크롬 개발자 도구와 같이 브라우저에 내장된 무료 소프트웨어를 사용하면 됩니다.

![Xbox Debug Kit]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/Xbox-Debug-Console-Set.jpg)

## 크롬 개발자 도구 (DevTools)

크롬 개발자 도구는 크롬 브라우저에 내장되어 있는 개발관련 도구입니다. 웹 어플리케이션을 개발하고 수정/최적화 하는데 필요한 다양한 기능을 제공합니다. 자바스크립트 디버깅 뿐 아니라 모바일 기기 시뮬레이터, 네트워크 분석, 최적화에 대한 검사도 해줍니다. 전체 기능은 [공식 홈페이지](https://developers.google.com/web/tools/chrome-devtools/)에서 확인하세요.

### 개발자 도구 열기

개발자 도구를 여는 방법은 여러가지가 있습니다. 단축키를 외우는걸 추천합니다.

1. 크롬 브라우저 메뉴에서 `More Tools（도구 더보기）` > `Developer Tools（개발자 도구）` 선택
2. 페이지 빈공간에 오른쪽 버튼 누르고 `Inspect(검사)` 선택
3. MacOS - `⌘`+`⌥`+`I` 또는 Windows - `Ctrl`+`Shift`+`I`
4. MacOS - `⌘`+`⌥`+`J` 또는 Windows - `Ctrl`+`Shift`+`J` (Console 패널)
5. MacOS - `⌘`+`⌥`+`C` 또는 Windows - `Ctrl`+`Shift`+`C` (Elements 패널)

### 주요 패널 소개

디버깅할 때 자주 사용하는 `Elements`, `Console`, `Sources` 패널을 살펴봅니다.

**Element**

![Elements]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtools-elements.png)

주로 디자인을 수정하는 용도로 사용하는 패널입니다. DOM을 확인하고 CSS style을 수정합니다. 특정 DOM의 변화에 중단점을 걸 수 있는 기능이 ~~숨겨져~~ 있습니다.

**Console**

![Console]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtools-console.png)

로그를 확인하고 스크립트 명령어를 입력하는 패널입니다. 중단점을 건 시점의 변수를 확인할 수 있고 값을 평가하거나 수정할 수 있습니다.

**Sources**

![Elements]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtools-sources-edit.png)

자바스크립트 디버깅의 가장 핵심적인 영역입니다. 왼쪽에 파일 관리창과 가운데 소스 에디터, 오른쪽에 디버깅관련 정보창이 있습니다. 창의 크기에 따라 화면 레이아웃이 적절하게 바뀌고 토글 버튼을 누르면 세부창을 열었다 닫았다 할 수 있습니다. 디버깅 정보창 위에 중단점 컨트롤을 이용하여 한땀한땀 코드를 디버깅합니다.

## 본격 자바스크립트 디버깅

예제 소스는 총 3가지 프로젝트(디렉토리)로 구성되어 있고 [https://github.com/subicura/javascript-debugging-example]( https://github.com/subicura/javascript-debugging-example) 에서 다운로드 할 수 있습니다. ~~좋아요 클릭좀~~

[Node.js 8.x](https://nodejs.org/)를 설치하고 소스를 다운로드 후 `npm install`과 `npm start` 명령어를 입력하면 3000번 포트로 웹서버가 실행됩니다.

![예제 화면]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/example-index.png)

- **Basic** 라이브러리를 사용하지 않은 순수 자바스크립트([Vanilla JS](http://vanilla-js.com/)) 사용 예제
- **jQuery** jQuery 라이브러리 사용 예제
- **React** React + Redux TODO app 예제

### Basic Example

아무런 라이브러리를 사용하지 않고 순수 자바스크립트로 작성한 매우 간단한 웹 어플리케이션입니다. 버그를 찾고 한땀한땀 디버깅하는 일련의 흐름을 살펴봅니다.

**1. 버그 찾기**

웹서버를 실행하고 크롬 브라우저로 `http://localhost:3000/vanilla.html`에 접속한 후 이름과 내용을 입력합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-sample.png)

내용이 위에 나오고 이름이 밑에 나오는 걸 기대했는데 결과를 보니 이름과 내용이 반대로 출력되었습니다. 이 버그를 수정해보겠습니다.

**2. 중단점 걸기**

코드를 실행하는 도중에 일시 정지하고 해당 시점의 변수 값을 확인하기 위해 중단점을 걸어보겠습니다. 소스가 익숙하고 어떤함수가 문제인지 안다면 바로 해당 라인에 중단점을 걸 수 있지만 여기서는 소스가 복잡해서 어디에 중단점을 걸어야 할지 모른다고 가정하고 다른 방식으로 접근해보겠습니다.

개발자 도구는 특정 라인이 아닌 글로벌한 이벤트에 대해 중단점을 만들 수 있는데 이름과 내용을 입력하고 폼 전송을 하는 순간을 체크하기 위해 `submit` 이벤트에 중단점을 생성할 수 있습니다. 이제 submit 관련 이벤트가 발생하면 해당 소스에서 멈출겁니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-submit-breakpoint.png)


1. `⌘`+`⌥`+`I` 또는  `Ctrl`+`Shift`+`I`를 입력해서 개발자 도구를 엽니다.
2. `Sources`탭을 선택합니다.
3. 디버깅 정보 창에서 `Event Listener Breakpoints`섹션을 열고 `Control`>`submit`을 체크합니다.

이벤트 중단점을 체크했으면 다시 화면으로 돌아와서 이름과 내용을 입력하고 `Submit` 버튼을 클릭합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-submit-debug-edit.png)

`vanilla-script.js`파일의 `14line`에 소스가 중단되었습니다. 🙀 어떤 파일의 어떤 함수를 수정해야 할지 몰랐지만 submit 이벤트가 발생한다고 추측하고 접근해서 찾았습니다. ~~만세~~

**3. 단계별(step) 코드 실행**

코드를 한줄 한줄 단계별로 실행하면서 스크립트가 어떻게 실행되는지, 변수가 어떻게 저장되어 있는지 확인해 보겠습니다. 디버깅 정보창 위에 `Step over next function call` <img src="{{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/step-over.png" width="20">을 클릭하여 한줄씩 실행합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-step-edit.png)

디버깅 정보창의 Scope 섹션과 소스의 변수명 근처에서 현재 시점의 변수값을 확인할 수 있습니다. `name`과 `message`변수는 정상적으로 할당된 것 같으니 `updatePost` 함수를 살펴봐야겠습니다. updatePost를 호출하는 라인에 디버깅이 멈춰있을 때 `Step into next function call` <img src="{{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/step-into.png" width="10">을 클릭해서 updatePost 함수로 이동합니다.

updatePost함수를 한줄씩 실행해보니 postHtml에 이름과 메시지가 반대로 들어간 것을 알 수 있습니다. `9line`까지 진행합니다.

**4. 콘솔창에서 테스트하기**

콘솔탭을 선택하고 `postHtml`을 입력하면 디버깅이 진행중인 시점의 postHtml 변수값이 출력됩니다. 여기서 변수에 새로운 값을 할당하면 진행중인 변수의 값이 변하게 됩니다. 원래 있던 값을 복사하기 위해 `copy(postHtml)` 명령어를 입력합니다. 마치 텍스트를 드래그 하고 `ctrl(⌘)`+`c`한것처럼 메모리에 내용이 복사됩니다. 다시 내용을 붙여넣기 하고 이름과 내용을 바꿔줍니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-console.png)


`Sources`탭으로 돌아와서 `Resume script execution`<img src="{{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/resume-script-execution.png" width="14">를 클릭하고 디버깅을 끝까지 실행합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-fix.png)

위에 내용이 나오고 밑에 이름이 나오네요. 이름과 내용이 정상적으로 바뀌어서 출력되었습니다!

**5. 소스 수정하기**

Sources창의 에디터에서 코드를 수정합니다. `post.name`과 `post.message`를 바꿔주면 됩니다. 그리고 `Deactivate breakpoints` <img src="{{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/deactivate-breakpoints-button.png" width="15"> 버튼을 클릭해서 활성화 되어 있는 중단점을 비활성화하고 다시 메시지를 입력해 봅니다. 

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-source-edit.png)

짜잔!

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/message-fix-bug.png)

버그를 고쳤습니다. 이제 문제없이 동작하네요! ~~풀리퀘고고~~

> 방금 살펴본 방식은 수정한 내용을 임시로 저장한다는 점에 유의하세요. 새로 고침을 하면 수정전 소스로 원복됩니다.

크롬 개발자 도구의 워크플레이스<sup>workspace</sup>기능을 사용하면 수정한 내용을 로컬 소스에 바로 반영할 수 있습니다. 개발자 도구의 에디터도 문법 하이라이팅<sup>Syntax Highlighting</sup>을 지원하고 자동완성 기능<sup>Auto Completion</sup>을 제공하지만 아직 다른 전용 에디터에 비해서는 기능이 부족합니다. 따라서 뒤에 설명할 VSCode와 연동해서 사용하는걸 추천하지만 간단하게 워크플레이스 기능을 살펴보겠습니다.

**6. Workspace 사용하기**

Workspace는 개발중인 소스 파일을 개발자 도구에 등록하고 브라우저에서 바라보는 네트워크 상의 파일을 연결하여 수정을 편하게 해주는 기능입니다.

예를 들면, `http://localhost:3000/js/vanilla-script.js` 라는 네트워크상의 파일을 로컬의 `/Users/subicura/Workspace/js/vanilla-script.js` 와 연결할 수 있습니다.

Workspace에 폴더를 등록하기 위해 개발자 도구의 Sources탭을 선택합니다. 그리고 왼쪽 파일 네비게이션 창에서 Filesystem 탭을 누르고 `+ Add folder to workspace`를 누르거나 소스 폴더를 드래그 해서 추가해줍니다. 그러면 접근 권한을 묻는 창이 뜨고 `Allow`를 선택해줍니다. 마지막으로 화면을 새로고침하면 맵핑된 파일 아이콘에 연결되었다는 의미의 동그라미가 표시됩니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtools-workspace.png)

단지 폴더만 추가했을뿐인데 개발자 도구가 똘똘하게 `vanilla.html` 파일과 `vanilla-script.js` 파일을 맵핑 하였습니다. 동일한 파일명이 여러개 있어 자동으로 맵핑 되지 않으면 Network의 파일에서 오른쪽 버튼을 누르고 따로 맵핑해주면 됩니다. 잘 안된다면 캐시를 비활성화하고 새로고침해 보세요.

이제 개발자 도구 에디터에서 소스를 수정하면 로컬 개발환경의 소스 파일도 수정됩니다. 새로고침해도 문제없네요!

### jQuery Example

Basic 예제에서 자바스크립트 디버깅의 가장 기본적인 작업 흐름을 살펴보았습니다. 이번에는 좀더 현실적으로 jQuery라이브러리를 사용한 웹 어플리케이션을 다양한 방법으로 디버깅해보겠습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-example.png)

웹서버를 실행하고 크롬 브라우저로 `http://localhost:3000/jquery.html`에 접속합니다. Github ID를 입력하면 정보를 보여주는 웹 어플리케이션입니다.

**Blackboxing**

Basic 예제에서는 라이브러리를 사용하지 않았기 때문에 submit 이벤트를 검사할 때 정상적으로 소스에 중단점이 걸린것을 확인했습니다. jQuery같은 라이브러리를 쓰면 상황이 좀 달라지는데 `$(element).click()`과 같은 코드는 이벤트 생성을 jQuery 라이브러리에 위임하고 실제로  `jquery.js` 파일에서 이벤트가 발생합니다.

테스트를 위해 Event Listener중에 `click`이벤트에 중단점을 생성합니다. 디버깅 정보 창에서 `Event Listener Breakpoints`섹션을 열고 `Mouse`>`click`을 체크하면 됩니다. `Fetch Avatar`를 클릭해볼까요?

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-click.png)

예상대로(?) jquery 파일에 중단점이 걸렸습니다. minified되어 알아볼 수 없는 코드가 보이고 Scope의 변수 또한 아무 의미가 없어보입니다. minified된 코드를 좀 더 이쁘게 바꿔보겠습니다. 에디터 왼쪽 하단에 `{}` 버튼을 클릭합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-pretty-code.png)

뭔가 한줄로 복잡했던 소스가 좀 이뻐지긴 했지만.. 큰 도움이 되지 않습니다. 역시 디버깅은 console.log 밖에 없을까요? ~~안돼~~

개발자 도구에선 이렇게 무의미한 파일을 제외하기 위해 `Blackboxing`이라는 옵션을 제공합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-blackboxing-edit.png)

개발자 도구의 설정을 누르고 왼쪽 메뉴에서 Blackboxing을 선택한 다음 Add pattern..을 클릭하여 `/.*jquery.*\.js$` 패턴을 등록합니다. jquery라는 글자가 들어간 js 파일을 제외합니다.

새로고침을 하고 다시 클릭해 보겠습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-jq.png)

jquery파일이 제외되어 `jq-script.js`파일에 정상적으로 중단점이 걸렸습니다. 이러한 방식으로 react, vue 라이브러리 파일등을 Blackboxing에 등록해서 사용할 수 있습니다.

**Fetch Breakpoint**

이번에는 click 이벤트가 아닌 `github.com에 네트워크 요청이 있을때` 중단점을 걸어보겠습니다.  

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-fetch-edit.png)

디버깅 정보 창에서 `XHR/fetch Breakpoints`섹션을 열고 `+` 버튼을 누른다음에 `github`을 입력합니다. Github ID 입력창에 ID를 입력하고 `Fetch Avatar`를 클릭하면 github이 들어간 주소에 네트워크 요청이 있는 코드에서 중단점이 생성됩니다. 이제 네트워크 요청을 하는 코드가 어디있는지 고민하지 않아도 되겠죠.

**Column Breakpoint**

fetch함수를 자세히 보면 한줄로 길게 연결(chain)되어 있는걸 알 수 있습니다. 어떤 응답 데이터가 오는지 궁금한데.. 한줄내 중간중간열에 중단점을 생성할 수도 있을까요? 일단 디버깅할 라인에 중단점을 체크하면 연결된 함수에 다시 중단점을 걸 수 있습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-inline-edit.png)

`47line`에 중단점을 생성하고 updateGithub 함수 앞에 또 중단점을 생성했습니다. Github ID를 입력하고 Fetch를 하면 중간 중단점에 디버깅이 멈추고 해당 시점의 data 변수값도 확인할 수 있습니다.

**DOM change Breakpoint**

마지막으로 DOM이 변경되었을때 중단점을 생성해보겠습니다. 지금 보는 웹 어플리케이션은 Github의 사용자 정보를 조회하여 `result`라는 ID를 가진 div에 정보를 출력합니다. result div에 중단점을 생성해보겠습니다.

`Elements`탭을 누르고 `result` div를 찾은 다음 오른쪽 버튼을 누르면 `Break on`메뉴와  `subtree modifications` 항목이 보입니다. 해당 DOM의 하위에 값이 변경되면 멈추겠다는 뜻입니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-dom-break-edit.png)

DOM 왼쪽에 동그라미 표시가 된게 보이시죠? 이제 다시 테스트를 해보겠습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/jquery-dom-breakpoint-edit.png)

데이터를 요청하고 화면에 그리는 순간 중단점에 걸립니다. 이제 에디터 전체검색창에 DOM ID를 입력하고 검색결과의 홍수속에서 원하는 소스를 일일이 찾아보지 않아도 됩니다.

### React Example 

마지막 예제는 webpack을 이용하여 소스를 번들링한 최신 트랜드를 반영한 예제입니다. 이전까지 예제는 소스 파일과 브라우저에서 보이는 소스파일이 정확하게 일치했지만 webpack을 사용하면 소스 파일을 bundle.js라는 하나의 파일로 묶기 때문에 소스가 일치하지 않습니다. 이런 경우에도 디버깅이 가능할까요?

브라우저에서  `http://localhost:3000/react.html`에 접속합니다. 개발자 도구를 열고 Sources탭의 파일 네비게이션 창을 봅니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/react-sources-edit.png)

`static/js/bundle.js` 파일외에 webpack으로 번들링 된 소스 파일 목록이 보입니다.  `src/reducers/todos.js`파일의 switch문에 중단점을 걸고 새로운 할일을 등록하면 정확하게 중단점에 멈추는걸 확인할 수 있습니다. 어떻게 된걸까요? 정답은 source map입니다.

**source map**

`bundle.js` 파일의 최하단을 보면 소스맵과 관련된 주석이 있습니다.

{% highlight javascript linenos %}
//# sourceMappingURL=bundle.js.map
{% endhighlight %}

`http://localhost:3000/static/js/bundle.js.map`를 주소창에 입력하면 뭔가 복잡한 파일이 나타납니다. 😱 간략하게 표현하면 다음과 같은 구조로 되어 있습니다.

{% highlight json linenos %}
{
  "version": 3,
  "file": "out.js",
  "sourceRoot": "",
  "sources": ["foo.js", "bar.js"],
  "names": ["src", "maps", "are", "fun"],
  "mappings": "AAgBC,SAAQ,CAAEA"
}
{% endhighlight %}

이 파일을 `source map` 이라고 합니다. 

소스맵은 합쳐지거나 minified된 파일과 원본파일을 연결하기 위해 어떤 소스의 몇번째 줄 몇번째 열이 어떤 소스의 몇번째 줄 몇번째 열과 일치하는지 알려주는 역할을 합니다. ~~너와 나의 연결고리~~ React와 관련된 파일은 엄청나게 많기 때문에 소스맵파일도 엄청나게 클 수 밖에 없습니다. 

> 소스맵에 대해 더 자세히 알고 싶다면 [Introduction to JavaScript Source Maps - HTML5 Rocks](https://www.html5rocks.com/en/tutorials/developertools/sourcemaps/)를 참고하세요.

webpack은 소스맵을 생성할 수 있는 옵션(`devtool`)이 있기 때문에 설정만으로 손쉽게(?) 사용할 수 있습니다. 이러한 방식은 typescript로 작성한 코드에서도 잘 동작합니다.

**Conditional Breakpoint**

Redux에서 reducer는 다양한 action을 처리하는 곳 입니다. 추가/수정/삭제에 대한 action이 들어올 수 있는데 삭제 action만 중단점을 생성해보겠습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtool-conditional.png)

조금 전 생성한 중단점에 오른쪽 버튼을 누르면 중단점을 수정할 수 있고 조건절에 `action.type == 'DELETE_TODO'` 를 입력합니다. 새로운 할일을 등록하면 중단이 안되지만 삭제를 하면 중단점에 걸립니다. 이렇게 중단점에 조건을 걸면 조건에 맞는 요청만 체크할 수 있습니다.

**Store as Global Variable**

마지막으로 특정 React Component에 존재하는 멤버(지역) 변수를 콘솔창에서 자유롭게 테스트 하는 방법을 알아봅니다. 자바스크립트가 모듈화 되면서 콘솔에서 내부에 존재하는 변수에 접근하기 어려워졌지만 다 방법이 있습니다.

개발자 도구에서 `src/components/Header.js`파일을 열고 `handleSave`에 중단점을 만듭니다. 중단점에 걸리면 Scope의 Closure (Header) 섹션에서  `_this` 변수를 오른쪽 버튼 클릭하고 `Store as global variable`을 선택합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/devtools-global.png)

콘솔창을 보면 `temp1`이라는 변수가 생성된 것을 알 수 있고 이제 자유롭게 사용할 수 있습니다. 중단점을 제거 하고 코드로 할일을 생성해 보겠습니다. 콘솔에 `temp1.props.addTodo("Hello world")`를 입력합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/react-console.png)

정상적으로 새로운 할일이 추가되었습니다. 이제 콘솔에서 자유롭게 테스트하세요!

## Visual Studio Code

지금까지 개발자 도구의 다양한 디버깅 기능을 살펴보았습니다. 내장된 에디터도 간단하게 사용하기엔 좋지만 아직 기능이 많이 부족해 보입니다.  코드 작성은 VSCode에서, 중단점 및 테스트는 크롬 브라우저에서 테스트할 수 있게 설정해보겠습니다.

VSCode를 실행하고 다운 받은 소스 디렉토리를 엽니다.

### chrome 확장기능 소개

크롬 브라우저와 연동하려면 `Debugger for Chrome` 확장기능을 설치해야 합니다. VSCode의 확장 탭에서 chrome을 검색하고 설치합니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/debugger-for-chrome-edit.png)

설치가 완료되면 디버그 포트를 오픈한 크롬을 실행할 수 있게 `.vscode/launch.json` 파일을 작성합니다.

{% highlight json linenos %}
{
    "version": "0.1.0",
    "configurations": [
        {
            "name": "Launch Js Debug Example",
            "type": "chrome",
            "request": "launch",
            "url": "http://localhost:3000/",
            "webRoot": "${workspaceFolder}",
            "pathMapping": {
                "src": "${workspaceFolder}/src",
                "js/vanilla-script.js": "${workspaceFolder}/public/js/vanilla-script.js",
                "js/jq-script.js": "${workspaceFolder}/public/js/jq-script.js"
            },
            "skipFiles": [
                "node_modules/*",
                "react-dom*.js"
                "jquery-3.3.1.min.js"
            ],
            "disableNetworkCache": true
        }
    ]
}
{% endhighlight %}

> 설정파일을 보면 대략 어떤 내용인지 유추할 수 있어 자세히 설명하지 않습니다. 옵션에 대한 설명은 [GitHub - Microsoft/vscode-chrome-debug: Debug your JavaScript code running in Google Chrome from VS Code.](https://github.com/Microsoft/vscode-chrome-debug) 여기서 확인할 수 있습니다.

### VSCode Debugger

설정파일을 저장하면 디버깅모드의 실행 목록에 자동으로 추가됩니다. 

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/vscode-debug-edit.png)

플레이 버튼처럼 생긴 `Start Debugging`버튼을 클릭하면 깨끗한 프로필의 크롬 브라우저가 실행됩니다. 디버깅 준비가 완료되었으니 테스트로 `vanilla-script.js` 파일을 열고 updatePost 함수에 중단점을 설정해 보겠습니다.

![]({{ site.url }}/assets/article_images/2018-02-14-javascript-debugging/vscode-debugger.png)

내용을 입력하면 크롬 브라우저와 VSCode 동시에 중단점이 걸리는 걸 볼 수 있습니다. 개발자 도구처럼 한줄한줄 실행할 수도 있고 콘솔을 사용할 수도 있습니다. 개발자 도구와 VSCode가 동기화되서 움직이기 때문에 개발자 도구에 중단점을 생성해도 VSCode에서 확인할 수 있습니다.

이제 VSCode를 사용하면서 크롬 개발자 도구의 강력한 부가 기능도 같이 사용할 수 있습니다.

## 그래서
자바스크립트 디버깅에 대한 자료를 찾아보면서 이렇게 개발자 도구가 좋아졌나 하고 많이 놀랐습니다. 크롬 브라우저는 6주에 한번씩 새로운 버전을 [릴리즈](https://www.chromium.org/chrome-release-channels)하는데 매번 새로운 기능을 추가하고 있습니다. [공식 Youtube 채널](https://www.youtube.com/playlist?list=PLNYkxOF6rcIBDSojZWBv4QJNoT4GNYzQD)에서 새 릴리즈에 대한 내용을 짧게 요약해주니 관심있으면 구독하는걸 추천합니다.

Visual Studio Code 또한 굉장히 빠르게 업데이트 되고 있습니다.(매달 [릴리즈](https://code.visualstudio.com/updates)) Node.js와의 궁합도 좋아 서버를 node로 작성한 경우 서버와 클라이언트를 동시에 스무스하게 디버깅하고 작업할 수 있습니다. 특히 터치바가 장착된 맥북 프로를 사용한다면 디버깅 모드에서 컨트롤이 이쁘게 터치바에 표시되는 걸 볼 수 있습니다.

 `console.log`는 여전히 쓸만하지만 다른 여러가지 방법을 익혀둔다면 디버깅을 더 효율적으로 할 수 있습니다. 그리고 잘 모듈화된 소스, 이해하기 쉽게 지어진 변수명 or 함수명이 더해지면 더더더욱 효과적일거라 생각합니다. 자바스크립트를 이용한 프레임워크는 더욱 복잡해지고 유지보수는 더 어려워집니다. 오늘도 디버깅하느라 고생하는 많은 개발자에 도움이 되길 바랍니다.

개발자 상시 모집중입니다. 연락주세요 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))
