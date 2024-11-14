---
title: "[알고리즘][최소 신장 트리(MST)] 크루스칼(Kruskal) 알고리즘"
description: 알고리즘|최소 신장 트리(MST)|크루스칼(Kruskal) 알고리즘
date: 2024-11-14 19:00:00 +0900
categories: [알고리즘, 최소 신장 트리(MST)]
tags: [알고리즘,최소신장트리,크루스칼,Algorithm,MST,MinimumSpanningTree,Kruskal]
pin: false
math: false
mermaid: false
image: assets/img/algorithm/2024-11-14-mst-kruskal/1.jpg
---

## 크루스칼(Kruskal) 알고리즘 이란?

- [최소 신장 트리(MST)]({{site.url}}/posts/*/mst)를 찾는 대표적인 방법 중 하나가 크루스칼(Kruskal) 알고리즘이다.<br>
- **간선 중심의 알고리즘**으로, **가중치가 가장 작은 간선**을 **사이클을 형성하지 않는 조건**에서 **선택**하는 방법이다.<br>
- 사이클 검사를 위해 **Union-Find** 자료구조를 이용하는 것이 특징이다.

## 동작 과정

1. 모든 간선을 **가중치**의 **오름차순**으로 정렬.
2. **가장 낮은 가중치**의 간선부터 시작해 **사이클이 생기지 않는다면** 선택.
3. 정점 수가 `V`라면, 선택된 간선이 `V-1`개일 때 종료.

![Desktop View](/assets/img/algorithm/2024-11-14-mst-kruskal/2.jpg)

## 시간 복잡도

- 간선의 개수를 `E` 정점의 개수를 `V` 라고 한다면 시간 복잡도는 아래와 같다.

> 1. 간선 오름차순 정렬: `O(E log E)`
> 2. Union-Find 연산: `O(E log V)`

- 모든 간선을 정렬해야하므로 간선의 수가 적을 수록 유리하다. 즉, **희소 그래프**에서 효율적이다.
