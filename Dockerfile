FROM appium/appium:v2.5.1-p3

ENV NO_PROXY=no_proxy
ENV HTTP_PROXY=proxy
ENV HTTPS_PROXY=proxy
ENV https_proxy=proxy
ENV http_proxy=proxy
ENV no_proxy=no_proxy

USER root

RUN apt-get update &&\
    apt-get dist-upgrade -y &&\
    apt-get clean && rm -rf /var/lib/apt/lists/
RUN apt-get update && \
    apt-get install -y python3.8 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/
RUN apt-get -y --no-install-recommends install \
    ca-certificates && \
    python3 -m pip install --upgrade pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY adbkeys/* /root/.android/
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt
RUN npm -g install npm@10.2.4
ENV APPIUM_SKIP_CHROMEDRIVER_INSTALL=true
RUN appium driver install uiautomator2@3.0.2


ENV NO_PROXY=
ENV HTTP_PROXY=
ENV HTTPS_PROXY=
ENV https_proxy=
ENV http_proxy=
ENV no_proxy=
