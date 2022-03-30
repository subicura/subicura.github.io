---
published: true
title: 쿠버네티스 시작하기 - 설치부터 배포까지
series: 2/2
categories: Kubernetes
tags: [Kubernetes, Docker, DevOps, Server]
layout: post
excerpt: 쿠버네티스 설치부터 배포까지는 https://subicura.com/k8s/ 에서 확인해주세요!
ogimage: /assets/og/2020-12-14-kubernetes-basic-2-summary.png
comments: yes
toc: true
---

"쿠버네티스 설치부터 배포"는 [여러가지 고민](#왜-블로그가-아닌가요) 끝에 [새로운 페이지](https://subicura.com/k8s/)로 작성하였습니다.

👇 하단 링크를 클릭해 주세요!

<p align="center">
    <a href="https://subicura.com/k8s/?utm_source=subicura.com&utm_medium=referral&utm_campaign=blog" target="_blank">
        <img src="{{ "/assets/article_images/2020-12-14-kubernetes-basic-2/subicura-k8s.png"  | prepend: site.baseurl  }}" alt="초보를 위한 쿠버네티스 안내서" style="width: 350px">
    </a>
</p>

그리고 실습 영상과 함께 자세한 설명을 들을 수 있는 [온라인 강의](https://bit.ly/inflearn-k8s-link)도 준비되어 있습니다.

[![초보를 위한 쿠버네티스 안내서 - 인프런]({{ site.url }}/assets/article_images/2020-12-14-kubernetes-basic-2/inflearn-k8s.png)](https://bit.ly/inflearn-k8s-link)


---

* [쿠버네티스 시작하기 - 쿠버네티스란 무엇인가?]({% post_url 2020-12-13-kubernetes-basic-2 %}) <span class="series">SERIES 1/2</span>
* **쿠버네티스 시작하기 - 설치부터 배포까지 ✓** <span class="series">SERIES 2/2</span>

{% googleads class_name: 'googleads-content', ads_id: 'google_ad_slot_2_id' %}

---

## 왜 블로그가 아닌가요?

~~왜 이렇게 늦었죠?~~

원래 계획은 [쿠버네티스 시작하기 - 쿠버네티스란 무엇인가?]({% post_url 2020-12-13-kubernetes-basic-2 %}) 글을 작성하고 설치, 배포, 스토리지, 설정, 비밀정보에 대해 시리즈를 작성하는 것이었습니다.

하지만, 1년~~하고도 6개월~~이 넘게 2번째 글을 작성하지 못했는데.. 가장 큰 이유는 생각보다 **쿠버네티스가 더 크고 방대**했던 것입니다.

2번째 시리즈 "쿠버네티스 설치"에 대해서 초기에 정리한 내용입니다.

**개발 환경 vs 운영 환경**
- 개발 환경은 Docker for desktop, minikube, kind, k3s가 있고 운영환경은...

**일반서버(On-Premise) vs 클라우드(Cloud)**
- 회사에서 직접 서버를 관리하는 경우는 kubeadm, kubespray, rancher, openshift가 있고 클라우드는..

**AWS vs Google Cloud vs Azure**
- 대표적인 3사 클라우드가 있지만 ncloud, digital ocean도 많이 쓰는거 같고 AWS를 대표로 설명한다면..

**AWS - KOPS vs EKS**
- AWS의 관리형 k8s서비스 EKS가 좋긴한데 컨트롤 플레인을 직접 제어할 수 없으니 KOPS도 필요할 것 같고 EKS를 쓴다면...

**AWS EKS - Self Managed Nodes vs Managed Node Group vs Fargate**
- EKS에서 노드를 관리하는 방법을 골라야 하는데 직접 관리하거나 관리형 서비스를 쓰거나 fargate를 쓰거나..? 근데 설치는 terraform이 나을지 eksctl이 나을지..

**CNI(Container Network Interface) - Kube Router vs Weave Net vs Calico vs Cillium vs ...**
- 쿠버네티스의 장점은 원하는대로 인프라를 구성하는건데 네트워크 플러그인도 각자 특성이 있는데..

**CRI(Container Runtime Interface) - docker vs containerd vs CRI-O vs ...**
- 도커는 곧 deprecated된다고 하고 containerd도 알고 CRI-O를 사용하는 법도 알아야 하지 않을까?

**Ingress Controller - nginx vs haproxy vs traefik vs alb vs ...**
- Ingress 설명할 때 어떤 컨트롤러를 설명하는게 좋을지.. 다 장단이 있는것 같은데..

**Single Cluster vs Multi Cluster vs Anthos**
- 처음 한번 클러스터를 구성하면 변경이 어려워서 바로 적용하진 않더라도 다중 클러스터나 anthos 개념은 알아두는게 좋을것 같고..

**no service mesh vs istio vs linked**
- 이왕 쿠버네티스 시작하는거 서비스 메시 기술을 적용하면 좋을 것 같은데..

**무중단 클러스터 업데이트**
- 쿠버네티스는 설치가 끝이 아니고 주기적(3개월)으로 업데이트를 해야 하는데 무중단 업데이트하는 방법과 주의점도 소개해야 하지 않을까?

음... 설치만 이정도? 🤔

보통 어떤 기술은 널리 쓰이는 대표적인 방법이 1~2개 있기 마련인데 쿠버네티스는 그런게 없습니다. 설치부터 그 종류가 너무너무너무 다양합니다. 여러가지 요구사항에 따라, 각자의 환경에 따라 설치 방법이 다르고 심지어 업데이트 속도도 빨라서 어제 작성한글이 내일 쓸모 없는 일이 벌어졌습니다.

그렇게 고민고민 하다가 최대한 간단하게 "초보를 위한 입문용 글을 쓰자!"라고 결론을 내렸지만, 또 다른 문제가 있었습니다.

1. 쿠버네티스 생태계는 변화가 빠름 (꾸준히 업데이트가 필요함)
2. 쿠버네티스 설정(YAML) 내용이 복잡함 (설정 코드만 한페이지가 넘어감)
3. 쿠버네티스는 리소스 중심으로 설명이 필요한데 글로 내용을 구성하기 어려움
4. 사용중인 OS나 클라우드 환경에 따라 필요한 내용이 다름

이 문제를 어떻게 잘 풀 수 있을까 또 다시 고민을 했고 2020년 12월이 가까워지면서 어떻게든 해가 넘어가기 전에 정리를 하고 싶었습니다.

그때 발견한 것이 [VuePress](https://vuepress.vuejs.org/) 입니다.

<p align="center">
    <img src="{{ "/assets/article_images/2020-12-14-kubernetes-basic-2/vuepress.png"  | prepend: site.baseurl  }}" style="width: 350px">
</p>

VuePress는 지금 이 블로그에서 사용하고 있는 [Jekyll](https://jekyllrb-ko.github.io/)처럼 마크다운 문서를 이용하여 정적인 웹 페이지를 만들 수 있고 [GitHub Page](https://pages.github.com/)로 배포할 수 있습니다. (vue를 전혀 몰라도 사용할 수 있습니다) 차이점은 블로그보다는 문서화에 초점을 맞췄다는 점입니다.

몇가지 기능을 살펴보고 지금까지 고민했던 것을 해결해 줄 것 같았습니다. 메뉴를 이용하여 구조적으로 문서를 관리할 수 있고 확장도 손쉬운 구조입니다. 강력한 코드 문법 하이라이팅기능과 필요하면 vue 컴포넌트를 그대로 사용할 수 있어 새로운 기능도 자유롭게 추가할 수 있습니다. 블로그 형식으로 설명하기 어려운 걸 해결!

그렇게 기본적인 실습 내용을 작성했고 앞으로 꾸준하게 관리할 예정입니다. 쿠버네티스를 정복하는 그날까지.. ~~영원히라는 뜻~~ 많이 애용해주세요!

---

* [쿠버네티스 시작하기 - 쿠버네티스란 무엇인가?]({% post_url 2020-12-13-kubernetes-basic-2 %}) <span class="series">SERIES 1/2</span>
* **쿠버네티스 시작하기 - 설치부터 배포까지 ✓** <span class="series">SERIES 2/2</span>

---
