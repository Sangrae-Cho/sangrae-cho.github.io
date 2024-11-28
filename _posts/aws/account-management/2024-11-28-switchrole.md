---
title: "[AWS][계정 분산 관리] 5. Switch Role 활용: 통합 콘솔 관리(完)"
description: AWS|계정 분산 관리|Switch Role|통합 콘솔 관리
date: 2024-11-28 12:00:00 +0900
categories: [AWS, 계정 분산 관리]
tags: [AWS,계정분산관리,Switch Role]
pin: false
math: false
mermaid: false
image: assets/img/aws/account-management/2024-11-28-switchrole/1.png
---
## **1. Switch Role**

- 통합 관리 계정에서 **IAM 사용자**를 생성하고, 교차 계정 간 **Switch Role**을 통해 AWS 콘솔에 접근하도록 합니다. 이를 통해 얻을 수 있는 이점은 아래와 같습니다.  
(참고: [AWS 공식 문서 - 사용자에게 역할을 전환할 권한 부여](https://docs.aws.amazon.com/ko_kr/IAM/latest/UserGuide/id_roles_use_permissions-to-switch.html))

  >1. **보안 강화**  
  >IAM 그룹 또는 사용자에게 필요한 최소 권한만 부여하고 정책을 설정할 수 있어, 역할 기반 보안 관리가 가능합니다.  
  >
  >2. **운영 효율성 증대**  
  >통합 관리 계정의 IAM 사용자만으로 각 프로젝트 계정에 접근할 수 있어 작업 속도가 빨라지고 관리 복잡성이 감소합니다.  
  >AWS 콘솔에서 간단히 역할 전환을 선택할 수 있어 다중 계정 환경에서도 직관적인 작업이 가능합니다.  
  >
  >3. **관리 비용 절감**  
  >각 계정에서 별도로 IAM 사용자를 설정하고 관리할 필요가 없어 시간과 비용을 절약할 수 있습니다.  
  >또한, 하나의 계정에서 다른 계정의 리소스에 액세스할 수 있으므로 중복된 인프라 구축을 피할 수 있습니다.  

- 이 글에서는 **모든 권한**을 가진 구성원에게 IAM 사용자 계정을 부여한다는 가정하에 작성되었습니다.
- IAM 사용자 계정은 프로젝트의 `ManagerRole`만으로 역할 전환을 할 수 있도록 설계했습니다. 구조는 아래와 같습니다.  
![Desktop View](/assets/img/aws/account-management/2024-11-28-switchrole/1.png)

---

## **2. 구성 방법**

> **사전 조건**:  
>
> - 통합 관리 계정에 **IAM 사용자** 계정이 최소 하나 이상 필요합니다.
{: .prompt-warning }

### 1. 프로젝트 계정에 ManagerRole 생성

1. 프로젝트 AWS 계정 콘솔의 IAM 메뉴로 접근합니다.  
   `액세스 관리` → `역할` → `역할 생성`을 선택합니다.
2. **신뢰할 수 있는 엔터티 유형** 단계에서 **사용자 지정 신뢰 정책**을 선택하고 아래와 같이 입력합니다.

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "AWS": "arn:aws:iam::<통합 관리 계정의 ID>:root"
         },
         "Action": "sts:AssumeRole"
       }
     ]
   }
   ```

3. **권한 추가** 단계에서 `AdministratorAccess`를 선택하고, 마지막 단계에서 이름을 `ManagerRole`로 설정하여 생성합니다.

> 모든 권한을 부여한 예제입니다. 팀 또는 부서에 따라 필요한 권한만 부여하도록 설계하는 것이 권장됩니다.
{: .prompt-info }

---

### 2. 통합 관리 계정에 ManagerRolePolicy 생성

1. 통합 관리 AWS 계정 콘솔의 IAM 메뉴로 접근합니다.  
   `액세스 관리` → `정책` → `정책 생성`을 선택합니다.
2. **권한 지정** 단계에서 **JSON 편집**을 선택하고 아래 내용을 입력합니다.  
   (ManagerRole 외의 역할 사용을 제한합니다.)

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Deny",
         "Action": "sts:AssumeRole",
         "NotResource": "arn:aws:iam::<프로젝트 계정의 ID>:role/ManagerRole"
       }
     ]
   }
   ```

3. 마지막 단계에서 정책 이름을 `ManagerRolePolicy`로 설정한 후 저장합니다.

> `NotResource`는 리스트 형식으로 여러 계정을 관리할 수 있습니다.
{: .prompt-info }

---

### 3. 통합 관리 계정에 managers 그룹 생성 및 IAM 사용자 추가

1. 통합 관리 AWS 계정 콘솔의 IAM 메뉴로 접근합니다.  
   `액세스 관리` → `사용자 그룹` → `그룹 생성`을 선택합니다.
2. **그룹 이름**을 `managers`로 설정하고, `ManagerRole`을 이용해 Switch Role을 할 사용자를 그룹에 추가합니다.
3. **권한 정책 연결** 단계에서 위에서 생성한 `ManagerRolePolicy`를 추가하고 그룹을 생성합니다.

> 팀 또는 부서별로 그룹을 구성하면 관리가 더 용이해집니다.
{: .prompt-info }

---

### 4. Switch Role을 통해 프로젝트 계정의 콘솔에 접근

1. IAM 사용자 계정으로 로그인 후 **Switch Role** 기능에 접근합니다.  
   ![Desktop View](/assets/img/aws/account-management/2024-11-28-switchrole/2.jpg)
2. **프로젝트 계정의 ID**와 **ManagerRole**을 입력한 뒤, 역할을 전환합니다.  
   전환 후 프로젝트 계정의 콘솔에 정상적으로 접근이 가능한지 확인합니다.  
   ![Desktop View](/assets/img/aws/account-management/2024-11-28-switchrole/3.jpg)

## 3. 주요 요약

- Switch Role 활용: 통합 관리 계정의 IAM 사용자 계정을 생성해 교차 계정 간 접근을 효율적으로 관리.

## 4. AWS 계정 분산 관리 전략 정리

이번 시리즈에서는 **VPC Peering**, **Bastion Host Server**, **NAT Server**, **Switch Role** 활용으로 AWS 환경에서 멀티 계정 및 네트워크 관리 전략 중심의 구성 방법과 접근 방식을 살펴보았습니다.
이번 시리즈에서 다룬 전략들이 여러분의 AWS 인프라 관리에 실질적인 도움이 되길 바랍니다.

끝까지 읽어 주셔서 감사합니다!

---
**이전 글:** **[[AWS][계정 분산 관리] 4. NAT Server & Port Forwarding: NAT Server를 사용해 프로젝트별 Private Subnet 접근]({{site.url}}/posts/aws-계정-분산-관리-4-nat-server-port-forwarding-nat-server를-사용해-프로젝트별-private-subnet-접근/)**
