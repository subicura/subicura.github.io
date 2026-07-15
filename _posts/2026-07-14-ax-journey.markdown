---
published: true
title: 개발 자동화에서 조직 AX까지
categories: Development
excerpt: '"배포해줘~" 한마디면 보안 점검 후 내부망에 배포되는 사내 시스템을 완성했습니다. 이를 계기로 돌아본 지난 1년간의 전사 AX(AI Transformation) 여정입니다.'
tags: [AI, AX, Developer, Context, Claude, Data]
layout: post
ogimage: /assets/og/2026-07-14-ax-journey.png
comments: yes
toc: true
---

오랫동안 테스트했던 사내 배포 시스템을 드디어 운영 환경에 배포했습니다.

이제 누구나 AI로 앱을 만들고 공개 범위만 정한 뒤 “배포해줘~”라고 하면, 자동으로 보안 점검을 거쳐 내부망에 배포하고 사내에 공유할 수 있습니다.

이 글은 배포 시스템의 완성을 계기로 돌아본, 지난 1년간의 **전사 AX(AI Transformation) 여정**입니다. 다양한 의견은 언제나 환영합니다 ㅎ

{% googleads class_name: 'googleads-content', ads_id: 'google_ad_slot_2_id' %}

---

## AI의 등장

2025년 초까지 개발하면서 GitHub Copilot이나 ChatGPT, Claude의 도움을 조금씩 받고 있었습니다. 그때까지만 해도 개발은 어디까지나 개발자가 하고, AI는 옆에서 약간의 도움을 주는 보조적인 역할이었습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/claude-code.png %}

그러다가 2025년 하반기, Claude Opus 4.1이 나오면서 엄청난 충격을 받았습니다. AI가 **보조적인 역할에서 완전히 '메인'이 되는 순간**이었습니다. Sonnet과 Opus의 체급 차이는 엄청났고, 난생처음으로 AI 구독에 월 $200짜리 플랜을 2개씩 구매해서 사용하기 시작했습니다. (구독에 $400이라니 말도 안 되게 비싸 보였지만, 개발자 인건비를 생각하면 한없이 혜자스러운 가격입니다.) Claude Code에 너무 감동받아 무려 4년 만에 블로그 글([초보를 위한 Claude Code 안내서](https://subicura.com/2025/09/08/ai-coding.html))을 쓰기도 했습니다. 새롭게 쏟아지는 AI 소식들이 재밌어서 계속 밤샜던 기억이 납니다.

이때부터 AI가 미친 듯이 발전하고 다양한 툴이 쏟아져 나오기 시작했습니다. [Nano Banana Pro](https://blog.google/innovation-and-ai/products/nano-banana-pro/) 한글 품질의 충격, [Typeless](https://www.typeless.com/) 음성인식의 부드러움, 마치 사람처럼 끝까지 요청한 일을 해내는 [OpenClaw](https://openclaw.ai/), 그리고 Claude에서 플러그인을 하나 만들면 [SaaS 업체 주가가 폭락](https://www.thelec.kr/news/articleView.html?idxno=51898)하는 충격까지... 이제 개발을 넘어 모든 업무에 AI를 적용할 수 있게 되었습니다. 그전까지는 메일 초안을 도와주거나 이미지를 생성하는 수준이었다면, 이제는 내가 가진 데이터와 맥락(Context)에 접근하고 실제 액션까지 수행하게 되었습니다.

## 세 가지 시도

2026년 초, 도대체 어디까지 AI를 적용할 수 있을지 궁금했습니다. 그래서 몇 가지 테스트를 진행했습니다.

첫 번째, 개발 업무 중 몇 %를 자동화할 수 있을까?  
두 번째, 기존 시스템을 차세대 버전으로 마이그레이션할 때 얼마나 효율적일까?  
세 번째, 신규 서비스 개발을 얼마나 안정적으로 빠르게 할 수 있을까?  

### 첫 번째, 개발 자동화 테스트 결과는 충격적이었습니다.

제가 일하고 있는 퍼플아이오에서는 Asana를 태스크 관리 시스템으로, GitLab을 소스 저장소로, 배포는 작업별로 Branch를 따는 [GitHub Flow](https://docs.github.com/ko/get-started/using-github/github-flow) 개발 방식을 사용하고 있습니다. Asana에 요청 사항이 들어오면 세부적으로 추가 논의를 하고, 태스크 번호로 Branch를 따서 작업 및 테스트를 거쳐 최종 배포하는 방식입니다. Branch = PR(Pull Request)이 곧 하나의 작업 단위입니다.

자동화 성능 테스트를 위해 최근 완료된 PR 180건을 샘플링해서 Diff 코드를 저장했습니다. 그리고 각 PR의 시작 시점 Git 코드를 가져와서, 오직 Asana 태스크만 보고 사람의 개입 없이 AI에게 PR을 작성하게 했습니다. 그리고 그 결과 Diff를 서로 비교했습니다.

결과는 사람이 작성한 코드와 AI가 작성한 코드의 평균 구현 일치도가 70%였습니다(태스크 설명이 제대로 작성된 구현 가능 PR 110건 기준). 100% 일치한 게 30개(태스크 설명이 상세한 PR의 27%), 90% 이상 거의 일치한 게 38개였습니다.
실패의 원인은 대부분 '태스크 설명이 부실해서'였고, **문제는 AI가 아니라 요구사항 정의**였습니다.

다음은 실제 벤치마크 결과 보고서 일부입니다.

{% picture /assets/article_images/2026-07-14-ax-journey/pr-1.jpg %}
{% picture /assets/article_images/2026-07-14-ax-journey/pr-2.jpg %}
{% picture /assets/article_images/2026-07-14-ax-journey/pr-3.jpg %}
{% picture /assets/article_images/2026-07-14-ax-journey/pr-4.jpg %}


### 두 번째, 기존 레거시 시스템을 그대로 옮기는 것도 충격적이었습니다.

우리가 만든 CMS는 오래된 이슈가 있었습니다. 나름 Next.js에 React 구조였기 때문에 당장 큰 불편함은 없었지만, 한 번 크게 개선해야겠다는 생각은 하고 있었습니다. 보통 이런 작업은 우선순위가 낮아 방치되기 마련인데, AI를 활용해 보기로 했습니다.

AI에게 전체 소스코드 접근 권한을 주고 브라우저로 페이지를 분석하게 했습니다. AI가 브라우저를 띄우고 CMS에 접근한 뒤, 사용자가 로그인할 때까지 기다렸다가 마이그레이션할 페이지들에 접속하여 각 화면과 네트워크 요청을 분석하라고 시켰습니다. 그리고 각 페이지 스크린샷을 찍고 UI 구조, 컴포넌트, 데이터 모델링, API 호출, 상태 관리 등을 정리해 달라고 했습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/ai-analyze-content.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-analyze-plan.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-analyze-data-model.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-analyze-api.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-analyze-component.png %}

보통 AI가 만든 결과가 이상한 건 "내 맘에 안 들어서"입니다. **내 맘에 안 드는 이유는 요청을 모호하게 했기 때문**이고(예: "기획전 관리 기능 만들어줘"), 반대로 '기존 페이지 소스코드와 화면' 자체가 완벽한 기획서가 될 수 있다면 결과는 거의 의도한 대로 나옵니다.

{% picture /assets/article_images/2026-07-14-ax-journey/ai-generate-after-1.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-generate-after-2.png --alt 좌=기존, 우=AI %}

내부 데이터가 있어 전부 공개할 순 없지만, 기본 기능은 완벽하게 동작했습니다. ~~지금 봐도 싱기..~~

이제 코드를 잘 타이핑하는 것보다 기능을 어떻게 명확히 정의하느냐가 더 중요해졌습니다. (Spec이 짱이다!)

이후 내부에서 큰 규모의 차세대 기능 마이그레이션 프로젝트가 있었는데, 기존 계획 대비 절반도 안 되는 리소스로 완료하고 안정적으로 운영 중입니다. 가장 시간이 많이 걸린 건 코딩이 아니라 기존 로직을 .md 파일로 정리하고 테스트 케이스를 빠짐없이 짜는 작업이었습니다.

### 세 번째, 신규 서비스 개발도 충격적이었습니다.

요구사항(Spec)만 잘 정의하면 구현은 원하는 대로 나왔기 때문에, 신규 시스템 구축도 훨씬 효율적으로 할 수 있었습니다.

기존에 요구사항 분석 -> 기획 -> 설계 -> 구현 -> 데모라는 긴 과정이 있었다면, 이제는 요구사항을 받자마자 그걸 세계 최고 수준의 전문가(넌 글로벌 탑티어 회사의 기획자야!)가 기획하고 개발까지 완료해서 첫 미팅부터 동작하는 데모를 보여주고 피드백을 받는 게 가능해졌습니다.

요구사항(3-4줄)을 받으면 그걸 바탕으로 PRD(제품 요구사항 정의서)를 만들고, 그 파일을 바탕으로 기능 명세를 정의한 뒤, 기능별 페이지, UI/Component, API/모델 설계, 사용자 Flow를 한 번에 생성하라고 했습니다. 그걸 사용자가 검토하고 승인하면 그대로 Ralph Loop으로 밤새 코드를 짭니다. 명세 보고 구현하고 제대로 짰는지 체크하고 다시 검증하라고 하면 구현만 6시간 정도 걸렸던 것 같습니다. ~~나는 잘 테니 넌 일해라~~

{% picture /assets/article_images/2026-07-14-ax-journey/ai-gen-task.png --alt Ralph Loop 작업의 흔적. build 1회 / 검증 3회를 돌렸다. %}

아래 화면은 그렇게 매장관리 시스템 초안을 잡은 모습입니다. (모두 가상 데이터입니다.)

{% picture /assets/article_images/2026-07-14-ax-journey/ai-plan.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/ai-plan-after.png %}

첫 미팅 때 **이미 동작하는 화면을 보고 이야기하니 개선이나 방향성을 잡기** 훨씬 쉬웠습니다. 최종 완성 버전은 초기와 달라졌지만, 이 역시 기존 계획 대비 절반의 리소스로 구현했고 AI 분석 기능을 추가하여 더 강력한 기능을 제공하게 되었습니다.

## 전사적 선언

AI 성능에 강한 확신~~3 충격~~을 얻고 2026년 초, 회사의 방향을 AX로 정의했습니다. 밥 먹는 거 빼고 모오오오든 업무를 자동화하고 연말까지 인당 생산성을 200% 올리는 걸 목표로, 개인과 조직이 일하는 방식을 완전히 바꾸기로 했습니다.

1. AI가 못하는 일은 거어어어의 없어질 것이다.
   * 코딩을 몰라도 많은 업무를 일정 수준 이상 자동화할 수 있습니다.
   * 개발뿐 아니라 문서 작성, 분석, 운영, 배포, 데이터 처리까지 자동화의 대상이 됩니다.
2. 앞으로는 맥락(Context)이 핵심 자산이 될 것이다.
   * 나의 생각과 암묵지를 끊임없이 글로 남겨야 합니다.
   * 내가 본 PPT, 문서, 자료를 markdown으로 저장해야 합니다.
   * 팀과 맥락을 공유하고, 그 맥락 위에서 AI와 함께 일해야 합니다.
   * AI는 맥락을 쉽고 효과적으로 모을 수 있게 도와줘야 합니다.

일단 단기적으로(한 달 내에) 할 수 있는 것부터 해보자고 사내 AI 챌린지(Quick Win)를 열었습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/quickwin-purpleio.png %}

[홈 — Purple IO AI Quick Win](https://quickwin.purple.io/)

총 28개의 프로젝트가 등록됐고, 참가자들은 평균 83%의 업무 시간 절감 효과를 확인했습니다.

이걸 진행하면서 다시 한번 느낀 건, 정말 **그냥 "해줘"라고 하면 다 해준다**는 점입니다.

비개발자는 평소에 사용하던 CRM에서 지원하지 않던 기능(사이트 주소를 입력하면 스크립트를 분석해서 어떤 솔루션을 쓰는지 파악하고, 영업 리드 점수를 계산해 제안 메일 초안까지 써주는 기능)을 직접 만들었습니다.

개발자는 에러 알람이 오면 상세 로그를 뒤지고 관련 코드를 찾던 귀찮은 삽질을, AI가 1차 원인 분석을 끝낸 걸 확인만 한 뒤 승인하는 환경을 갖추게 되었습니다.

AI는 평소 하던 작업을 더 빠르게 하는 걸 넘어, 평소엔 생각도 못 했던 작업까지 가능하게 만들었습니다.

AI가 로컬에 있는 .md 파일을 읽고 해석하는 능력이 컨플루언스보다 낫다고 판단해 사내 정보를 옵시디언(Obsidian)에 모으기로 했습니다. 이때 가장 어려운 점은 비개발자분들에게 Git을 가르치는 일이었습니다. 누구나 문서를 작성하고 공유해야 하는데 Git CLI는 너무 높은 장벽이었습니다.

그래서 5분에 한 번씩 알아서 pull/push를 하고, 충돌이 나면 별도 파일로 쪼개어 머지 컨플릭트를 방지하는 옵시디언 플러그인을 만들었습니다. 옵시디언 플러그인 개발은 처음이었는데 AI 덕분에 몇 시간 만에 뚝딱 완성했고 문제없이 잘 쓰고 있습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/second-brain-plugin.png %}

[https://github.com/subicura/second-brain-plugin](https://github.com/subicura/second-brain-plugin)

또한 모바일 환경에서도 끊김 없이 Claude Code 작업을 하고 싶어서 터미널과 AI 코딩 기능이 포함된 Mac 애플리케이션(PurpleMux)도 만들었습니다. 난생처음 만져보는 Electron에 터미널 에뮬레이터, tmux 연동까지 AI가 아니었으면 불가능했을 겁니다. 무려 11가지 언어를 지원하는데, 어느새 중국인 사용자도 생겼습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purplemux.png %}

[https://subicura.com/purplemux](https://subicura.com/purplemux)

지금 개발팀은 상상하던 모든 툴을 붙여 코딩의 완전 자동화를 꿈꾸고 있습니다.

지금 이 시간에도 새로운 프로젝트가 등록되고 있습니다..

<details>
<summary>진행중인 자동화 프로젝트 보기</summary>

<div markdown="1" style="padding-top: 10px">

**Purple Pipeline**: Asana로 태스크가 인입되면 파이프라인 큐에 쌓이고, 기획자 -> 아키텍트 -> 디자이너 -> 개발자 -> 리뷰어 -> 배포자 등의 페르소나를 조합하여 업무를 끝까지 처리합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purple-pipeline.png %}

**Purple Test**: E2E 테스트를 실행하고 과정을 녹화해서 결과를 확인합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purple-test.png %}

**Purple Gauge**: 성능 테스트 자동화 툴입니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purple-gauge.png %}

**Purple Auth**: 사내 SSO 및 중앙 인증/세션 관리를 담당합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purple-auth.png %}

**MeetNote**: 화자 구분이 가능한 로컬 회의록 녹음 및 옵시디언 플러그인입니다.

{% picture /assets/article_images/2026-07-14-ax-journey/meetnote.png %}

</div>
</details>


## 확산과 허들

개발팀 특성상 AI를 빨리 접했기 때문에, 자연스럽게 함께 일하는 현업 부서의 업무를 AI로 도와주기 시작했습니다. 반복 업무는 자동화 프로그램을 만들었고, 우리가 일하는 방식(Claude Code)도 그대로 전파했습니다.

그런데 문제는 시작부터 터졌습니다. Windows 환경에서 cmd를 난생처음 보는 분에게 Claude Code를 가르치는 건 생각보다 훨씬 어려웠습니다. 설치하고, cmd가 뭔지 설명하고, cd로 디렉토리를 이동하는 법을 알려주는 데 교육 시간의 대부분이 날아갔습니다. 이렇게 좋은 툴이 있는데 시작조차 못 하는 상황, 상상도 못한 허들이었습니다.

그래서 툴을 바꿨습니다. 구글이 만든 IDE인 [Antigravity](https://antigravity.google/)였습니다. 에디터 형식이라 GUI 기반이고 AI Assistant를 지원하기 때문에 초보자도 바로 활용할 수 있었습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/antigravity.png %}

이 방법은 대성공이었고 초기 허들을 크게 낮출 수 있었습니다. 여기서 자연스럽게 Claude Code와 cmd 환경으로 넘어오고, 내부 데이터에 접근할 수 있는 커스텀 스킬을 배포하자 사내 자동화 앱과 대시보드가 폭발적으로 늘기 시작했습니다.

기존에는 단순 매출 흐름만 보여줬던 대시보드에서, 특정 쇼핑몰에서의 순위와 최근 리뷰도 모아서 보여주고, 경쟁사 인기상품도 보여주고 별도로 찾고 수작업했던 작업을 하나의 화면에 모아서 보여줍니다. 현업이 직접 만들기 때문에 뭐가 필요한지 더 잘 알고 더 유용하게 쓸 수 있습니다.

엑셀을 눈으로 비교하던 단순 작업이나, 매일 사람이 확인하고 지시했던 업무들이 자동화되기 시작했습니다. 가장 기분 좋은 피드백은 "4\~5시간 걸리던 수작업인데, 아침에 출근하면 이미 완료되어 있어요"입니다.

개발자 수준의 'AI 챔피언'들이 탄생하고 있습니다.

## 진짜 문제는 따로 있었다

하지만 판이 커지다 보니 공통적인 문제가 보였습니다. 잘 쓰는 사람은 어느새 알아서 잘하고 있지만, 그렇지 못한 많은 분들에게 여전히 허들이 남아있었습니다.

* Windows 중심의 업무 환경
* M365 / OneDrive 기반의 분산된 업무 방식
* 내부 시스템 연동을 위한 까다로운 인증/기본 설정
* 그리고 **배포**의 어려움

한 땀 한 땀 개발자가 도와주면 되지만 거기엔 한계가 있습니다. 결국 스스로 자생할 수 있어야 합니다.

그래서 QuickWin 때 만들었던 [DocSync](https://quickwin.purple.io/cases/14-docsync/)를 전면 개조하기 시작했습니다. 기본 AI Assistant 기능 위에 사내 환경에서 쓰기 좋은 것들을 하나씩 붙여 **사내 AI 플랫폼 '코코(KOCO)'**를 만들었습니다. Claude /Claude Cowork와 거의 유사하며 최대한 사용자들이 쉽게 사용할 수 있게 설계하고 개발도 최소화했습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/koco-main.png %}

사내 업무에 최적화되어 있고

{% picture /assets/article_images/2026-07-14-ax-journey/koco-weather.png %}

시각화도 이쁩니다.

주요 특징은 다음과 같습니다.

* 개발 도구(nodejs) 내장, 별도 설치 필요 없음
* OneDrive / 메일 / 캘린더 연동 (묻고 답하고 생성까지)
* SAP 등 내부 데이터베이스 연계, 그룹웨어(전자결재, 지원관리 등) 연계
* 스킬 및 워크플로우 공유
* 바이브 코딩부터 사내망 배포까지 한 번에

메일, 공유 드라이브의 파일을 싱크하고 SQLite에 색인하고 암호화해서 보관합니다. 일반 사용자가 보안 걱정 없이, 복잡한 설정 없이 업무를 자동화하고 바이브 코딩까지 할 수 있게 되었습니다. 약 80명을 대상으로 3개월간 테스트하며 뜨거운 피드백을 받았고, 계속해서 업데이트 중입니다.

{% picture /assets/article_images/2026-07-14-ax-journey/koco-guide.png --alt KOCO 교육자료 %}

다양한 방식으로 쓰고 있지만 최근 좋은 사례 하나만 꼽자면 '경영 정보 Agent'입니다.

재무 관련 데이터를 xlsx로 받고 월간 보고서를 한 디렉토리에 모읍니다. 그러면 커스텀 llm-wiki가 대용량의 xlsx를 [DuckDB](https://duckdb.org/)에 밀어 넣고 컬럼 메타데이터를 설정한 뒤, 월간 보고서는 .md로 변환해서 인덱싱합니다. 이 디렉토리를 OneDrive 공유 폴더로 만들고 담당자들이 공유받습니다. 그다음 KOCO에서 프로젝트를 만들고 "이 디렉토리를 보고 경영 정보를 알려줘"라고 지침을 넣으면 끝입니다. 최근 지표나 이슈를 물어보면 아주 정확하게 뽑아냅니다. 원래 내가 가지고 있는 파일을 기반으로 조회하는 거라 권한 이슈도 없습니다. ~~개이득~~.

그리고 여기서 가장 신경 쓴 기능 중 하나가 '배포'입니다. 바이브 코딩이 늘어날수록 "이거 팀에 공유하고 싶은데요"라는 요청이 점점 커져갔기 때문입니다.

## 배포

드디어 이번 글의 메인 주제입니다.

요구사항은 간단했습니다. ~~하지만 설정은 귀츈..~~

1. 내부망에 배포할 것
2. 배포 전에 보안 검토(Security Review)를 받을 것
3. 사용자별로 인증하고, 공유 범위(전체 / 일부 사용자 / 비공개)를 설정할 수 있을 것

최종 아키텍처는 다음과 같습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/purple-access.jpg %}

먼저 배포 대상이 될 사내 EKS(Kubernetes) 환경을 구축했습니다. 배포 파이프라인은 별도 솔루션을 도입하지 않고 GitLab CI/CD를 그대로 썼습니다.

사용자가 "배포해줘~"라고 하면, 현재 로그인한 사용자 아이디로 GitLab에 연동 로그인하고 랜덤한 이름의 프로젝트를 생성한 뒤 파일을 전부 올립니다. 그러면 자동으로 빌드되고 배포까지 이어집니다.

{% picture /assets/article_images/2026-07-14-ax-journey/koco-vibe.png %}

앱을 만들고 배포 요청을 합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/koco-database-1.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/koco-database-2.png %}

데이터베이스는 기본 SQLite이고 /data 폴더를 persistence volume으로 설정했습니다.

보안 검토도 여기에 얹었습니다. CI/CD 파이프라인 중간에 보안 스캔 단계를 넣었고, 검토가 완료되면 Slack으로 알람이 옵니다. 실제 배포는 담당자가 한 번 더 확인하고 승인합니다. ~~완전 자동은 아직 좀 불안; ㅎ~~

{% picture /assets/article_images/2026-07-14-ax-journey/koco-deploy.png %}
{% picture /assets/article_images/2026-07-14-ax-journey/koco-gitlab.png %}

내부망 배포까지는 잘 됐는데, 마지막 퍼즐은 인증이었습니다. 전체 공개가 아니라 비공개로, 혹은 특정 사람에게만 공유하는 권한 제어 기능이 필요했습니다.

수많은 앱들마다 일일이 인증 코드를 넣으라고 가이드를 만들까 하다가 [Cloudflare Access](https://www.cloudflare.com/ko-kr/sase/products/access/)를 소개받았습니다. "오! 프록시처럼 동작하니까 모든 트래픽이 무조건 저길 거치게 하면 되는구나."

그래서 'Purple Access'라는 자체 프록시 레이어를 만들었습니다. 이제 EKS의 Ingress ALB는 Pod을 직접 바라보지 않고 Purple Access를 바라봅니다. 인증이 안 되어 있으면 로그인 창을 띄우고, 로그인하면 접근하려는 앱에 대한 권한이 있는지 체크합니다. 있으면 통과, 없으면 block. 모든 접근은 감사 로그로 남습니다.

{% picture /assets/article_images/2026-07-14-ax-journey/koco-public.png %}

예전 같으면 이런 리버스 프록시 엔진을 직접 만든다는 건 꽤 골치 아픈 일이었겠지만, 이 또한 AI의 도움으로 며칠 만에 간단히 해결했습니다.

이렇게 배포 기능이 완성되었습니다. 바이브 코딩을 하고, 공개 범위를 정하고, "배포해줘~"라고 하면 보안 점검 후 내부망에 배포되고 사내에 공유됩니다. 

## **앞으로**

처음에는 AI가 개발을 더 빠르게 해주는 도구라고 생각했습니다. 하지만 지난 1년 동안 가장 크게 바뀐 것은 개발 속도가 아니었습니다.

문제를 정의하는 방식이 바뀌었고, 지식을 남기는 방식이 바뀌었으며, 함께 일하는 방식이 바뀌었습니다.

특히 가장 크게 느낀 것은 **맥락(Context)** 의 중요성입니다. AI는 생각보다 코드를 잘 작성하고 문서를 잘 정리합니다. 하지만 왜 이런 기능이 만들어졌는지, 어떤 배경에서 의사결정을 했는지, 앞으로 어떤 방향으로 발전해야 하는지는 결국 조직이 남긴 맥락에서만 찾을 수 있었습니다.

그래서 우리는 다음 단계들을 준비 중입니다. **없는 데이터는 모으고, 모으는 맥락은 더 정확하게 만들고, 서로 연결하는 것.**

* 데이터 맵을 만들어 가시성을 높인다. 연계는 데이터가 중요한 것부터 우선순위대로.
* 비정형 데이터가 이메일과 로컬 PC에서 죽지 않도록, 업무의 input/output이 자연스럽게 마크다운 형태로 쌓이도록 프로세스를 리팩토링한다.
* 부족한 맥락은 업무 흐름을 개선하거나 신규 시스템을 구축한다.

기존 시스템을 살짝 개선 = 전자결재 AI 스크리닝 및 검수/제안 단계만 보완해도 의미있는 맥락을 데이터로 모을 수 있다고 생각합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/ai-doc.png %}

AI는 앞으로도 계속 발전할 것입니다. 하지만 그 AI를 얼마나 잘 활용할 수 있는지는 결국 조직이 얼마나 자신의 지식과 맥락을 축적하고 연결할 수 있는지에 달려 있다고 생각합니다.

{% picture /assets/article_images/2026-07-14-ax-journey/obsidian-graph.png --alt 내 옵시디언 그래프. 그냥 이뻐서 넣어봄 %}

지난 1년 동안 우리가 만든 것은 여러 개의 AI 도구와 하나의 배포 시스템이었습니다. 하지만 그 과정에서 정말 바뀐 것은 도구가 아니라 일하는 방식이었습니다.

이제 우리는 사람이 모든 일을 직접 처리하는 조직이 아니라, **사람이 남긴 맥락 위에서 AI가 함께 일하는 조직**을 만들고 있습니다. 아직 완성된 답은 없지만, 방향은 분명합니다.

다음 글에서는 이 여정이 다양한 산업군에서 어떤 모습으로 이어지고 있는지 이야기해 보겠습니다.
