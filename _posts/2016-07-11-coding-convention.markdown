---
published: true
title: linter를 이용한 코딩스타일과 에러 체크하기
excerpt: 홈쇼핑처럼 6번째 상품인 까르보돈까스는 부먹과 찍먹을 선택해야 합니다. 코딩도 둘중에 하나를 선택해야 하는 경우가 많은데 협업을 위해 코딩 스타일을 설정하고 규칙에 어긋난 코드를 한땀한땀 수정했던 순간이 떠올라 linter에 대해 이야기합니다.
tags: [Coding, Lint]
layout: post
comments: yes
toc: true
fb_social_baseurl: http://subicura.com
last_modified_at: 2017-01-21T10:00:00+09:00
---

![돈까스먹는용만이x까르보돈까스]({{ site.url }}/assets/article_images/2016-07-11-coding-convention/carbo.jpg)

[홈쇼핑처럼](https://www.likehs.com) 6번째 상품인 [까르보돈까스](https://www.likehs.com/tvprogram/index/view/id/27/)는 부먹과 찍먹을 선택해야 합니다. 코딩도 둘중에 하나를 선택해야 하는 경우가 많은데 협업을 위해 코딩 스타일을 설정하고 규칙에 어긋난 코드를 한땀한땀 수정했던 순간이 떠올라 linter에 대해 이야기합니다.

<p align="center">
<img src="{{ site.url }}/assets/article_images/2016-07-11-coding-convention/civil_war.jpg" alt="시빌워" title="시빌워" />
</p>

[코딩스타일](https://en.wikipedia.org/wiki/Programming_style), 코딩 표준이라고도 불리는 [코딩 컨벤션](https://en.wikipedia.org/wiki/Coding_conventions)은 코드를 작성할 때 추천하는 코딩 스타일, 괜찮은 사례등을 모아 놓은 가이드라인입니다.

`if`에 중괄호({)는 다음 줄에 쓰는게 좋을까요, 같은 줄에 쓰는게 좋을까요? 띄어쓰기는 스페이스랑 탭중에 어떤걸 쓸까요? 스페이스를 사용한다면 2칸? 4칸? 8칸? 몇칸을 띄우는 나을까요? 정답은 없지만 어떤게 인기 있는지는 [여기](http://sideeffect.kr/popularconvention/#java)서 언어별 대세를 확인해 볼 수 있습니다.

코딩 컨벤션은 표준이라고 하지만 꼭 지켜지 않아도 프로그램은 잘 동작하고 이 방식이 좋은지 저 방식이 좋은지 백날 싸워도 결론이 없는 딱히 신경 쓰지 않아도 크게 문제 없어 보이는 가이드라인입니다.

이러한 코딩 컨벤션과 에러 체크를 도와주는 툴을 linter라고 합니다.

## 문제는 유지보수

과거의 많은 고오급 개발자들은 개발하는 시간의 반이상이 유지보수를 하는데 쓰인다는걸 알았습니다. 미래의 내가 현재의 나를 욕하지 않고 레거시가 내거시가 되어 나를 괴롭히지 않으려면 유지보수가 쉽도록 코드를 작성해야합니다.

유지보수가 쉽고 버그가 없는 코드를 작성하려면 많은 경험과 노력이 필요합니다. 어떻게 하면 코드의 품질을 높일 수 있을까..라고 많은 개발자들이 고민했고 정량적으로 코드를 분석할 수 있는 정적분석과 동적분석용 툴을 만들고 테스트 코드를 작성하는 방법을 생각합니다.

**[정적분석](https://en.wikipedia.org/wiki/Static_program_analysis)**

정적분석은 프로그램을 실행하지 않고 코드를 분석하는 방법입니다.

코드를 보면 띄어쓰기나 줄바꿈이 이상한 부분을 발견할 수 있고 메소드가 너무 길거나 변수명 형식이 어떤건 언더바(form_value) 어떤건 카멜케이스(formValue)로 오락가락하면 통일하는게 좋습니다. 상수로 사용하는 변수는 변경되지 않도록 하는게 버그를 예방할 수 있기 때문에 `final`로 선언하는게 낫고 사용하지 않는 변수나 함수는 지우는게 나중에 코드를 볼때 훨씬 편합니다. 한 클래스는 적절한 수의 메소드를 가지고 있어야 하고 if문을 사용할때는 너무 복잡하게 중첩하면 무슨 내용인지 이해하기가 어렵죠.

이렇게 **느낌적**으로 알고 있는 내용을 모아모아모아서 고급 개발자들이 코딩컨벤션, 예상결함방지, 코드복잡도 메트릭스등의 이름으로 정리하였고 다양한 툴들이 유/무료로 제공되고 있습니다. 

**[동적분석](https://en.wikipedia.org/wiki/Dynamic_program_analysis)**

동적분석은 실제로 프로그램을 실행해보고 취약점을 분석합니다.

메모리에 릭이 발생하거나 쓰레드가 꼬이는 문제는 실제로 프로그램을 실행하지 않으면 발견하기가 어렵습니다. 앱 개발자들은 한참 앱을 사용하다가 죽으면 아.. 어디선가 메모리가 세고 있다는걸 **느낌적**으로 알고 있습니다. 이러한 때에 메모리누수 체크툴을 사용하면 실시간으로 메모리 사용량을 프로파일링해주고 어떤 변수가 문제가 있는지를 표로 정리해서 보여줍니다. [Xcode](https://developer.apple.com/xcode/)와 [Android Studio](http://developer.android.com/tools)에서 관련 기능을 제공하고 있기 때문에 릴리즈 하기전에 메모리 누수등을 체크해보면 예상치 못한 곳에서 결함을 발견할 수 있습니다.

**[테스트](https://en.wikipedia.org/wiki/Software_testing)**

테스트는 다양한 방법이 존재하고 여러가지 방식으로 코드가 정상적으로 동작하는지 검사합니다.

어떤 메소드를 아무리 잘 설계하고 코드를 잘 작성했다고 하더라도 해당 메소드에 대한 테스트 코드가 없다면 검증 및 유지보수가 어렵습니다. 대부분의 유명한 오픈소스들은 기능을 추가하는 코드를 풀 리퀘스트하게 되면 테스트 코드도 같이 작성해 달라고 요청을 합니다. 테스트 코드가 없으면 추가되는 기능을 검증하기 위해 일일이 수작업으로 체크를 해야하고 나중에 소스가 수정되었을 때 어떤 영향을 미치는지 알 수가 없게 됩니다. 운좋게 동작하는 라이브러리를 만드는게 아니라면 테스트코드는 필수 입니다.

**[기술부채](http://martinfowler.com/bliki/TechnicalDebt.html)**

여러분석툴을 사용하고 테스트코드를 열심히 작성하면 분명 코드의 품질은 좋아집니다. 하지만, 실제로 분석툴을 돌려보면 어마어마한 경고를 받게 되고 그런 결함을 수정하다보면 이게 코드를 작성하는건지 하루종일 경고만 보고 리팩토링만 하는 건지 혼란스러울 수 있습니다.

버그는 없고 코드는 단단하지만 느리게 개발하는 방식과 개발속도는 빠르지만 코드는 약간 지저분하게 작성하는 방식중에 많은 스타트업은 후자를 선택합니다.
코드는 복잡해지고 찝찝한 부분도 생기지만 일단 기능을 빠르게 구현하고 잘 동작하는 것 같으면 릴리즈합니다. 이렇게 알면서도 방치하는 몇몇 문제들을 기술부채<sub>technical debt</sub>라고 하고 우리는 그렇게 빚이 쌓여가게 됩니다. <del>현실에서도 빚, 개발에서도 빚, 엉엉</del>

쌓이고 쌓인 기술부채는 여러가지 방법으로 이자를 갚거나 주기적인 리팩토링을 통해 원금을 갚아야 하지만 개발자 한명 뽑기 어려운 스타트업에서는 사실상 개선하기 어려운 부분(<del>너 왜 개발안하고 노니?</del>)이 많습니다. 큰 회사도 예외는 아니여서 그렇게 방치하고 땜질하다가 어느날 고도화라는 이름의 프로젝트를 시작하고 아예 새로 코드를 작성하기도 합니다.

## Linter 적용해보기

1. 유지보수는 어렵고 시간이 많이 걸린는 작업이다. 개선이 필요하다고 생각한다.
2. 다양한 분석툴과 테스트코드를 작성하면 유지보수와 협업이 쉬워진다.
3. 기술부채는 꾸준히 갚아가는게 중요하다.
4. 코드의 품질이 높아지면 앱의 완성도가 높아지고 수익이 증가하여 결국 이득이다.
5. 하지만, 시간과 인력이 부족하다. 뭔가 추가로 작업할 여력이 없다. ㅠ

위 5가지에 동의를 하지만 아직 아무 조치도 취하지 않았다면 linter를 적용하기 좋은때입니다.

linter는 코딩 컨벤션과 에러를 체크해주는 작은 프로그램입니다. 독립적으로 실행할 수도 있고 IDE의 플러그인으로도 존재합니다. Python, Ruby, Java, Swift, HTML, CSS, YAML, 심지어 Markdown까지 대부분의 문법을 지원하고 있기 때문에 어떤 프로그램 언어를 사용하든 바로 체크해 볼 수 있습니다. Atom 에디터에서 지원하는 [Linter 목록](https://atomlinter.github.io/)을 보면 대부분의 언어를 지원하는 것을 알 수 있습니다.

구글([구글스타일가이드](https://github.com/google/styleguide)), 마이크로소프트와 같은 고오오오급 개발회사들은 자체적인 코딩 컨벤션을 가지고 있고 기본적으로 소스를 제출하기전에 코딩 스타일을 맞추는 것은 기본입니다. 회사차원이 아닌 언어차원에서 스타일을 지정하기도 하는데 Python의 [PEP8](https://www.python.org/dev/peps/pep-0008/)이라던가 Golang의 gofmt등이 있고, wordpress([wordpress coding standards](https://codex.wordpress.org/WordPress_Coding_Standards)), drupal 같은 유명한 툴들도 각각 스타일을 정의해서 가이드라인으로 제공하고 있습니다.

예전에는 코딩 스타일 가이드를 문서로 만들어 관리하기도 하였으나, 툴의 도움이 없다면 사실상 무의미한 작업입니다. 요즘은 다양한 툴이 존재하고 바로 적용하기 쉬우며 단계적으로 조금씩 적용하는 것도 가능합니다. 미적으로도 이쁘고 협업과 코드 리뷰를 할때도 좋고 심지어 더 나은 코드를 추천해주어 실력도 늘수 있는.. 이게 1석 몇조야... 바로 적용하지 않을 이유가 없습니다.

{% gist subicura/f98964692aed12ae1bab67005e4ecf27 %}

ReactJS 샘플 코드입니다. 최신 es6 문법도 적용하고 최선을 다해 잘 작성했다고 보이는데.. 그 유명한 [airbnb의 eslint](https://github.com/airbnb/javascript/tree/master/packages/eslint-config-airbnb)규칙을 체크해볼까요?

- 3:1   Expected exception block, space or tab after '//' in comment
- 9:11  Missing space before value for key 'msg'
- 9:11  Strings must use singlequote
- 9:13  Missing trailing comma
- 12:3   onSubmit should be placed after componentDidMount
- 13:5   Expected space(s) after "if"
- 13:19  'useComment' is missing in props validation
- 14:7   Unexpected alert
- 14:13  Unexpected string concatenation
- 14:31  Strings must use singlequote
- 21:5   Unexpected var, use let or const instead
- 25:39  Unknown property 'class' found, use 'className' instead
- 26:47  There should be no space after '{'
- 26:60  'useComment' is missing in props validation
- 26:88  There should be no space before '}'
- 28:6   Missing semicolon
- 32:2   Newline required at end of file but not found

헉, 무려 17개의 경고메시지가 발생합니다. 100% 완벽하진 않을꺼라 생각했지만 이 짧은 소스에 이렇게 많은 경고가 뜨다니 놀랍습니다. 이제 경고를 수정해 봅니다.

{% gist subicura/e89afea3a71ec0151926e24a719d2f5f %}

수정해서보니 엄청나게 바뀐부분은 없지만 왠지 퀄리티가 높아보입니다. 코딩 컨벤션은 단순히 띄어쓰기를 가이드 하는 것 말고도 React의 props validation 코드가 빠졌다는 걸 알려주고 ES6에 추가된 [template string](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)기능도 알려줍니다. 처음 React를 하면 많이 실수하는 className대신 class를 적은 것도 지적해줍니다.

그럼 Javascript 코드가 눈에 잘 안들어오는 분들을 위해 아주 심플한 [scss](http://sass-lang.com/) 코드도 살펴봅니다.

{% gist subicura/2e70ea5d7972c7dd388b25f6f03a5608 %}

이번 예제는 그리 길지도 않아서 크게 문제 없어보이는데... [scss-lint](https://github.com/brigade/scss-lint)를 돌려봅니다.

- SpaceAfterPropertyColon: Colon after property should be followed by one space
- ColorVariable: Color literals like '#ffffff' should only be used in variable declarations; they should be referred to via variable everywhere else.
- HexLength: Color '#ffffff' should be written as '#fff'
- SpaceAfterComma: Commas in function arguments should be followed by a single space
- SpaceAfterComma: Commas in function arguments should be followed by a single space
- SpaceAfterComma: Commas in function arguments should be followed by a single space
- SpaceAfterPropertyColon: Colon after property should be followed by one space
- ColorVariable: Color literals like 'rgba(255, 0, 0, 0.5)' should only be used in variable declarations; they should be referred to via variable everywhere else.
- LeadingZero: '0.5' should be written without a leading zero as '.5'
- NestingDepth: Nesting should be no greater than 3, but was 4
- SpaceAfterPropertyColon: Colon after property should be followed by one space

11개의 경고메시지가 발생했습니다. -ㅁ-;; 내가 작성한 코드가 그렇게도 일반적인 표준과 거리가 멀단말인가...?! 라고 생각하면서 일단 수정해 봅니다.

{% gist subicura/a4f80ad19a443ed7cac29f7e3f6d32c1 %}

전과 비교하여 소스가 깔끔해 보이나요? 스페이스 규칙은 물론 스타일의 순서와 내부 클래스의 깊이까지 제한해줍니다. sass/scss를 처음 사용하면 내부 클래스의 깊이가 마구 늘어나다가 나중에 범용적으로 적용하기 어려운 경우를 발견하곤 하는데 이러한 문제를 미리 방지해줍니다.

사람마다 원하는 스타일이 다르고 이게 더 낫다고 생각하는 부분도 있지만, 정말 그런 스타일이 유지보수와 협업에 도움이 되는지 생각해봐야 합니다. 혼자 작성하는 코드가 아니라면 **자신의 스타일** 보다는 대부분이 괜찮다고 하는 **모두의 스타일**에 맞추는 것이 유지보수와 협업에 도움이 됩니다.

## [eslint](http://eslint.org/) 적용하기

실제로 lint를 어떻게 적용하는지, 어떠한 옵션이 있는지 알아보기 위해 javascript lint툴인 eslint를 설치하고 사용하는 방법을 알아봅니다. 굳이 javascript lint툴을 가지고 예를 든 이유는 javascript가 개발자들 마다 가장 스타일 차이가 많이 나는 언어라고 생각하기 때문입니다. linter들의 사용법과 옵션은 비슷비슷하기 때문에 eslint를 살펴보면 다른 언어의 linter도 적용하기 쉬울거라 생각됩니다.

### eslint 설치

**설치**

eslint는 [Node.js](https://nodejs.org/)로 작성된 프로그램입니다. 먼저, nodejs를 설치후에 eslint를 설치합니다.

{% highlight sh linenos %}
$ npm install -g eslint
{% endhighlight %}

**초기설정**

설치후엔 eslint 초기 설정을 진행합니다.

{% highlight sh linenos %}
$ npm init
$ eslint --init

? How would you like to configure ESLint? Answer questions about your style
? Are you using ECMAScript 6 features? Yes
? Are you using ES6 modules? Yes
? Where will your code run? Browser
? Do you use CommonJS? No
? Do you use JSX? Yes
? Do you use React Yes
? What style of indentation do you use? Spaces
? What quotes do you use for strings? Single
? What line endings do you use? Unix
? Do you require semicolons? Yes
? What format do you want your config file to be in? JavaScript
{% endhighlight %}

몇가지 옵션을 물어보면서 자동으로 필요한 plugin을 추가하고 `.eslintrc.js`라는 설정파일을 만들어줍니다.

{% gist subicura/29778c2ab4c2c4f94f29ceabe9416ae3 %}

대부분의 linter는 위와 같이 세부적인 설정파일을 제공하고 보통 `.`<sub>dot</sub>으로 시작하여 보이지 않는 파일로 관리합니다. linter에서 체크하는 규칙중에 현재 코드에 적용이 어려운 규칙등은 무시하게 설정할 수 있어 일단 툴을 돌려보고 수정하는데 무리가 있는 규칙은 제외하거나 바꾸면 됩니다.

**Airbnb 규칙적용**

기본적인 옵션은 범용적으로 설정되기 때문에 회사마다 특성에 맞게 조금씩 규칙을 고쳐서 사용합니다. Airbnb 또한 자체적인 규칙을 설정하여 사용중인데 이를 [오픈소스](https://github.com/airbnb/javascript)로 공개하였고 React와 ES6를 사용하는 프로젝트에 적절한 규칙을 제공합니다. Airbnb룰을 적용해봅니다.

{% highlight sh linenos %}
$ npm install --save-dev eslint-config-airbnb eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y eslint
{% endhighlight %}

{% gist subicura/57c7ba78118f3afab25dbbb9b3276d81 %}

Airbnb에서 만든 플러그인을 추가하고 lint 설정파일을 바꿨습니다.

**나만의 규칙적용**

Airbnb규칙중에 [react/jsx-no-bind](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-no-bind.md)규칙은 빼는게 현재 상황에 적당할 것 같아 해당 규칙을 뺍니다.

{% gist subicura/1b7f686371897d96823f743f1b22c496 %}

**inline 규칙적용**

가끔 특정 코드에서만 규칙을 따로 적용하고 싶을 수 있습니다. 이럴땐 주석을 이용한 inline 규칙을 적용하면 됩니다.

{% gist subicura/308dfda948a55be8e8534aa24a3b71b1 %}

**실행**

이제 설정은 거의 끝났으니 실제로 lint를 돌려봅니다.

{% highlight sh linenos %}
$ eslint **/*.jsx
{% endhighlight %}

주르륵주르륵 에러가 뜹니다. ㅠㅠ 이제 고치기만 하면 되겠네요...

## Gulp 설정

linter를 단독으로 사용하는 경우는 이런 샘플을 보여줄 때 빼고는 아마 거의 없을겁니다. 왜냐면 개발자들은 게을러서 파일을 저장하거나 수정할 때 자동으로 체크하게 해줘야 합니다. 테스크 자동화 툴인 [gulp](http://gulpjs.com/)의 watch 기능을 이용하여 자동으로 체크하도록 설정해봅니다.

**설치**

{% highlight sh linenos %}
$ npm install --global gulp-cli
$ npm install --save-dev gulp
$ npm install --save-dev gulp-eslint
{% endhighlight %}

대부분의 linter는 [gulp-eslint](https://github.com/adametry/gulp-eslint)와 같이 gulp용 plugin을 제공합니다. 이제 gulpfile을 설정합니다.

{% gist subicura/65a15aea86bc2582e3cca337491f5bbe %}

**실행**

{% highlight sh linenos %}
$ gulp
{% endhighlight %}

node_modules 디렉토리를 제외하고 js와 jsx파일을 수정하면 자동으로 eslint를 실행하고 결과를 알려줍니다. 이런식으로 scss-lint등 원하는 linter를 추가할 수 있습니다.

## IDE 플러그인

**SublimeText3**

SublimeText3에 lint를 적용하려면 [SublimeLinter](http://www.sublimelinter.com/en/latest/)를 설치합니다.

1. 커멘트창을 열고(cmd+shift+p on Mac OS X, ctrl+shift+p on Linux/Windows)
2. Package Control: Install Package 를 선택합니다.
3. SublimeLinter와 SublimeLinter-contrib-eslint를 설치합니다.
4. 설치가 끝나면 재시작합니다.

![sublime text3]({{ site.url }}/assets/article_images/2016-07-11-coding-convention/sublimetext3.png)

왼쪽에 빨간색점이 보이고 하단에 에러문구가 보입니다.

**WebStorm**

IntelliJ의 WebStorm IDE에는 ESLint가 이미 내장되어 있습니다. 설정에서 활성화하면 바로 적용됩니다.

![WebStorm ESLint]({{ site.url }}/assets/article_images/2016-07-11-coding-convention/webstorm_eslint.png)

`Languages & Frameworks > Javascript > Code Quality Tools > ESLint`

![WebStorm ESLint Check]({{ site.url }}/assets/article_images/2016-07-11-coding-convention/webstorm_eslint_view.png)

활성화하면 editor 오른쪽에 빨간색 라인이 보이고 마우스 오버하면 에러문구가 보입니다.

## CI

linter를 사용하는 법은 거의 끝났고, 이제 CI에 적용할때입니다. 소스를 배포하고 빌드할 때마다 자동으로 lint를 체크하고 잘못된 점을 알려서 개발자를 압박해야겠죠. [Jenkins](https://jenkins.io/)를 사용한다면 [checkstyle plugin](https://github.com/jenkinsci/checkstyle-plugin)을 사용할 수 있습니다. [Checkstyle](http://checkstyle.sourceforge.net/)은 원래 java파일을 체크할때 사용하던 포멧인데 다른 툴에서도 보통 같은 포멧을 제공합니다.

{% highlight sh linenos %}
$ eslint -f checkstyle *.js > checkstyle.xml
{% endhighlight %}

eslint에서는 -f 옵션을 통해 output 포멧을 지정할 수 있는데 checkstyle을 내장하고 있습니다. Jenkins에서 checkstyle을 설정하면 다음과 같은 화면을 볼 수 있습니다.

![Jenkins Checkstyle]({{ site.url }}/assets/article_images/2016-07-11-coding-convention/checkstyle.png)

## 그래서

코딩 컨벤션을 문법단계까지 적용한 대표적인 언어가 [python](https://www.python.org/)과 [Go](https://golang.org/)라고 생각합니다. 처음에 python이 블록 구분을 중괄호가 아닌 들여쓰기로 한다는 이야기를 들었을땐 엄청난 충격적이였습니다. *아니 python은 이제 블록 줄바꿈가지고 개발자들끼리 싸우지 않아도 되는건가?!* 이후에 Go를 접했을때도 Go는 줄을 바꾸지 않고 중괄호를 같은 줄에 붙이는 걸 강제하였고 언어 스펙도 굉장히 간결하여 다시 한번 충격적이였습니다. Go는 더 나아가 gofmt라는 코드 스타일 검사툴을 기본 설치판에 포함하여 대부분의 코드 스타일을 비슷하게 만들어 버렸습니다. 이때문에 Go 개발자들은 다른 사람의 소스를 이해하는게 쉽다고 느껴져 좋은 소스를 참고하고 배우는게 편하다는 이야기를 자주 합니다.

Linter를 적극적으로 사용할 수록 굉장히 빡빡한 느낌이 있습니다. Linter는 결국 코드를 잘 관리하여 최종적인 생산성을 높이자는 건데 오히려 방해가 되고 속도가 더뎌지는 느낌을 받을 수 있습니다. 따라서 가장 중요한 건 무조건적으로 철저하게 지키는 것이 아닌 **언제 어길지를 아는 것**이라고 생각합니다. 코딩 컨벤션을 적용한 코드가 오히려 더 눈에 안 들어오고 해석이 어렵다거나 기존에 적용된 일관성을 코딩 컨벤션이 오히려 어기는 경우는 전부다 바꾸는 시간을 고려하여 프로젝트만의 규칙을 만들고 느슨하게 설정하는 것이 낫다고 생각합니다. 그리고 간단한 프로토타입을 만드는데 까지 무조건적으로 적용하는건 어렵겠죠.

Linter를 시작으로 다양한 분석툴을 적용하고 테스트코드를 작성하다 보면 지금 당장 개발 속도가 느린 것 같지만 결국 미래의 나와 우리가 행복해지는 길이라고 생각합니다.

Linter를 적용하여 개발한 홈쇼핑처럼에서 이번에 출시한 까르보돈까스 절찬리 판매중이니 서비스에 관심있으신분은 [https://www.likehs.com/](https://www.likehs.com/) 에 방문해 주시구요.
개발자 상시 모집중입니다. 갓 대학을 졸업한 의지넘치는 신입부터 고오급 경력 개발자까지 모두 환영합니다 ㅎㅎ ([http://www.purpleworks.co.kr/recruit](http://www.purpleworks.co.kr/recruit))


