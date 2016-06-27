FROM ubuntu:14.04
MAINTAINER Rihards Grichkus "rihards.grichkus@applyit.lv"

#install stuff for building & qt installation
RUN apt-get update && apt-get install -y \
	git \
	build-essential \
	perl \
	libssl-dev \
	libdw-dev \
	libmysqlclient18 \
	libmysqlclient-dev

#options for qt configure script
COPY qt-build-opts.txt qt-build-opts.txt

#installing qt
RUN git clone git://code.qt.io/qt/qt5.git qt5  && \
	cd qt5 && \
	git checkout 5.4 && \
	perl init-repository --no-webkit --no-update -module-subset=qtbase && \
	mkdir make_dir && cd make_dir && \
	QT_BUILD_OPTS=$(cat /qt-build-opts.txt) && \
	/qt5/configure $QT_BUILD_OPTS -qt-sql-mysql && \
	make -j4 && \
	make install

#letting others know where qt & qmake reside 
ENV PATH=/usr/local/Qt-5.4.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV QTDIR=/usr/local/Qt-5.4.3/
