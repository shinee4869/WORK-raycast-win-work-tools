# 🔓 Unlock PDF — Raycast Extension (Windows)

비밀번호가 걸린 PDF 파일의 잠금을 해제하는 Raycast Extension입니다.

---

## 📋 목차

1. [사전 요구사항](#-사전-요구사항)
2. [설치 방법](#-설치-방법)
   - [1. Node.js 설치](#1-nodejs-설치)
   - [2. Git 설치](#2-git-설치)
   - [3. qpdf 설치](#3-qpdf-설치)
   - [4. qpdf 환경변수 등록](#4-qpdf-환경변수-등록)
   - [5. Raycast 설치](#5-raycast-설치)
   - [6. Extension 설치](#6-extension-설치)
3. [사용 방법](#-사용-방법)
4. [문제 해결](#-문제-해결)

---

## 💻 사전 요구사항

- Windows 10 이상
- PowerShell (관리자 권한)
- 인터넷 연결

---

## 🚀 설치 방법

> ⚠️ 모든 명령어는 **PowerShell을 관리자 권한으로 실행**한 후 입력하세요.
>
> 시작 메뉴 → `PowerShell` 검색 → 우클릭 → **관리자 권한으로 실행**

---

### 1. Node.js 설치

```powershell
winget install OpenJS.NodeJS.LTS
```

설치 완료 후 PowerShell을 **완전히 종료하고 다시 실행**한 뒤 확인합니다.

```powershell
node -v
npm -v
```

아래와 같이 버전 정보가 출력되면 정상입니다.

```
v20.x.x
10.x.x
```

> ❗ `npm -v` 가 인식되지 않는 경우 아래 명령어를 실행하세요.
>
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```
>
> 이후 PowerShell을 재시작하고 다시 확인하세요.

---

### 2. Git 설치

```powershell
winget install --id Git.Git -e
```

설치 완료 후 PowerShell을 **완전히 종료하고 다시 실행**한 뒤 확인합니다.

```powershell
git --version
```

아래와 같이 버전 정보가 출력되면 정상입니다.

```
git version 2.x.x.windows.x
```

---

### 3. qpdf 설치

```powershell
winget install qpdf.qpdf
```

설치 완료 후 PowerShell을 **완전히 종료하고 다시 실행**한 뒤 확인합니다.

```powershell
qpdf --version
```

아래와 같이 버전 정보가 출력되면 정상입니다.

```
qpdf version 12.x.x
```

> ❗ `qpdf` 가 인식되지 않는 경우 **4번 환경변수 등록** 단계를 진행하세요.

---

### 4. qpdf 환경변수 등록

`qpdf --version` 이 정상 출력되면 이 단계는 건너뜁니다.

#### 4-1. qpdf 설치 경로 확인

파일 탐색기에서 아래 경로를 확인하세요.

```
C:\Program Files\
```

`qpdf` 또는 `qpdf 12.x.x` 와 같은 이름의 폴더를 찾습니다.

예시:

```
C:\Program Files\qpdf 12.2.0\bin
```

#### 4-2. 환경변수 등록

시작 메뉴에서 **"환경 변수"** 를 검색합니다.

```
시스템 환경 변수 편집 → 환경 변수 → 시스템 변수 → Path → 편집 → 새로 만들기
```

아래 경로를 추가합니다. (본인의 실제 경로로 변경하세요)

```
C:\Program Files\qpdf 12.2.0\bin
```

**확인** 을 눌러 저장한 뒤 PowerShell을 재시작하고 다시 확인합니다.

```powershell
qpdf --version
```

아래와 같이 버전 정보가 출력되면 정상입니다.

```
qpdf version 12.x.x
```

---

### 5. Raycast 설치

```powershell
winget install Raycast.Raycast
```

설치 완료 후 Raycast를 실행합니다.

> 💡 기본 단축키는 `Alt + Space` 입니다.

---

### 6. Extension 설치

#### 6-1. 원하는 폴더에 Clone

```powershell
git clone https://github.com/shinee4869/WORK-raycast-win-unlock-pdf.git
cd unlock-pdf
```

#### 6-2. 패키지 설치

```powershell
npm install
```

#### 6-3. 실행

```powershell
npm run dev
```

Raycast에서 **Unlock PDF** 명령어가 보이면 설치 완료입니다. ✅

> 💡 `npm run dev` 를 종료해도 Raycast에서 Extension은 계속 사용할 수 있습니다.
>
> 코드를 수정할 때만 다시 `npm run dev` 를 실행하면 됩니다.

---

## 📖 사용 방법

1. `Alt + Space` 로 Raycast 실행
2. `Unlock PDF` 검색 후 선택
3. **PDF 파일 선택** 버튼으로 잠금 해제할 PDF 선택
4. **비밀번호 선택** 드롭다운에서 해당 비밀번호 선택
   - 목록에 없는 경우 **그 외** 선택 후 직접 입력
5. `Ctrl + Enter` 로 실행
6. 원본 파일과 같은 폴더에 `파일명_unlocked.pdf` 로 저장됩니다.

---

## 🛠 문제 해결

### `node` 또는 `npm` 이 인식되지 않는 경우

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

PowerShell 재시작 후 다시 확인하세요.

---

### `qpdf` 이 인식되지 않는 경우

```powershell
where.exe qpdf
```

경로가 출력되지 않으면 **4번 환경변수 등록** 단계를 다시 진행하세요.

---

### `npm install` 실패하는 경우

```powershell
npm cache clean --force
npm install
```

---

### Raycast에서 Extension이 보이지 않는 경우

```powershell
npm run dev
```

을 실행한 상태에서 Raycast를 다시 열어보세요.

---

### PDF Unlock 실패하는 경우

- 비밀번호가 올바른지 확인하세요.
- PDF 파일 경로에 한글이나 특수문자가 포함된 경우 오류가 발생할 수 있습니다.
- 파일이 이미 열려 있는 경우 닫은 후 다시 시도하세요.

---

## 📁 프로젝트 구조

```
unlock-pdf/
├─ src/
│  ├─ unlock-pdf.tsx       # 메인 Extension 코드
│  └─ data/
│     └─ passwords.json    # 비밀번호 설정 파일
├─ package.json
├─ tsconfig.json
└─ README.md
```
