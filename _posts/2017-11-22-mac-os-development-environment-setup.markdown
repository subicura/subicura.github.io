---
published: true
title: 본격 macOS에 개발 환경 구축하기
tags: [Mac, DevOps, Server, Development, Environment, Terminal, zsh, vi, tmux]
layout: post
excerpt: macOS에서 터미널을 자주 사용하는 개발자를 대상으로 심플하고 깔끔한 테마 위주의 개발 환경을 설정하는 방법을 소개합니다. 이 글을 보고 하나하나 설정하면 어디 가서 발표할 때 고오오급 개발자처럼 보이는 효과가 있으며 개발 생산성이 조금은 높아질 거라고 생각합니다.
comments: yes
toc: true
last_modified_at: 2017-11-24T13:40:00+09:00
---

![iTerm2 + snazzy]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/terminal-neofetch.png)

개발 관련 스터디 모임이나 컨퍼런스에서 발표를 듣다 보면 발표 주제와 별도로 예제 화면이나 라이브 코딩에서 사용하는 개발 도구에 관심이 가는 경우가 있습니다.

> 같은 macOS를 사용하는데 터미널이 왜 다르게 생긴 거지? vi 에디터에 원래 저런 기능이 있었어? 뭐가 저렇게 막 글자가 자동완성되는 거지? 저건 무슨 테마지?

개인적인 경험으로도 어디서 발표를 할 때 주제와 상관없이 "아까 그거 무슨 프로그램이에요?", "어떻게 셋팅한 거에요?" 와 같은 질문을 받은 적이 있고 다른 분들 화면을 보고 쉬는 시간에 조용히 가서 "아까 그거 어떻게 하신건지.." 하고 물어본 경우도 많습니다.

개발 환경 설정은 실제적인 개발과 상관이 없고 ~~해도 그만 안 해도 그만~~ 개발자들의 개인 취향에 영향을 많이 받기 때문에 처음부터 차근차근 설정하는 법을 알려주는 문서가 잘 없고 여기저기 작은 단위로 소개하거나 모임 같은 곳에서 입에서 입으로 전해지고 있습니다.

이 글은 macOS에서 터미널을 자주 사용하는 개발자를 대상으로 심플하고 깔끔한 테마 위주의 개발 환경을 설정하는 방법을 소개합니다. 이 글을 보고 하나하나 설정하면 어디 가서 발표할 때 고오오급 개발자처럼 보이는 효과가 있으며 개발 생산성이 조금은 높아질 거라고 생각합니다.

최종 설정이 완료된 화면을 살펴보고 어떻게 설정하는지 알아봅니다.

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/terminal-demo.json', title: '' %}

## 키보드 기호 설명

단축키 입력과 관련해서 기호를 사용합니다. 잘 기억해 둡니다.

{:.table.table-key-value-60}
기호 | 설명
---- | ----
⌘ | Command
⌥ | Option
⌃ | Control
⇧ | Shift
+ | 동시 입력
, | 키를 떼고 다시 입력함

> 예) `⌃` + `b`, `c` 는 control키를 누른 상태에서 b를 누르고 control키와 b에서 모두 손을 뗀 다음에 c를 입력하라는 의미입니다.

## 시스템 설정

본격적인 개발환경 설정에 앞서 몇 가지 유용한 시스템 설정을 확인해봅니다. macOS High Sierra를 기준으로 하였으나 다른 버전도 비슷비슷할 것으로 보입니다. 반드시 동일하게 설정할 필요는 없으며 보고 괜찮다 싶은 항목만 적용하면 됩니다.

### System Preferences

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/system-preferences.png)

상단 메뉴의 `` 로고를 누르고 `System Preferences...`를 선택합니다.

**미션 컨트롤 창 순서 고정**

- `Mission Control` > `Automatically rearrange Spaces based on most recent use`: 체크 안함
- 미션 컨트롤 창 순서가 기본적으로 최근 사용 순으로 설정되어 있어 의도하지 않게 순서가 변경되는 것을 막음

**언어 설정 영어 우선순위로 변경**

- `Language & Region` > `Preferred languages`: English > 한국어 (드래그로 순서 조정)
- 간혹 locale 설정 때문에 오류가 발생하는 걸 방지해주고 영어 오류 메시지가 구글검색이 잘됨

**패스워드 즉시 설정**

- `Security & Privacy` > `General` > `Require password`: immediately
- 잠자기 모드나 화면 보호기가 켜지면 즉시 패스워드 입력을 활성화하여 보안을 최대한 안전하게 유지

**분실대비 패스워드 메시지 설정**

- `Security & Privacy` > `General` > `Show a message when the screen is locked`: 전화번호 / 이름
- 혹시 분실했을 경우를 대비하여 전화번호, 이름 등을 알려줌

**디스크 암호화**

- `Security & Privacy` > `FileVault`: Turn On FileVault
- 분실 시 복구 불가능하게 디스크를 암호화
- 파일 읽기/쓰기 퍼포먼스가 걱정되지만 최신 CPU와 SSD에서는 거의 성능 차이가 없다고 함~~믿고쓰자~~

**모든 텍스트 자동 변경 옵션 끄기**

- `Keyboard` > `Text`: 모든 자동 변경 옵션 끄기
- 입력한 단어를 컴퓨터 마음대로 바꾸는 걸 방지
- 특히 Use smart quotes and dashes는 코드 복사하다가 따옴표가 바뀌면서 고생이 시작됨

**클릭은 터치로**

- `Trackpad` > `Point & Click` > `Tab to click`: 체크함
- 트랙패드 클릭 시 꾸욱 누를 필요 없이 톡톡 터치로 클릭해서 손의 피로를 줄임

**드래그는 세손가락으로**

- `Accessibility` > `Mouse & Trackpad` > `Trackpad options...`:  Enable dragging - three finger drag
- 창 또는 아이콘을 이동할 때 트랙패드를 누른 상태로 이동할 필요 없이 세 손가락으로 드래그 할 수 있음
- 이건 해봐야 감이 오는데 몰랐다면 신세계가 열림

### Finder Preference

<p align="center">
    <img src="{{ "/assets/article_images/2017-11-22-mac-os-development-environment-setup/finder-preferences.png"  | prepend: site.baseurl  }}" style="width: 450px">
</p>

`Finder`를 실행하고 `⌘` + `,` (`Finder` > `Preferences...`)를 선택합니다.

**파인더 기본 폴더 설정**

- `General` > `New Finder windows show`: subicura (home folder)
- 파인더 최초 실행 시 버벅임이 없도록 기본 폴더를 홈 폴더로 설정

**파일 확장자 보여주기**

- `Advanced` > `Show all filename extensions`: 체크함
- 모든 파일의 확장자를 보여줌

### Download Folder Option

<p align="center">
    <img src="{{ "/assets/article_images/2017-11-22-mac-os-development-environment-setup/download-option.png"  | prepend: site.baseurl  }}" style="width: 250px">
</p>

`Downloads` 폴더로 이동하고 `⌘` + `J` (`View` > `Show View Options`)를 선택합니다.

**날짜그룹 + 이름 정렬**

- `Arrange By`:Date added, `Sort By`:Name
- 파일 목록을 보여줄 때 날짜별로 그룹화 하고 그룹 내에서 이름으로 다시 정렬
- 다운로드 폴더 특성상 최근에 받은 파일들을 찾는 경우가 많으므로 유용함

## 필수 프로그램

시스템 설정을 완료했으니 개발 환경 구축을 위한 필수 프로그램을 설치합니다.

### Xcode

macOS에는 기본적으로 `gcc`, `make`와 같은 컴파일 도구가 설치되어 있지 않기 때문에 명령어 도구<sub>Command Line Tools</sub>를 설치해야 합니다. 예전에는 Xcode를 전체 설치하고 추가로 명령어 도구를 설치해야 했으나 Xcode용량이 꽤 크고 모든 사람이 IDE가 필요한 게 아니기 때문에 명령어 도구만 따로 설치할 수 있게 변경되었습니다.

**설치**

{% highlight bash linenos %}
xcode-select --install
{% endhighlight %}

**확인**

{% highlight bash linenos %}
# gcc test
$ gcc
clang: error: no input files
{% endhighlight %}

[Xcode 홈페이지](https://developer.apple.com/xcode/)

### homebrew

brew<sub>homebrew</sub>는 각종 커맨드라인 프로그램(요즘은 GUI도..)을 손쉽게 설치해주는 맥용 패키지 매니저입니다. 리눅스의 `apt`나  `yum`과 비슷하며 brew외에 [MacPorts](https://www.macports.org/) 라는 패키지 메니저가 있는데 몇몇 단점으로 요즘은 거의 brew를 사용하는 추세입니다. 다양한 프로그램을 복잡한 빌드과정 없이 손쉽게 설치할 수 있고 업데이트, 관리도 간단하므로 안쓸 이유가 없는 필수 프로그램입니다. `그냥 홈페이지 가서 다운로드 하고 설치하는 게 편한데..`라고 하는분들이 있는데 나중에 업데이트나 삭제를 생각해보면 글쎄요.. brew 쓰세요!

**설치**

{% highlight bash linenos %}
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
{% endhighlight %}

**확인**

{% highlight bash linenos %}
# brew test
$ brew doctor
Your system is ready to brew.
{% endhighlight %}

[Homebrew 홈페이지](https://brew.sh/) / [brew 명령어](https://docs.brew.sh/Manpage.html) / [brew 패키지 검색](http://formulae.brew.sh/)

### git

버전 관리 도구로 유명한 `git`입니다. 다들 아시죠? macOS에 기본으로 설치되어 있지만 최신 버전이 아니므로 `brew`를 이용해서 업데이트 합니다. `git-lfs` 는 Git Large File Storage로 용량이 큰 바이너리 파일을 git으로 관리할 때 유용합니다. git 설치할 때 같이 설치합니다.

**설치**

{% highlight bash linenos %}
brew install git git-lfs
{% endhighlight %}

git 설치가 완료되었으면 개인정보를 설정하고 맥에서 한글 파일명을 정상적으로 처리하기 위해 추가 옵션을 설정합니다. ~~망할 한글처리~~

**설정**

{% highlight bash linenos %}
git config --global user.name "Your Name"
git config --global user.email "you@your-domain.com"
git config --global core.precomposeunicode true
git config --global core.quotepath false
{% endhighlight %}

[Git 홈페이지](https://git-scm.com/) / [Git LFS 홈페이지](https://git-lfs.github.com/)

## 터미널 설정

시스템 설정도 하고 필수 프로그램도 설치했으니 본격적으로 터미널을 설정해 봅니다.

### iTerm2

macOS에 기본으로 설치되어 있는 Terminal 앱 대신 iTerm2를 터미널 앱으로 사용합니다. iTerm2는 기본 앱에 없는 [다양한 기능](https://www.iterm2.com/features.html)이 있고 손쉽게 테마를 설정할 수 있습니다.

**설치**

brew로 설치 하거나 [여기](https://www.iterm2.com/downloads.html)서 다운로드 합니다.

{% highlight bash linenos %}
brew cask install iterm2
{% endhighlight %}

**테마선택**

![snazzy]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/snazzy-theme.png)

설치를 완료했으면 [Snazzy.itermcolors](https://github.com/sindresorhus/iterm2-snazzy/raw/master/Snazzy.itermcolors) 파일을 오른쪽 버튼 누르고 다운 받거나 [여러 개의 테마](http://iterm2colorschemes.com/)를 둘러보고 맘에드는것을 고릅니다. 다운받은 파일을 더블클릭하면 자동으로 `iTerm Color Preset`에 추가됩니다.

**테마적용**

iTerm을 실행하고 설정(`⌘` + `,`)창에서 `Profiles` 항목을 선택하고 `Colors`탭을 선택합니다. 

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/iterm-preferences.png)

오른쪽 하단에  `Color presets...` 선택 박스를 클릭하면 조금전에 추가한 `Snazzy` preset을 선택할 수 있습니다.

음.. 그런데 테마를 바꿔도 그다지 달라지는 건 없어보입니다.. ~~이게 무슨 소리요?!~~ 제대로 색을 활용하려면 쉘<sub>shell</sub> 설정을 해야합니다.

**추가설정**

- 타이틀바 배경색 어둡게 변경
    -  `Appearance` > `Theme`: Dark
	- High Sierra에서는 [현재](https://gitlab.com/gnachman/iterm2/issues/4080) Light/Dark 테마만 선택할 수 있으며 임의의 색은 불가능
- 스크롤바 감추기
	-  `Appearance` > `Hide scrollbars`: 체크함
- 타이틀바 밑에 1px 라인 제거
	-  `Appearance` > `Show line under title bar when the tab bar is not visible`: 체크 안함
- 마진 수정
	- `Advanced` > `Height of top and bottom margins in terminal panes`: 10
	- `Advanced` > `Width of left and right margins in terminal panes`: 12

[iTerm2 홈페이지](https://www.iterm2.com) / [iTerm2 다운로드](https://www.iterm2.com/downloads.html) / [snazzy github](https://github.com/sindresorhus/iterm2-snazzy)

### zsh with oh-my-zsh

iTerm2도 설치하고 테마도 설치했으니 쉘을 바꿀 차례입니다.

macOS는 기본으로 [Bash(Bourne-again) shell](https://en.wikipedia.org/wiki/Bash_(Unix_shell))을 사용하고 있습니다. bash외에 csh, ksh, sh, tcsh, zsh등을 내장하고 있는데 최근 대새는 단연 zsh입니다. zsh에 설정 관리 프레임워크인 oh-my-zsh을 사용하여 이쁜 테마를 적용하고 여러 가지 플러그인을 설치해봅니다.

**설치**

zsh을 최신 버전으로 업데이트하고 [zsh-completions](https://github.com/zsh-users/zsh-completions)도 설치합니다.

{% highlight bash linenos %}
brew install zsh zsh-completions
{% endhighlight %}

그리고 zsh의 설정을 관리해주는 oh-my-zsh을 설치합니다.

{% highlight bash linenos %}
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
{% endhighlight %}

설치스크립트를 실행하면 관련 파일을 설치하고 패스워드를 물어봅니다. 계정의 패스워드를 입력하면 기본쉘을 자동으로 bash에서 zsh로 변경해줍니다. 

**플러그인**

oh-my-zsh의 가장 강력한 점은 플러그인입니다. [기본 플러그인](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)외에 명령어 하이라이팅 플러그인 [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)과 자동완성 플러그인 [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)을 설치합니다.

{% highlight bash linenos %}
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
{% endhighlight %}

플러그인을 설치하면 반드시 `~/.zshrc`파일에 설정을 해야합니다. 파일을 열고 `plugins`항목에 플러그인을 추가합니다.

{% highlight bash linenos %}
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)
{% endhighlight %}

설정 파일을 수정했으면 터미널을 재시작하거나 `source ~/.zshrc` 명령어를 실행하여 설정을 다시 불러와야 합니다. 이제 명령어를 입력할 때 존재하지 않는 명령어는 빨간색으로 뜨고 한번 입력했던 명령어를 회색으로 표현해주는 걸 확인할 수 있습니다.

**테마**

oh-my-zsh의 기본 테마인 `robbyrussell`도 깔끔하지만, 이 외에 [다양한 테마](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)가 존재합니다. 테마를 바꾸는 방법은 `~/.zshrc`파일의 `ZSH_THEME="robbyrussell"` 부분을 원하는 테마로 수정하면 됩니다.

여기서는 이쁘고 단순하고 빠른 [pure](https://github.com/sindresorhus/pure) prompt를 사용합니다.

{% highlight bash linenos %}
brew install nodejs # nodejs가 설치되어 있다면 skip
npm install --global pure-prompt
{% endhighlight %}

설치를 완료했으면 `~/.zshrc`파일에 다음항목을 추가합니다.

{% highlight bash linenos %}
autoload -U promptinit; promptinit
prompt pure
{% endhighlight %}

이제 zsh 기본 설정이 끝났습니다!

**oh-my-zsh 팁**

zsh과 oh-my-zsh의 조합으로 강력한 쉘을 사용할 수 있게 되었습니다. 여기서 모든 기능을 설명할 순 없지만 자주 사용하는 몇 가지 팁을 소개합니다.

1. 명령어가 기억나지 않으면 `tab`을 누르세요
2. cd ../.. 대신 `...`, `....`, `.....`, ...
3. 단축명령어 - `git status` => `gst`, `git pull` => `gl` 등등 [다양한 단축명령어](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugin:git)

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/zsh-demo.json', title: '' %}

팁이 맘에 든다면 [다른 플러그인](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)도 구경하세요. 어마어마한 양의 플러그인이 준비되어 있습니다.

[oh-my-zsh 홈페이지](https://github.com/robbyrussell/oh-my-zsh) / [pure github](https://github.com/sindresorhus/pure)

## 커맨드라인 애플리케이션

이제 터미널이 이뻐졌으니 각종 도구를 설정해봅니다.

### vim

vim은 기본으로 설치된 터미널용 에디터로 GUI 환경의 에디터를 사용할 수 있는 macOS 환경에서는 일부 ~~고오오급~~ 개발자를 제외하고는 잘 쓰이지 않습니다. 하지만 터미널 작업을 하다 보면 간단하게 수정할 파일이 있고 git 커밋메시지를 작성할 때 종종 사용하게 됩니다.

기본으로 설정된 화면은 밋밋하기 그지 없기 때문에 강력한 기능의 플러그인을 설치해줍니다.

**설치**

내장된 vim대신 neovim을 설치합니다. neovim은 vim과 차이가 없어 보이는데 24bit True Color를 지원하고 오래된 vim 소스를 처음부터 다시 짜서 소스코드가 줄었다고 합니다. 저 같은 라이트 유저는 차이를 느끼진 못하지만 좋다고 해서 사용하고 있습니다. 그리고 테마에서 사용할 개발용 폰트를 설치합니다.

{% highlight bash linenos %}
brew install neovim
brew tap caskroom/fonts
brew cask install font-hack-nerd-font
{% endhighlight %}

기본 설치가 완료되었으면 터미널 기본 에디터로 vi대신 neovim을 사용하도록 `~/.zshrc`에 다음 항목을 추가합니다.

{% highlight bash linenos %}
alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
export EDITOR=/usr/local/bin/nvim
{% endhighlight %}

`source ~/.zshrc`를 입력하여 설정을 다시 불러옵니다.

**플러그인**

vim은 강력한 플러그인들이 많이 있는데 설치가 어렵고 어떤 게 좋은지 라이트 유저는 알 수가 없습니다. SpaceVim이라는 프로젝트는 가장 많은 사람들이 사용하는 플러그인을 자동으로 설치해줍니다. 약간 무거운 느낌이 있긴 하지만 설치가 간단하고 화면을 보는 순간 고오오급 개발자의 포스를 만들어주니 바로 설치해봅니다.

{% highlight bash linenos %}
curl -sLf https://spacevim.org/install.sh | bash
{% endhighlight %}

설치가 완료되면 `vi`를 실행합니다. 최초 실행 시 mode 설정을 물어보고 (`1`을 누릅니다) 자동으로 플러그인을 설치합니다. 플러그인이 많아서 시간이 꽤 걸립니다.

**테마**

기본 테마는 뭔가 칙칙한 느낌이 듭니다. `~/.SpaceVim.d/init.vim` 파일에 Colorscheme 설정을 추가합니다.

{% highlight bash linenos %}
let g:spacevim_colorscheme = 'onedark'
{% endhighlight %}

설정 파일을 수정하고 다시 시작하면 좀 더 나은 화면을 볼 수 있습니다.

**폰트**

앗, 플러그인을 설치하고 vi를 실행하면 폰트가 깨져서 ?가 보이는 걸 알 수 있습니다.

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/nvim-question.png)

iTerm2에 개발 관련 폰트를 모은 NerdFont를 추가로 설정합니다.

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/iterm-font.png)

iTerm을 실행하고 설정(`⌘` + `,`)창에서 `Profiles` 항목을 선택하고 `Text`탭을 선택합니다. Font항목에서 `Use a different font for non-ASCII text`를 체크하고 다른 탭을 살짝 눌렀다 다시 돌아오면 Non-ASCII Font를 설정할 수 있습니다. 거기서 Knack Regular Nerd Font Complete를 선택하면 폰트가 이쁘게 나옵니다.

이제 설정이 모두 완료되었으니 vim 공부만 하면 됩니다. :)

[neovim 홈페이지](https://neovim.io/) / [Nerd Font github](https://github.com/ryanoasis/nerd-fonts) / [SpaceVim github](https://github.com/SpaceVim/SpaceVim) / [SpaceVim 설정문서](http://spacevim.org/documentation/)

### fzf

fzf는 강력하고 엄청나게 빠른 fuzzy finder 도구입니다. 증분 검색을 통하여 원하는 파일이나 히스토리를 쉽고 빠르게 찾을 수 있게 해줍니다. 정확하게 원하는 값을 입력하지 않고 일부만 입력해도 실시간으로 검색 결과를 보여줍니다.

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/fzf-sample.png)

**설치**

{% highlight bash linenos %}
brew install fzf

# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install
{% endhighlight %}

brew 설치 후 install 명령어를 입력하면 몇 가지를 물어보는데 전부 `y`를 누르면 됩니다. 설치가 완료되었으면 `source ~/.zshrc`를 입력하여 설정을 다시 불러옵니다.

**명령어**

정말 다양하게 사용할 수 있지만 여기선 가장 기본적인 기능만 살펴봅니다.

{:.table.table-key-value-60}
단축키 | 기능
---- | ----
`⌃` + `T` | 하위 디렉토리 파일 검색 
`⌃` + `R` | 히스토리 검색
`esc` + `C` | 하위 디렉토리 검색 후 이동

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/fzf-demo.json', title: '' %}

단축키 입력하고 글자를 몇 개 입력하면 금방 감이 옵니다. 취소는 `esc`입니다.

[fzf github](https://github.com/junegunn/fzf)

### fasd

fasd는 사용빈도가 높은 파일 또는 디렉토리 검색을 편하게 해서 생산성을 향상시켜주는 도구입니다. 열어본 파일이나 이동한 디렉토리를 기억하고 우선순위를 정해서 빠르게 검색할 수 있게 도와줍니다.

**설치**

{% highlight bash linenos %}
brew install fasd
{% endhighlight %}

설치가 완료되었으면 `~/.zshrc`에 plugin을 추가해줍니다.

{% highlight bash linenos %}
plugins=(
  ...
  ...
  fasd
)
{% endhighlight %}

전부 완료되었으면 `source ~/.zshrc`를 입력하여 설정을 다시 불러옵니다.

**명령어**

명령어를 사용하기 위해서는 일단 디렉토리를 좀 이동하고 파일도 열어보고 해야 합니다. 어느 정도 히스토리가 쌓이면 명령어를 입력해봅니다.

{:.table.table-key-value-60}
단축키 | 기능
---- | ----
`z` | 디렉토리 이동
`s` | 파일 or 디렉토리 검색

디렉토리를 이동할 때 `z github`, `tab`과 같이 일부 검색어를 입력하고 tab을 눌러서 이동합니다.

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/fasd-demo.json', title: '' %}

단순한 기능만큼 굉장히 자주, 유용하게 사용하는 도구입니다.

[fasd github](https://github.com/clvv/fasd)

### tmux

tmux는 터미널 멀티플렉서<sub>Terminal MUltipleXer</sub>라고 합니다. 하나의 화면에서 창을 여러 개 만들 수 있고 가로 분할, 세로 분할 할 수도 있습니다. `어, 그거 iTerm에서 그냥 되는데요?`라고 말씀하시면 딱히 할말은 없지만~~반박 불가~~.. 알아두면 원격 리눅스 서버 환경에서 유용하게 쓸 수 있고 무엇보다 꽤나 있어보이는 화면을 만들 수 있습니다.

**설치**

{% highlight bash linenos %}
brew install tmux
{% endhighlight %}

설치가 완료되었으면 `~/.zshrc`에 plugin을 추가해줍니다.

{% highlight bash linenos %}
plugins=(
  ...
  ...
  tmux
)
{% endhighlight %}

**테마**

tmux 역시 기본 테마는 너무 밋밋하기 때문에 [잘 만들어 놓은 테마](https://github.com/gpakosz/.tmux)를 가져다 씁니다.

{% highlight bash linenos %}
cd ~/
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
{% endhighlight %}

**설정**

예전에는 몰랐는데 요즘 tmux는 놀랍게도 마우스를 지원합니다. 터미널인데 마우스가 됩니다! 하단에 윈도우 탭을 누르면 바로바로 이동하고 분할 창<sub>pane</sub>도 마우스를 누르는 창으로 포커스됩니다.

`.tmux/.tmux.conf.local`파일을 열고 맨 밑으로 이동해서 주석으로 되어 있는 설정을 해제해 줍니다.

{% highlight bash linenos %}
# increase history size
set -g history-limit 10000

# start with mouse mode enabled
set -g mouse on

# force Vi mode
# really you should export VISUAL or EDITOR environment variable, see manual
set -g status-keys vi
set -g mode-keys vi
{% endhighlight %}

**사용법**

tmux는 꽤 사용난이도가 높은 프로그램입니다. 자세한 내용을 여기서 다루기엔 양이 너무 많기 떄문에 따로 공부를 해야하고 여기서는 아주 기본적인 기능 몇 가지만 알아봅니다.

- **세션<sub>session</sub>** tmux가 관리하는 가장 큰 단위
- **윈도우<sub>window</sub>** 세션안에 존재하는 탭같은 단위
- **팬<sub>pane</sub>** 윈도우 안에 가로 세로로 분할한 단위

{:.table.table-key-value-60}
명령어 | 기능
---- | ----
`tmux ` | 세션 생성
`tmux attach`  | 생성되어 있는 세션에 진입
`tmux ls`  | 세션 목록 확인

{:.table.table-key-value-60}
단축키 | 기능
---- | ----
`⌃` + `b`, `c` | 새 창 만들기
`⌃` + `b`, `d` | tmux 환경에서 나오기
`⌃` + `b`, `1`~`9` | 해당 창으로 이동
`⌃` + `b`, `%` | 세로로 창을 나눔 (좌/우)
`⌃` + `b`, `"` | 가로로 창을 나눔 (위/아래)
`⌃` + `b`, `화살표` | 나뉘어진 창을 좌/우/위/아래로 움직임

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/tmux-demo.json', title: '' %}

아주 간단하게 살펴보았지만 사실 스크롤, 복사 등등 알아야 할 게 은근 많습니다. ~~안될꺼야..~~

[tmux github](https://github.com/tmux/tmux) / [Oh My Tmux!](https://github.com/gpakosz/.tmux)

### tmuxinator

tmux의 쓸모를 한층 더 높여주는 게 tmuxinator입니다. 단축키로 창을 만들고 화면을 분할하는 것을 설정파일로 해줍니다.

예를 들면, 1번 윈도우는 webpack을 실행하고 2번 윈도우는 rails server를 실행하고 3번 윈도우는 log를 실행하게 설정할 수 있습니다. 요즘 프로젝트는 복잡하게 구성된 경우가 많아서 굉장히 유용하게 사용할 수 있습니다.

**설치**

tmuxinator는 ruby로 작성된 프로그램입니다. ruby를 최신 버전으로 업데이트하고 tmuxinator를 설치합니다.

{% highlight bash linenos %}
brew install ruby
gem install tmuxinator
{% endhighlight %}

설치가 완료되었으면 `~/.zshrc`에 plugin과 alias를 추가합니다.

{% highlight bash linenos %}
plugins=(
  ...
  ...
  tmuxinator
)
alias mux="tmuxinator"
{% endhighlight %}

**샘플**

간단하게 샘플을 하나 만들어 봅니다. 블로그를 작성하는 환경을 만드는데 1번창을 두개로 나눠서 위에는 jekyll을 실행하고 아래는 ngrok으로 서버를 외부로 오픈합니다. 2번 창은 post폴더를 vi로 오픈해보겠습니다.

tmuxinator를 명령어가 너무 길어서 위에 설정에서 mux로 alias를 설정하였습니다. 새로 tmuxinator 프로젝트를 만들어보겠습니다.

{% highlight bash linenos %}
mux new jekyll
{% endhighlight %}

명령어를 실행하면 간단한 샘플이 포함된 jekyll 프로젝트 설정 파일이 `~/.config/tmuxinator/jekyll.yml` 만들어지고 자동으로 에디터가 열립니다. 설정 파일을 다음과 같이 작성합니다.

{% highlight yaml linenos %}
name: jekyll
root: ~/Workspace/github.com/subicura/subicura.github.io

windows:
  - server:
      layout: main-horizontal
      panes:
        - bundle exec jekyll serve --incremental
        - ngrok http 4000
  - editor: vim _posts
{% endhighlight %}

이제 프로젝트를 시작합니다.

{% highlight yaml linenos %}
mux start jekyll
{% endhighlight %}

{% asciinema path: 'asciinema/2017-11-22-mac-os-development-environment-setup/mux-demo.json', title: '' %}

샘플이라 약간 억지가 있어 보이는 구성이지만 스크립트 구성이 엄청나게 편하다는걸 알 수 있습니다. 전체 스크립트를 실행하고 intelliJ와 같은 IDE를 실행하게 구성할 수도 있습니다. 자세한 건 공식 홈페이지를 참고하세요.

[tmuxinator github](https://github.com/tmuxinator/tmuxinator)

## 추천 애플리케이션

기본적인 프로그램 외에 사용하면 꽤 쓸만한 프로그램을 소개합니다.

### docker

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/docker-for-mac.png)

따로 소개할 필요가 없을 정도로 유명한 가상화 프로그램입니다. MySQL, Redis와 같은 데이터베이스나 rails, php 개발환경까지 두루두루 사용하고 있습니다. 하나의 개발 피시에 여러버전의 MySQL이나 Redis를 설치하는 건 쉽지 않은데 docker를 사용하면 쉽고 간단하게 개발환경을 구축할 수 있습니다.

docker에 대한 자세한 내용은 [여기](/2017/01/19/docker-guide-for-beginners-1.html)서 확인하세요.

[Docker 홈페이지](https://www.docker.com/) / [Docker for mac download](https://www.docker.com/docker-mac)

### tig

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/tig.png)

텍스트모드 git 인터페이스 프로그램입니다. git 자체 기능이 강력하긴 하지만 여러 로그를 편하게 보기는 쉽지 않습니다. tig를 사용하여 화살표 키와 `h` `j` `k` `l`키를 잘 사용하면 쉽게 로그를 볼 수 있고 메인 화면에서 `h`를 누르면 도움말을 확인할 수 있습니다.

[tig github](https://github.com/jonas/tig)

### jq

![]({{ site.url }}/assets/article_images/2017-11-22-mac-os-development-environment-setup/jq.png)

JSON 결과를 이쁘게 보여주고 원하는 대로 편집할 수 있는 도구입니다. 간단하게 필터를 적용하여 원하는 항목만 볼 수 있고 특정 결과를 다른 형태로 변경할 수 있습니다.

[jq github](https://stedolan.github.io/jq/)

### ngrok

로컬 서버를 외부로 터널링을 통해 오픈해주는 도구입니다. 보통 로컬에 개발 서버를 띄우면 외부에서 접근하기가 어려운데 ngrok을 이용하여 간단하게 오픈할 수 있습니다. 사용법도 간단합니다.

[ngrok 홈페이지](https://ngrok.com/)

### asciinema

터미널을 **텍스트**로 녹화하는 프로그램입니다. 영상으로 녹화하는 것보다 용량이 적고 품질도 훌륭한 편입니다. 제 블로그에서 자주 볼 수 있습니다.

[asciinema 홈페이지](https://asciinema.org/)

### neofetch

지금 보고 있는 포스트 첫번째 이미지에서 사용한 프로그램입니다. 간단하게 시스템 상태를 보여줍니다.

[neofetch github](https://github.com/dylanaraps/neofetch)

## 그래서

너무 오랫동안 블로깅을 못 하고 있어서 가볍게 ~~급하게~~ 작성한 포스트입니다. 새로 산 맥북프로를 셋팅하고 설치 프로그램 목록을 정리하던 중에 우연찮게 몇몇 분들한테 터미널 설정에 대한 질문을 받으면서 환경설정에 대한 글을 쓰면 괜찮다고 생각했습니다.

커맨드라인 애플리케이션은 알면 알수록 새로운 것도 많고 개발자들 취향에 따라 설정이 조금씩 다르므로 가장 무난한 설정을 소개했고 대부분의 커스텀 설정은 수정하지 않았습니다. 설정이 굉장히 다양하므로 각 프로그램이 어떤 설정을 제공하는지는 꼭 한 번씩 보면 좋을 것 같습니다.

최근 개발 모임이나 세미나에 참석해보면 맥북을 사용하시는 분들이 많고 개발자라면 계속해서 터미널을 사용하므로 아직 제대로 개발 환경을 구축하지 못한 분들에게 많은 도움이 되었으면 좋겠습니다. 그리고 괜찮은 도구 있으면 댓글로 추천해주세요! 더 좋은, 편안한 환경에서 개발하고 싶습니다.

다른 ~~고오오급~~개발자들이 어떤 환경에서 작업하는지 궁금하다면 [usesthis.com](https://usesthis.com)에 인터뷰가 있으니 참고하시고 커스텀하게 변경한 환경설정 파일은 Dropbox나 Google Drive 등으로 파일을 링크(`ln -s`)하여 백업하거나 [dotfiles](https://dotfiles.github.io/) 도구를 사용하여 백업하면 나중에 새로운 맥이 생겨도 동일한 환경을 빠르게 설정할 수 있습니다.

