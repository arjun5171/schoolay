FROM ruby:2.5.1
RUN apt-get update -qq && \
	apt-get install -y build-essential \
	python-dev \
	nginx-extras \
	pkg-config \
	cmake \
	libxrender1 \
	default-libmysqlclient-dev \
	ncurses-dev gettext \
	flex \
	bison \
	autoconf \
	binutils-doc \
	redis-tools \
	vim \
	jq
RUN mkdir -p schoolay/pids
WORKDIR schoolay
COPY . .
RUN bundle install

RUN mv start_server /bin/ && chmod +x /bin/start_server
EXPOSE 3000