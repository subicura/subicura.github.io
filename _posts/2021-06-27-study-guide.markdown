---
published: true
title: 초보 웹 개발자를 위한 학습 안내서
categories: Talk
excerpt: 개발자로 취업을 준비 중이거나 좀 더 성장하고 싶은 초보 개발자를 위한 내용을 담고 있습니다. 그동안의 경험과 이력서를 검토하고 면접을 진행하면서 느낀 점, 개발자로 취업을 준비 중인 사촌 동생에게 했던 조언, 개인적으로 멘토링을 하면서 했던 이야기를 모았습니다.
tags: [Beginner,Developer,Study]
layout: post
ogimage: /assets/og/2021-06-27-study-guide.png
comments: yes
toc: true
---

{% picture /assets/article_images/2021-06-27-study-guide/interview.jpg --alt 경력있는 신입 --a class="small-image" --img style="max-width: 500px" %}

많은 회사가 개발자가 부족하다고 하는데, 신입 개발자는 취업이 어려운 게 현실입니다. 아무래도 예전보다 개발자에게 원하는 요구사항이 많아졌고, 경력 있는(?) 신입이나 특별한 교육이 필요 없는 개발자를 찾기 때문인 것 같습니다.

예전에~~라떼~~는 Git이나 GitHub 같은 버전 관리 시스템도 없고 JavaScript는 마우스 오버 시 버튼의 이미지 바꾸는 정도로만 사용했습니다. API는 Win32 API 같은 거 부를 때 쓰는 말이지 지금처럼 브라우저에서 동적으로 서버랑 통신하는 건 마법 같은 기술이었습니다.

WEB 2.0 시대가 지나고 웹 기술이 폭발적으로 성장하면서 예전이랑은 비교할 수 없을 만큼 시스템이 복잡하고 고도화되었습니다. 빠르게 발전한 기술만큼 개발자가 공부해야 할 내용도 많아졌고, 예전보다 신입 개발자에게 원하는 수준이 훨씬 높아졌습니다. 

다행인 것은 개발환경이나 학습환경도 예전과 비교할 수 없을 만큼 좋아졌다는 것입니다. 서버는 클릭 한 번으로 만들 수 있고 컴파일하는 시간~~커피타임~~도 수백 배는 빨라졌습니다. 수많은 온/오프라인 강의와 초고수 개발자들의 노하우를 지하철에서 배울 수 있게 되었습니다.

이글은 이러한 흐름 속에서 개발자로 취업을 준비 중이거나 좀 더 성장하고 싶은 초보 개발자를 위한 조언을 담고 있습니다. 그동안의 경험과 이력서를 검토하고 면접을 진행하면서 느낀 점, 개발자로 취업을 준비 중인 사촌 동생에게 했던 조언, 개인적으로 멘토링을 하면서 했던 이야기를 모았습니다. 

이 글이 더 좋은 개발자로 성장하는 데 도움이 되길 바라고, 혹시 내용에 공감하고 괜찮은 개발회사를 찾고 있다면 [우리 회사에 지원](https://purple.io)하셔도 좋습니다. 제가 잘 교육해드림.. 🙇‍♂️

<p align="center">
    <a href="https://purple.io" target="_blank"><img src="{{ "/assets/article_images/2021-06-27-study-guide/purpleio_bookmark.png"  | prepend: site.baseurl  }}" style="width: 420px"></a>
</p>

{% googleads class_name: 'googleads-content', ads_id: 'google_ad_slot_2_id' %}

---

## 어떤 개발자가 있나요?

웹 개발 기준으로 크게 프론트엔드<sup>frontend</sup>, 백엔드<sup>backend</sup>, 인프라(DevOps) 개발자가 있고 앱(iOS, Android), 게임, 머신러닝/AI, 데이터분석 쪽도 별도로 구분합니다.

예전엔 뭔가 이렇게 구분하지 않고 개발자면 이것저것 다 ~~사무실 랜선도 깔고~~ 했는데 점점 기술이 고도화되고 새로운 개발 방식, 각종 라이브러리/프레임워크가 끊임없이 나오면서 전체를 다 하기가 어려워졌습니다. 물론, 전체를 두루두루 하는 풀스택이라는 ~~전설 속의~~ 직군이 있긴 하지만 드문 케이스입니다.

프론트엔드나 백엔드등 특정 방향을 정하고 한 우물을 파는 게 바람직하지만, 협업하고 무언가를 만들려면 다른 분야를 이해하고 기본적인 내용은 익혀두는 것이 좋습니다. 결국, A를 잘하려면 B를 이해해야 하고 B를 잘 이해하려면 C가 도움이 되기 때문입니다.

> 큰 회사(일명 네카라쿠배)는 특정 분야의 전문가(=스페셜리스트)를 원하는 경우가 많고 스타트업이나 작은 회사일수록 동시에 여러 가지를 하는 사람(=제너럴리스트)을 원하는 경우가 많습니다. 제너럴리스트는 자칫 잡부처럼 느껴질 수 있지만, 성장에 도움이 된다면 여러 가지 경험을 하는 것도 나쁘지 않다고 생각합니다.

## 어떤걸 공부할까요?

### 웹 개발자 학습 로드맵

{% picture /assets/article_images/2021-06-27-study-guide/intro.png --alt intro --link https://roadmap.sh/ %}

[![]({{ site.url }})](https://github.com/kamranahmedse/developer-roadmap/tree/master/translations/korean)

[Kamran Ahmed가 만든 웹 개발자 로드맵](https://github.com/kamranahmedse/developer-roadmap/tree/master/translations/korean)은 웹 개발자가 되기 위해 선택하고 거쳐야 할 기술을 프론트엔드, 백엔드, 데브옵스별로 나누어 제공합니다. 필수적인 내용이 빠짐없이 정리되어 있고 최신 트랜드가 포함되어 있어 어떤 걸 공부할지 갈피를 못 잡고 있다면 방향을 잡기에 좋습니다.

{% picture /assets/article_images/2021-06-27-study-guide/frontend.png --alt frontend --link https://roadmap.sh/frontend %}

프론트엔드를 살펴보면 인터넷, HTML/CSS/JavaScript부터 패키지 관리자, React와 같은 프레임워크, CSS 프레임워크를 거쳐 서버사이드 렌더링, 정적 사이트 생성기, 웹어셈블리까지 정리가 되어 있습니다. 깔-끔

{% picture /assets/article_images/2021-06-27-study-guide/backend.png --alt backend --link https://roadmap.sh/backend %}

백엔드는 인터넷, 프론트엔드 기본 지식(?!), OS에 대한 전반적인 지식, 언어, 데이터베이스, 캐시, CI/CD, 컨테이너, 웹서버를 소개합니다. 역시 깔-끔

{% picture /assets/article_images/2021-06-27-study-guide/legend.png --a class="small-image" --img style="max-width: 350px" %}

항목마다 중요도가 표시되어 있는데, `추천/개인적인 의견` 항목은 조금 더 자세히 공부하고 `대체 가능한 옵션`은 적어도 어떤 기술인지 기본적인 내용은 알아두는 것이 좋습니다. `선택사항`이나 `추천하지 않음` 항목은 반드시 공부해야 하는 건 아니고 이런 게 있구나! 정도는 알면 좋을 것 같습니다.

**너무 공부할게 많아요 ㅠㅠ 🤦**

로드맵 내용은 학습할 수 있는 모든 것을 담고 있기 때문에 초보 입장에서는 당연히 부담스러울 수 있습니다. ~~언젠가 다 알면 좋지만..~~ 제한된 시간에 모든 걸 공부하는 건 불가능하기 때문에 몇 가지를 깊이 이해하는 것이 중요합니다. "내가 시간이 없어서 그렇지 깊게 파면 이렇게 잘할 수 있다!"라는 걸 어필할 수 있다면, 회사 입장에서도 "뽑은 다음에 키우면 되겠다"라고 생각할 수 있습니다.

예를 들어, React.js를 사용하는 회사에서 React.js, Vue.js, Angular를 전부 얕게 아는 사람과 Vue.js를 깊이 이해하는 사람이 있다면 후자를 더 좋게 평가할 것입니다. 후자는 무언가를 잘 할 수 있다는 확실히 능력을 보여주었지만, 전자는 알 수 없기 때문입니다. 

### 코딩테스트

"코딩테스트 준비는 얼마나 해야 하나요?" 코딩테스트 공부가 재미없고 시간이 아깝다고 생각하는 분들에게 많이 듣는 질문입니다.

코딩테스트는 크게 알고리즘형과 제시된 프로그램을 구현하는 프로젝트형이 있습니다. 알고리즘형 코딩테스트를 하는 이유는 보통 지원자가 너무 많기 때문에 효율적으로 평가하기 위함입니다. 코딩테스트의 실효성에 대해서는 여러 가지 의견이 있지만, 특정 수준 이상의 코딩테스트를 통과하면 기본적인 문제해결 능력이 있다고 판단하는 거죠.

요즘은 대부분의 회사가 코딩테스트를 진행하기 때문에 실무와 별개로 따로 준비해야 합니다. DFS/BFS와 같은 그래프 탐색 알고리즘을 공부하고 유명한 자료구조를 이해해야 합니다. 보통 코딩테스트 사이트에서 수십~수백 개의 문제를 푸는데, 더 깊게 공부할지는 지원하는 회사의 요구사항이나 난이도에 따라 다릅니다. 가고 싶은 회사가 높은 수준을 요구하면 그만큼 준비해야 하는 거죠 뭐;

> 개인적으로 알고리즘형 코딩테스트는 개발자의 지극히 일부만 평가할 수 있어 좋은 평가 방식은 아니라고 생각하지만, 적어도 정답을 보고 공부하면 해당 알고리즘을 이해하고 간단하게 구현할 수 있는 수준은 되어야 합니다. 나중에 필요할 때 찾아서 할 수 있는 것과 해보지 않은 것은 차이가 있기 때문입니다.

코딩테스트를 준비하다 보면 실무와 크게 상관없다고 느끼고 학습 자체가 지루할 수 있습니다. 코딩 테스트가 의미 없어 보이고 나는 뚝딱뚝딱 무언가를 만드는 게 좋다면, 재미있는 부분에 더 집중하고 알고리즘보다 프로젝트형 코딩테스트를 보는 회사에 지원하는 것도 방법입니다.

다음은 코딩테스트를 준비할 수 있는 사이트입니다.

{% picture /assets/article_images/2021-06-27-study-guide/baekjoon_bookmark.png --alt Baekjoon Online Judge --link https://www.acmicpc.net/ --a class="small-image" --img style="max-width: 420px" %}

> 국내 서비스 중 가장 유명한 온라인 코딩테스트 서비스 / 수많은 프로그래밍 문제를 풀고 온라인으로 채점 받을 수 있음

{% picture /assets/article_images/2021-06-27-study-guide/programmers_bookmark.png --alt 프로그래머스 --link https://programmers.co.kr/ --a class="small-image" --img style="max-width: 420px" %}

> Kakao/Line/Naver 등 많은 회사에서 사용 중인 코딩테스트 서비스

{% picture /assets/article_images/2021-06-27-study-guide/leetcode_bookmark.png --alt LeetCode --link https://leetcode.com/ --a class="small-image" --img style="max-width: 420px" %}

> 글로벌에서 가장 유명한 코딩테스트 서비스

### 기본기

고도화되고 추상화된 라이브러리, 프레임워크가 많아지면서 포트폴리오는 훌륭한데 그에 비해 기본 지식이 부족한 경우가 있습니다. 기본 지식이라고 하면 흔히 "컴퓨터 관련 전공자"가 배우는 CS 커리큘럼과 언어, 프레임워크의 동작 원리 등입니다.

조금 더 구체적인 예를 위해 22년 동안 개발자 지원 서류를 수천 건은 검토하고, 면접을 최소 일천 번 이상 보신 [남세동님께서 작성하신 기초 질문들](https://www.facebook.com/dgtgrade/posts/3654195844639255)을 볼까요? 


{% picture /assets/article_images/2021-06-27-study-guide/question.png --alt 남세동님 글 --link https://www.facebook.com/dgtgrade/posts/3654195844639255 %}

1. 1바이트는 몇 비트인가요?
2. 1픽셀은 몇바이트인가요?
3. 2^10은 얼마인가요?
4. Stack과 Queue의 차이가 뭔가요?
5. Binary Tree의 시간 복잡도가 어떻게 되나요?
6. DNS의 역할이 무엇인가요?
7. HTTPS와 HTTP의 차이는 뭔가요?
8. 스마트폰 카메라 해상도가 (대강) 어떻게 되나요?
9. 왜 사진에는 JPG를 쓸까요?
10. 칼라값 ffffff는 무슨 색인가요?
11. \<a href\>가 무슨 뜻인가요?
12. call by reference가 무슨 말인가요?
13. Event Listener가 무슨 말인가요?
14. OOP에서 상속이 무슨 말인가요?
15. non-blocking call이 뭔가요?
16. 버전관리에서 commit이 뭔가요?
17. try/catch는 무슨 뜻인가요?
18. 디버깅 할때 breakpoint가 뭔가요?
19. 패스워드는 서버에 어떻게 보관되나요?
20. SSD가 HDD보다 빠른 이유가 뭔가요?

개발에 관심이 있고 꾸준히 공부한 사람인지를 판단하기 굉장히 좋은 질문이라고 생각합니다. 이러한 질문에 대답하기 위해 따로 공부한다면 "어떻게 준비하지..?" 라는 생각이 듭니다. 2의 10승을 일부러 외우진 않지만, 개발을 하다보면 1024, 2048, 4096, 65536 같은 거가 익숙하단 말이죠. ~~Hex 에디터의 추억?~~

기본기를 익히는 것은 아쉽게도 지름길이 없습니다. 내용이 너무 방대하고 따로 CS 학습을 하려면 시간이 부족하기 때문에, 평소에 틈틈이 호기심을 가지고 더 많이 찾아보고 더 깊이 학습하는 방법이 최선인 것 같습니다.

예를 들어, 자주 사용하는 `rand()` 함수를 그냥 사용만 하지 않고, "0, 1밖에 모르는 컴퓨터가 어떻게 "랜덤"한 숫자를 임의로 고르는 걸까?", "진짜 랜덤한가?", "특정 조건에서 원하는 값을 구할 수 없을까?" 하고 궁금할 수 있습니다. Hash/Map 같은 구조(`data['key'] = value`)를 쓰다 보면 "이런 데이터는 메모리에서 어떻게 관리될까?" 궁금할 수 있습니다. 일반적인 배열은 0, 1, 2, 3 순차적으로 저장이 될 텐데 key는 순서랑 상관없는 문자열이기 때문에 뭔가 다르게 저장될 것 같은 거죠. 미리 메모리 영역을 잡아 놓을까? 어느 정도 크기로 잡을까? 중복은 어떻게 처리하지? 같은 궁금증이 막 생기죠? ~~나만 생기나요? ㅠㅠ~~ React를 공부하고 있다면 "이런 라이브러리를 처음부터 만들려면 어떻게 해야 할까?" 하고 원리를 궁금해할 수 있습니다.

다행히 요즘은 인터넷에 검색하면 상세한 답변을 쉽게 찾을 수 있어 지하철을 타고 이동하거나 중간중간 짬이 나는 시간에 호기심을 해결하다 보면 자기도 모르게 기본 지식을 쌓을 수 있습니다.

## 어떻게 공부하는 게 좋을까요?

지금까지 무엇을 공부할지 이야기했고 어떻게 공부할지 알아보겠습니다.

### 클론코딩

{% picture /assets/article_images/2021-06-27-study-guide/clone.jpg --alt Clone Coding %}

클론코딩은 페이스북, 트위터 같은 서비스를 따라 만들면서 배우는 학습 방법입니다. 내가 사용하는 서비스를 내 손으로 직접 만들면서 오는 흥미와 실용적인 방법, 포트폴리오로 제출하기도 좋아 많이 사용하는 방법입니다.

처음 이력서에 클론코딩 내용이 있으면 신기하면서(신입이 이걸??) 높게 평가했는데 어느 순간 공장에서 찍어서 나오는 것 같은 느낌을 받고 뭔가 이상하다고 느낀 적이 있습니다. 그 시점에 많은 온/오프라인 강의와 학원에서 클론코딩을 하고 있다는 걸 알았고 이력서에 적힌 클론 코딩 항목의 신뢰가 떨어지게 되었습니다.

클론 코딩 자체는 좋은 학습 방법이라고 생각하는데, 강사의 코드를 거의 그대로 복사하거나 직접 만들었다고 하는데 특정 부분을 물어보면 잘 모르는 경우가 문제였습니다. 단순히 결과물만 보여주기보다는 그걸 만들면서 어떤 걸 배웠고 어떤 게 어려웠는지, 그걸 어떻게 해결했는지 정리하는 것이 필요합니다. 멋진 기술을 쓰고 결과물이 아무리 좋더라도 스스로 한 것인지 도움을 받은 것인지 알 수 없기 때문에 과정이 궁금할 수밖에 없습니다.

그리고, 그 과정에서 최소 하나 이상 깊게 고민한 기능/기술이 있으면 좋습니다. 모방은 창조의 어머니라고 하지만 모방만으로 끝나서는 의미가 없습니다.

예를 들면, 이미지를 업로드 하는 기능에 리사이즈 기능을 추가한다던가, 영상을 업로드하면 gif로 변환한다던가, 소셜 공유 기능을 넣고 OpenGraph 이미지를 생성하는 라이브러리를 붙여본다던가, 무엇이 되었든 새로운 기능이 있어야 합니다.

### 토이프로젝트/사이드프로젝트

{% picture /assets/article_images/2021-06-27-study-guide/side_project.png --alt Toy Project %}

아주 작은 아이디어 & 프로그램을 처음부터 끝까지 만들고 실제 운영까지 해보는 작업입니다. 재미도 있고 새로운 기술도 배우고, 혹시 모르면 추가적인 수입이 있을 수도.. 👀

먼저 결정할 것은 혼자 할지, 팀을 만들어서 할지 인 데 개인적으로는 혼자 작은 사이즈로 만드는 것을 추천합니다. 좋은 팀을 만드는 것도 어렵지만, 만들었다고 하더라도 중간에 먼저 취업이 되거나 개인 사정으로 팀원들이 빠지면 결국 완성이 안 되고 흐지부지되는 경우가 많기 때문입니다.

혼자서 풀 스택 경험을 해보면 내가 어떤 분야에 관심이 있고, 어떤 기술을 싫어하는지, 좋아하는지 파악할 수 있습니다. 만약 프론트엔드가 너무 재미없고 집중이 안 된다면 명확하게 선을 긋고 백엔드에 집중할 수도 있습니다. 문제는 만들면서 내가 잘하고 있는 게 맞나..하는 생각이 들 수 있는데, 일단 기능을 만드는 것에 집중하고 문제가 생기면 자연스럽게 구글링 등을 하면서 해결해가는 것이 좋습니다. 너무 고민이 된다면 페이스북 그룹이나 커뮤니티, twitter 등에 문의하면 됩니다. 깊게 고민하고 질문을 한다면 그만큼 좋은 대답을 들을 수 있습니다.

토이 프로젝트를 완성하여 오픈 소스화하거나, 직접 운영을 하고 개선해 나간다면 실력도 쌓고 취업에서도 좋은 평가를 받을 수 있습니다.

### 스터디 모임

개인적으로 "좋은 스터디" 모임에서 "좋은 사람들"과 함께 학습하는 것만큼 좋은 건 없다고 생각합니다.

한참 새로운 기술에 목마르던 꼬꼬마 시절, "데브 스터디"라는 스터디 모임을 페이스북을 통해 접했는데, 혼자서는 알 수 없던 최신 프론트 개발 트랜드를 익히고 또 다른 스터디(도커, 쿠버네티스)까지 확장할 수 있던 너무 소중한 시간이었습니다. (그때 처음 스터디한 Grunt, Yeoman, Bower는 이제 사라진 기술이 되었네요 😅)

스터디 모임의 장점은 혼자 하면 학습하기 어려운 것들을 빠르게 습득할 수 있다는 것과 여러 사람의 노하우를 자연스레 습득할 수 있다는 점입니다. 내가 우물 안 개구리였다는 것도 알게 되고 이렇게 잘하는 분들이 많구나 하는 자극을 받아 더 열심히 할 수 있습니다.

제가 속했던 스터디 모임은 우연히 다음과 같은 공통점이 있었습니다.

- 개발에 대한 열정 🔥
	1. 스터디 모임이 끝나도 커피를 마시며 몇 시간 동안 개발 얘기 함
	2. 지하철 타고 가면서도 개발 얘기 함;
	3. 단톡방에서도 개발 얘기 함;;
- 스터디 방식 📖
	1. 약 10회 분량의 주제를 정하거나 한 권의 책을 정함
	2. 1주일 동안 다 같이 공부하고 노션에 정리 (공동 편집)
	3. 당일 발표자 선정 - 내가 발표할 수도 있다는 부담감으로 열심히..!
	4. 발표 중 막히는 부분은 서로서로 도와주고 더 자세히 아는 내용이 있으면 추가 공유

**모각코**

모각코는 "모여서 각자 코딩"의 약자로 약간 가벼운 버전의 스터디 모임입니다.~~만 코로나 때문에...~~ 부담 없이 참석하여 질문/답변을 할 수 있고 좋은 분을 만날 수도 있으니 스터디가 부담스러우면 추천합니다.

다음은 스터디 모임/모각코를 찾을 수 있는 서비스입니다.

{% picture /assets/article_images/2021-06-27-study-guide/okky_study_bookmark.png --alt OKKY - 정기모임/스터디 --link https://okky.kr/articles/gathering --a class="small-image" --img style="max-width: 420px" %}

{% picture /assets/article_images/2021-06-27-study-guide/fb_study_bookmark.png --alt 페이스북 - 모각코 --link https://www.facebook.com/search/top/?q=%EB%AA%A8%EA%B0%81%EC%BD%94 --a class="small-image" --img style="max-width: 420px" %}

### 온라인 강의

요즘 학습 환경의 가장 큰 특징은 고품질의 온라인 강의를 쉽게 접할 수 있다는 것입니다. 예전에는 돈 주고도 들을 수 없던 여러 가지 노하우를 고오오급 개발자분들이 틈틈이 시간을 내어 강의를 만들어주신 덕분에 집에서 편하게 들을 수 있게 되었습니다.

온라인 강의는 제한된 시간에 핵심적인 내용 위주로 설명하는 경우가 많기 때문에 빠르게 무언가를 익히기엔 좋지만 깊게 이해하기엔 부족할 수 있습니다. 온라인 강의로 감을 잡고 공식문서와 관련 책을 학습하여 좀 더 깊게 이해하는 것이 좋습니다.

요즘 부쩍 온라인 강의 서비스들이 많아졌는데, 경험했던 서비스 위주로 소개합니다.

{% picture /assets/article_images/2021-06-27-study-guide/open_bookmark.png --alt 생활코딩 --link https://opentutorials.org/course/1 --a class="small-image" --img style="max-width: 420px" %}

> 초보자를 대상으로 개발의 기초가 되는 부분을 자세히 설명해줌

{% picture /assets/article_images/2021-06-27-study-guide/tacademy_bookmark.png --alt T 아카데미 --link https://tacademy.skplanet.com --a class="small-image" --img style="max-width: 420px" %}

> 인공지능, 데이터 사이언스, 프로그램 관련 양질의 강의를 무료로 들을 수 있음

{% picture /assets/article_images/2021-06-27-study-guide/inflearn_bookmark.png --alt 인프런 --link https://www.inflearn.com/ --a class="small-image" --img style="max-width: 420px" %}

> 부담 없는 가격에 유명 강사의 고퀄리티 강의가 많음 / 제가 만든 <a href="https://www.inflearn.com/course/도커-입문?inst=446961aa" target="_blank">도커</a>와 <a href="https://www.inflearn.com/course/쿠버네티스-입문?inst=bc9bb710" target="_blank">쿠버네티스</a> 강의도 들어보세요 ~~중간광고~~

### 컨퍼런스

컨퍼런스는 최신 트랜드를 알 수 있고 실무를 하면서 고민고민고민했던 내용을 빠르게 습득할 좋은 기회입니다. 예전엔 보통 오프라인으로 컨퍼런스를 열고 ~~맛있는 밥과 기념품도 주고~~ 관련 업체 부스를 탐방하는 재미가 있었는데 최근엔 코로나의 영향으로 대부분 온라인으로 진행하고 있습니다.

컨퍼런스는 좋은 내용이 많지만, 너무 전문적이고 광범위한 경우가 많아, 처음부터 끝까지 보는 것보단 고민했던 내용, 지금 하고 있는 것과 관련이 있는 것을 잘 골라서 보는 것이 좋습니다.

{% picture /assets/article_images/2021-06-27-study-guide/kakao_junior.png --alt ifkakao - 직장인 VLOG %}

> 꼭 전문적인 기술만 발표하지 않습니다. 초보 개발자를 위한 내용도 많이 있어요~

🤔 그런데 말입니다... 이상하게도 지나간 컨퍼런스는 잘 안 보게됩니다 ㅠㅠ. (왜 그런지 아시는 분?) 그래서 컨퍼런스를 한다고 하면 가급적 시간을 내어 라이브로 참석하는 것을 추천합니다. 그래야 더 집중해서 보고 참석률도 높은 것 같습니다.

주요 컨퍼런스는 다음 링크에서 확인하세요!

{% picture /assets/article_images/2021-06-27-study-guide/44bits_conf_bookmark.png --alt 2020 한국의 주요 IT 컨퍼런스 다시 보기 --link https://www.44bits.io/ko/post/replay-2020-korea-it-conferences --a class="small-image" --img style="max-width: 420px" %}

### 책

책의 인기가 예전보다 많이 시들해진 것 같지만, 훌륭한 선배들의 생각과 노하우를 익히기엔 역시 책만한게 없습니다. 개인적으로 추천하는 책은 다음과 같습니다.

**기본 소양**

{% picture /assets/article_images/2021-06-27-study-guide/44bits_conf_bookmark.png --alt 2020 한국의 주요 IT 컨퍼런스 다시 보기 --link https://www.44bits.io/ko/post/replay-2020-korea-it-conferences --a class="small-image" --img style="max-width: 420px" %}


<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/x9JEa3oM" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_grow.jpeg --alt 함께 자라기 - 애자일로 가는 길 (김창준/인사이트) %}</a>
</div>

> 성장, 협업, 학습에 대한 나의 태도를 바꿀 수 있는 영향력 있는 책

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/xC6bAhpf" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_pragmatic.jpeg --alt 실용주의 프로그래머 (앤드류 헌트 외/인사이트) %}</a>
</div>

> 그냥 개발자에서 뼛속까지 개발자가 될 수 있는 여러가지 팁 소개

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/GUv7ZV1t" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_refactoring.jpeg --alt 리팩터링 (마틴 파울러/한빛미디어) %}</a>
</div>

> 더 나은 코드를 작성하고 싶다면 반드시 읽어야 하는 필독서

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/FOvDgE7f" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_pattern.jpg --alt Head First Design Patterns (에릭 프리먼/한빛미디어) %}</a>
</div>

> 입문자를 위한 디자인 패턴 교과서

**자기개발**

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/xcKZRRzU" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_craftsmanship.jpg --alt 소프트웨어 장인 - 프로페셔널리즘, 실용주의, 자부심 (산드로 만쿠소/길벗) %}</a>
</div>

> 소프트웨어 장인의 실용적인 조언

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/FOvDgE7f" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_softskill.jpg --alt 소프트 스킬 (존 손메즈/길벗) %}</a>
</div>

> 개발자로 사는 데 도움이 되는 정보와 조언을 집약적으로 담은 안내서

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/x8lS0YKj" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_joel.jpg --alt 조엘 온 소프트웨어 (조엘 스폴스키/에이콘) %}</a>
</div>

> 조엘의 블로그에서 인기글만 뽑아 엮은 책. 우리회사는 조엘 테스트 몇점일까?

<div class="small-image" style="max-width: 200px">
    <a href="http://naver.me/5HSi9BL9" target="_blank">{% picture /assets/article_images/2021-06-27-study-guide/book_unix.jpeg --alt 유닉스의 탄생 (브라이언 커니핸/한빛미디어) %}</a>
</div>

> 유닉스가 무엇인지, 어떤 이유로 개발 되었는지, 어떤 과정을 거쳐 발전했는지 정말 생생하게 느낄 수 있는 책

{% picture /assets/article_images/2021-06-27-study-guide/book_painter.jpg --alt 해커와 화가 (폴 그레이엄/한빛미디어) --link http://naver.me/FEJTzTMe --a class="small-image" --img style="max-width: 200px" %}

> Y Combinator의 폴 그레이엄의 에세이 형식의 프로그래밍 이야기

{% picture /assets/article_images/2021-06-27-study-guide/book_founder.jpg --alt 세상을 바꾼 32개의 통찰 (제시카 리빙스턴/크리에디트) --link http://naver.me/GROTg4au --a class="small-image" --img style="max-width: 200px" %}

> 지금은 사라진 서비스도 있지만, 21세기를 바꾼 서비스가 어떻게 만들어졌는지 알 수 있는 책

{% picture /assets/article_images/2021-06-27-study-guide/book_http.jpeg --alt HTTP 완벽 가이드 (데이빗 고울리 외/인사이트) --link http://naver.me/GZAryBoT --a class="small-image" --img style="max-width: 200px" %}

> HTTP 규약이 어떻게 작동하고 웹 기반 애플리케이션을 개발하는 데 어떻게 사용하는지 소개하는 책

{% picture /assets/article_images/2021-06-27-study-guide/book_test.jpg --alt 테스트 주도 개발 (켄트 벡/인사이트) --link http://naver.me/5mYNQ5sJ --a class="small-image" --img style="max-width: 200px" %}

> 테스트 주도 개발의 교과서

{% picture /assets/article_images/2021-06-27-study-guide/book_extreme.jpg --alt 익스트림 프로그래밍 (켄트 벡/인사이트) --link http://naver.me/F7C0TKU5 --a class="small-image" --img style="max-width: 200px" %}

> XP의 소개와 철학 안내

이 외에도 좋은 책이 많지만, 너무 길어지는 것 같아 별도 페이지로 공유합니다.


{% picture /assets/article_images/2021-06-27-study-guide/mysetting_book_bookmark.png --alt mysetting - 책소개 --link https://mysetting.io/books --a class="small-image" --img style="max-width: 420px" %}

### 유투브

유투브는 많이 안보지만.. 알고 있는 몇 가지 채널을 추천합니다.

{% picture /assets/article_images/2021-06-27-study-guide/youtube_44bits.png --alt 44bits - 인프라 전문 방송 --link https://www.youtube.com/channel/UC-TpdzGorF3igglmjCWQhMA --a class="small-image" --img style="max-width: 420px" %}

{% picture /assets/article_images/2021-06-27-study-guide/youtube_gae.png --alt 개발바닥 - 본격 개발자 토크쇼 --link https://www.youtube.com/channel/UCSEOUzkGNCT_29EU_vnBYjg --a class="small-image" --img style="max-width: 420px" %}

{% picture /assets/article_images/2021-06-27-study-guide/youtube_john.png --alt 존잡생각 - 솔직담백 실리콘벨리 이야기 --link https://www.youtube.com/channel/UCSqtYUDXgy7RmpMazTMFSHQ --a class="small-image" --img style="max-width: 420px" %}

{% picture /assets/article_images/2021-06-27-study-guide/youtube_nomad.png --alt 노마드코더 --link https://www.youtube.com/channel/UCUpJs89fSBXNolQGOYKn0YQ --a class="small-image" --img style="max-width: 420px" %}

### 팟캐스트

이동 중일 때 편하게 들으세요. 개발 팟캐스트는 44bit를 추천합니다 :)

{% picture /assets/article_images/2021-06-27-study-guide/podcast_44bits.png --alt 44BITS 팟캐스트 - 클라우드, 개발, 가젯 --link http://stdout.fm/ --a class="small-image" --img style="max-width: 420px" %}

### 트위터

가장 핫한 트랜드 소식을 빠르게 접할 수 있는 트위터입니다. 막상 팔로우하면 개발 이야기 말고 잡담을 많이 들을 수도 있습니다만...

{% picture /assets/article_images/2021-06-27-study-guide/twitter_subicura.png --alt @subicura - 저에요 🙋‍♂️ 팔로우~ --link https://twitter.com/subicura --a class="small-image" --img style="max-width: 420px" %}

{% picture /assets/article_images/2021-06-27-study-guide/twitter_korean_developer.png --alt Korean Developers List --link https://twitter.com/i/lists/1391902781192110080 --a class="small-image" --img style="max-width: 420px" %}

## 디테일을 높이자

마지막으로 조금만 더 디테일을 높여봅니다. 이왕 공부하는 거 조금 다른 시각으로 살펴볼까요?

### 차별화하기

취업/이직을 준비 중이라면 내가 가진 능력을 잘 포장하고 표현하는 것도 중요합니다. 면접관은 독심술사가 아니기 때문에; 표현하지 않으면 모르지 않겠습니까?

이력서에 적을 수 있는 내용은 다음과 같습니다.

- 학력 및 학과
- IT 관련 직무나 IT 회사에서 일한 경력 (인턴 등)
- 진행한 프로젝트 소개 (포트폴리오 및 토이 프로젝트)
- 블로그
- 오픈소스 경력

여기서 학력 및 학과, 경력은 쉽게 바꿀 수 없지만, 나머지는 노오오력으로 차별화 할 수 있습니다. 2가지 이력서가 있을 때 어느 쪽이 더 인상 깊을까요?

{:.table}
항목|A 이력서|B 이력서
프로젝트 경력|TODO 앱 개발<br />- React+Redux 사용|TODO 앱 개발<br />- https://todo.subicura.com<br />- AWS lightsail 배포<br />- 완료 날짜를 입력하고 날짜가 다가오면 web push 전송
블로그|https://subicura.tistory.com<br />- 단순 지식 정리 (링크소개?)<br />- 글이 거의 없음|https://blog.subicura.com<br />- 왜? 어떻게?와 같은 과정이 담긴 글들<br />- 최근 까지 꾸준히 작성
오픈소스|(없음)|nodejs web push xx 이슈 수정

프로젝트 경력을 보면 B는 토이 프로젝트 개발 후 직접 배포하고, 개인 도메인을 구매하여 연결한 것을 알 수 있습니다. web push라는 새로운 기술을 시도한 것도 보입니다. 블로그를 보니 B는 GitHub Page에 Gatsby로 정적페이지를 생성해서 만들었네요. ~~(지금 상황극 하는 겁니다)~~ 내용을 보니 프로젝트를 진행하면서 고민했던 내용과 해결책이 어떤 건지 잘 알 수 있습니다.

사실 A도 프로젝트 배포할 줄 아는데 귀찮아서 안 했던 거고, 개인 도메인도 몇 번 클릭하면 연결되는 걸 알지만 귀찮아서 안 했던 것일 수 있습니다. 평가하는 입장에서는 그런 속사정을 모르기 때문에 드러나는 것으로 평가하게 되고 일단은 B에 호감을 가지고 면접을 시작하게 될 것입니다.

같은 작업을 하더라도 조금만 더 신경 쓰면 남과 다른 내용을 추가할 수 있습니다.

### 기록하기

블로깅이나 노트 정리를 하세요. 공부한 걸 기록하는 과정을 통해 잘 이해되지 않은 부분을 한 번 더 찾게 되고 나중에 같은 삽질을 반복하는 것을 줄여줍니다.

블로그는 내가 이런 걸 공부하고 있고 이렇게 성장하고 있다는 걸 보여주는 도구로 활용할 수 있기 때문에 잘 정리된 블로그는 평가에서 엄청나게 유리합니다.

이해하기 쉽게 블로그 내용을 점수로 표현해보면 다음과 같습니다.

- 제목 한 줄 + 링크 한 줄 (0점)
- 공부한 내용 블로그에 정리하기 (+1점)
- 관심 있는 항목을 좀 더 깊이 공부하고 장/단점과 실제 사용 후기 정리하기 (+5점)
- 각각의 기술을 조합하여 무언가를 만들고 내용 정리하기 (+10점)

> 다른 사람이 작성한 글을 찾고 싶다면 [velog](https://velog.io)를 추천합니다. 좋은 글이 가득~

### 추가 팁

**잘 물어보세요.**

생각보다 질문은 어렵습니다. 그렇기 때문에 잘 물어보는 것이 중요합니다. 좋은 질문은 좋은 답변을 들을 수 있습니다.

-  [빠르고 정확하게 답변을 받을 수 있는 질문하는 법](https://blog.2dal.com/2020/04/01/%EB%B9%A0%EB%A5%B4%EA%B3%A0-%EC%A0%95%ED%99%95%ED%95%98%EA%B2%8C-%EB%8B%B5%EB%B3%80%EC%9D%84-%EB%B0%9B%EC%9D%84-%EC%88%98-%EC%9E%88%EB%8A%94-%EC%A7%88%EB%AC%B8%ED%95%98%EB%8A%94-%EB%B2%95) 
-  [실력이 좋은 개발자는 좋은 질문을 한다](https://brunch.co.kr/@codestates/4) 
-  [질문을 잘하는 개발자](https://jbee.io/essay/good_questionor/) 
-  [커뮤니케이션과 질문 (질문의 두려움 극복하기)](https://shinsunyoung.tistory.com/111) 

**목표를 정하자**

주간 또는 월간으로 명확한 목표와 기간을 정합니다. 대부분의 사람은 일정이 없으면 느슨해지고 오늘 할 수 있는 일을 내일로 미루게 됩니다.

- 노션이나 사용하는 노트에 목표와 기간을 적고 진행한 내용을 정리하세요.
- 주기적으로 진행한 내용을 확인하고 회고하세요.
- 너무 빡빡한 일정보다는 적당히 할 수 있는 목표를 정하고 조금씩 늘려가세요.

**환경을 바꿔보세요**

공부가 힘들고 번아웃이 올 수 있습니다. 그럴 때는 환경을 한번 바꿔보세요.

- 제주도 / 강원도 등 완전 새로운 공간에서 혼자 여행을 가서 개발해보세요.
- 인터넷이 안 되는 곳에 컴퓨터 없이 책만 들고 가보세요. 새로운 내용을 발견할 수도 있어요.

## 회사 선택하기

어떤 회사가 좋은 회사일까요?

만드는 제품이 좋은 회사? 월급 많이 주는 회사? 개발 환경이 좋은 회사? 구성원들이 좋은 회사? 발전 가능성이 높은 회사? 사람마다 좋은 회사의 기준이 달라 명확하게 말하기 어렵지만, 피해야 할 회사는 어느 정도 기준이 있습니다.

양파님의 [초보 개발자에게 - 이런 데에서 일하지 말자 1](http://theonion.egloos.com/5768506) 글을 보면 다음과 같은 내용이 있습니다.

* 버전 컨트롤 시스템이 없다
* Automated deploy system, build system 이 없다
* 모니터링 시스템이 없다
* 테스터가 없거나, 테스팅 environment, staging environment 가 없다
* 유닛 테스트를 안 쓰고, 코드 리뷰가 없다
* 버그 트랙킹 시스템이 없다
* 개발자에게 웹 디자인을 시킨다든지, 하드웨어 서포트를 요구한다

피해야 할 조건이라고 하지만, 위 조건을 하나도 만족하지 않는다면 꽤 괜찮은 개발 회사라고 생각해도 좋을 것 같습니다.

개인적으로 하나 더 항목을 추가하고 싶습니다.

- 새로운 시도를 할 수 없고 문제가 생기면 개인에게 책임을 전가한다.

애초에 실수가 생기지 않도록 회사 시스템이 갖추어져 있고 실수가 생기더라도 회고<sup>postmorterm</sup>를 통해 개선하려는 의지가 있는 회사에서 일하면 더 빨리 성장할 수 있습니다. 개인에게 책임을 묻는 순간, 문제가 생기지 않기 위해 어려운 일은 피하게 되고 잘못을 숨기면서 거짓말하는 문화가 생길 수 있습니다. 비난이 아닌 건설적이고 실용적인 피드백이 필요합니다.

다니고 있는 회사가 마음에 안 든다면 바로 이직을 고려하는 것보단 내부에서 조금씩 바꾸려는 노오오오력을 하는 것도 좋습니다. 문제가 있다고 느끼는 부분을 고민하고 누구도 반박하지 못할 해결책을 내가 스스로 준비한다면, 나도 발전하고 회사도 성장할 기회가 될 수 있습니다. ~~아니라면.. 탈출..~~

주위에 여러 개발자분들의 이야기를 들어보면, 이상적인 (저 회사 가면 엄청 재밌고 창의적인 작업을 할 수 있겠지?) 회사는 어디에도 없고 지속 가능하지 않다고 느낍니다. 회사와 구성원이 모두 노력하고 계속해서 더 나아진다면 좋은 회사라고 생각합니다.

##  그래서

사실, 이미 고여있는 개발자라서 초보 개발자의 마음을 100% 이해할 수 없지만, 아무쪼록 도움이 되길 바라며 글을 작성해보았습니다. 요즘 함부로 조언하지 말라는 이야기가 있는데 부디 꼰대처럼 보이지 않았으면 좋겠어요. 👏

마지막으로, "지금 내가 뭐 하는 거지? 잘하고 있는 건가?" 라고 생각한다면, 지금보다 앞으로 **성장할 수 있다는 것이 중요**하다는걸 알았으면 좋겠습니다. 멈추지 않고 나아간다면 언젠가는 원하는 바를 이룰 수 있을 거예요.

마지막으로 한번더, 퍼플아이오에서 적극적으로 채용을 하고 있습니다. 열정 있는 신입/경력 개발자를 찾습니다. 구경 오세요~!

{% picture /assets/article_images/2021-06-27-study-guide/purpleio_bookmark.png --link https://purple.io --a class="small-image" --img style="max-width: 420px" %}

---

`AD` 기술, 개발 환경, 이력을 모아 나만의 프로필을 만들고 개발 관련 팁을 쉽게 공유하고 널리 알릴 수 있는 개발자들을 위한 서비스는 없을까?

{% picture /assets/article_images/2021-06-27-study-guide/mysetting.png --link https://mysetting.io --a class="small-image" --img style="max-width: 420px" %}
</div>
