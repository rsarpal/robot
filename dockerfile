#FROM ubuntu:xenial
FROM python:3
RUN python3 -m pip install robotframework
RUN python3 -m pip install robotframework-selenium2library

# We need wget to set up the PPA and xvfb to have a virtual screen and unzip to install the Chromedriver
#RUN apt-get install -y wget xvfb unzip
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y wget xvfb unzip

#RUN sudo apt-get install -y  xvfb


# Set up the Chrome 
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo  "deb http://dl.google.com/linux/chrome/deb/ stable main"  >> /etc/apt/sources.list.d/google.list 

# Update the package list and install chrome
RUN  apt-get update -y
RUN  apt-get install -y google-chrome-stable

# Set up Chromedriver Environment variables
#ENV  CHROMEDRIVER_VERSION 2.19
ENV CHROMEDRIVER_VERSION 79.0.3945.36
ENV  CHROMEDRIVER_DIR /chromedriver
RUN  mkdir $CHROMEDRIVER_DIR

# Download and install Chromedriver
RUN  wget -q --continue -P $CHROMEDRIVER_DIR "http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
RUN  unzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

# Put Chromedriver into the PATH
#ENV PATH $CHROMEDRIVER_DIR:$PATH

#Firefox
RUN apt-get install -y firefox-esr

# Set up Geckodriver Environment variables
ENV GECKODRIVER_VERSION 0.26.0
ENV GECKODRIVER_DIR /geckodriver
RUN mkdir $GECKODRIVER_DIR

# Download and install Geckodriver
#RUN  wget -q --continue -P $GECKODRIVER_DIR "https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz"
#RUN  gunzip $CHROMEDRIVER_DIR/chromedriver* -d $CHROMEDRIVER_DIR

RUN wget --no-verbose -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/v$GECKODRIVER_VERSION/geckodriver-v$GECKODRIVER_VERSION-linux64.tar.gz \
#  && rm -rf $GECKODRIVER_DIR \
  && tar -C $GECKODRIVER_DIR -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv $GECKODRIVER_DIR/geckodriver /$GECKODRIVER_DIR/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 $GECKODRIVER_DIR/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs $GECKODRIVER_DIR/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver \
  && ln -fs $GECKODRIVER_DIR/geckodriver-$GECKODRIVER_VERSION /usr/bin/wires

# Put Chromedriver & Geckodriver into the PATH
ENV PATH $CHROMEDRIVER_DIR:$GECKODDRIVER_DIR:$PATH
