FROM ubuntu:16.04
MAINTAINER Rihards Grichkus "rihards.grichkus@applyit.lv"

#install stuff for building, qt installation & library dependencies
RUN apt-get update && apt-get install -y \
	git \
	build-essential \
	perl \
	libssl-dev \
	libdw-dev \
	curl \
	libcurl4-gnutls-dev
RUN apt-get install -y software-properties-common && \
	add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty main universe' && \
	apt-get update
RUN apt-get install -y -t=trusty libmysqlclient-dev libmysqlclient18

#options for qt configure script
COPY qt-build-opts.txt qt-build-opts.txt

#installing qt
RUN git clone git://code.qt.io/qt/qt5.git qt5  && \
	cd qt5 && \
	git checkout 5.4 && \
	perl init-repository --no-webkit --no-update -module-subset=qtbase && \
	mkdir make_dir && cd make_dir && \
	QT_BUILD_OPTS=$(cat /qt-build-opts.txt) && \
	/qt5/configure $QT_BUILD_OPTS -qt-sql-mysql -v && \
	make -j4 && \
	make install && \
	cd / && rm -rf qt5

#letting others know where qt & qmake reside
ENV PATH=/usr/local/Qt-5.4.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV QTDIR=/usr/local/Qt-5.4.3/
