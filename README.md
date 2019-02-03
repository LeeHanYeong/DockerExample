# Docker!

배포와 관련된 모든 내용은 AWS의 클라우드 서비스를 기반으로 합니다.

### 추천

파이썬을 설치한다면 **pyenv**, **pyenv-virtualenv**로 관리합시다!

문서참조 -> [pyenv와 virtualenv를 사용한 파이썬 개발환경 구성](https://lhy.kr/configuring-the-python-development-environment-with-pyenv-and-virtualenv)



### 참고문서

- [subicura](https://subicura.com/)
    - [도커 기초 확실히 다지기](https://futurecreator.github.io/2018/11/16/docker-container-basics/)
- [Eric Han](https://futurecreator.github.io/)
    - [개발자를 위한 인프라 기초 총정리](https://futurecreator.github.io/2018/11/09/it-infrastructure-basics/)
    - [초보를 위한 도커 안내서](https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html)

- [44BITS](https://www.44bits.io/ko)
    - [아마존 엘라스틱 컨테이너 서비스(ECS) 입문](https://www.44bits.io/ko/post/container-orchestration-101-with-docker-and-aws-elastic-container-service)
    - [ECS의 매니지드 컨테이너 AWS 파게이트 시작하기](https://www.44bits.io/ko/post/getting-started-with-ecs-fargate)
- [lhy.kr](https://lhy.kr/)
    - [AWS EC2에 Nginx, uWSGI를 사용하여 Django배포](https://lhy.kr/ec2-ubuntu-deploy)
    - [AWS ElasticBeanstalk의 Docker플랫폼을 사용한 Django배포](https://lhy.kr/eb-docker)



### 목차

- 로컬에서 서버 띄워보기

    - **brew**를 사용한 **Python3** 설치  
      `brew install python3`
    -  Django 설치  
       `pip3 install django`  
       `django-admin.py startproject mystie`
    - **runserver** 실행  
      `cd mysite`  
      `python3 manage.py runserver`  
    - **requirements.txt** 만들기
      `pip3 freeze > requirements.txt` or `vim requirements.txt > django==3.5.1 \n pytz==2018.9`

- 로컬 Docker에서 서버 띄워보기

    - **Docker** 설치
      인터넷에서 `Docker for mac` 설치.  
    - **python:3.7.2-slim**으로부터 **runserver** 실행해보기  
      `docker run --rm -it python:3.7.2-silm /bin/bash`  
    -  Docker Port 설정&외부 포트연결하기.
      `docker run --rm -it -p 7999:8000 python:3.7.2-slim /bin/bash`  
    -  Docker Port 확인 하기.
      `docker ps`  

- 로컬 Docker Image에서 서버 띄워보기

    - **Dockerfile**작성
      `vim Dockerfile`  
      ```dockerfile
      # EXAMPLE
      # 실행할 명령어
      RUN pip install django

      # cd(change directory)
      WORKDIR /src

      RUN django-admin startproject mysite
      WORKDIR /src/mysite

      CMD python manage.py runserver 0:8000
      ```
    - **Dockerfile**을 사용해서 이미지 생성
      ```Dockerfile
      FROM       python:3.7.2-slim
      MAINTAINER joenggyu0@gmail.COPY
      # 설치할 패키지 정보가 담긴 파일을 Image의 /tmp/에 복사
      COPY  requirements.txt /tmp/requirements.txt

      # requirements.txt 파일을 이용해서 Images에 파이썬 ㅋ패키지 설치
      RUN pip install -r /tmp/requirements.txt

      # 현재 디렉토리의 모든 내용을 Image의 /srv/경로에 복사
      COPY . /srv/project/

      #복사한 소스 경로로 이동후 개발서버를 8000번 포트로 실행
      WORKDIR /srv/project

      CMD python manage.py runserver 0:8000
      ```
    - 생성한 이미지로 **runserver** 실행해보기
      `docker build -t mysite .`  
      build를 어디서 하는가에 대한 디렉토리 이슈 조심!
      `docker run --rm -it -p 7999:8000 mysite`  
- EC2에서 서버 띄워보기

    - EC2 생성하기

        - 보안그룹 생성
            - HTTP프로토콜의 인바운드 설정
            - SSH프로토콜의 인바운드 설정
        - 키 페어 생성
            - **.pem**파일을 **~/.ssh** 폴더로 이동
        - EC2 생성
            - 보안그룹 선택
            - 키페어 선택

    - [EC2에 접속하기](https://docs.aws.amazon.com/ko_kr/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

        - SSH접속에 키페어 사용
            - **chmod**를 사용한 개인키 파일 모드 변경

    - Django설치 및 runserver

        - ```shell
            sudo apt update
            sudo apt install python3-pip
            pip3 install django
            # 재접속
            mkdir ~/example
            cd ~/example
            django-admin startproject app
            cd app
            sudo python3 manage.py runserver 0:80
            ```

        - **DISALLOWED_HOSTS**를 vim으로 해결하기

- EC2에서 Docker를 사용해 서버 띄워보기

    - [설치](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

    - ```
        sudo apt update
        sudo apt install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
           $(lsb_release -cs) \
           stable"
        sudo apt update
        sudo apt install docker-ce docker-ce-cli
        ```

    - **scp**를 사용해 EC2로 파일 복사하기

        - `scp -i ~/.ssh/<PEM_FileName>.pem -r . ubuntu@<EC2_Public_Domain>:/home/ubuntu/docker/`

    - Docker Image **Build**

        - `sudo docker build -t example .`

    - **DISALLOWED_HOSTS**를 코드 수정 후 **scp**로 다시 복사해서 해결

        - ssh로 서버 코드 삭제
        - scp로 재업로드

- [**DockerHub**](https://hub.docker.com/)에 Docker Image 업로드하고 서버 띄워보기

    - docker login
    - docker tag <이미지명> <사용자명>/<저장소명>
    - docker push <사용자명>/<저장소명>
    - EC2에서 docker run시켜보기

- **ElasticBeanstalk**을 사용해서 서버 띄워보기

    - ` git archive -v -o app.zip --format=zip HEAD`

- **Route53**으로 서버 연결시켜보기

    - **Route53**에 도메인 등록
    - 등록한 도메인의 A레코드를 **ElasticBeanstalk**환경에 연결 
