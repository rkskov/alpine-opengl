FROM alpine:3.7

# Setup environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	DISPLAY=:0.0 \
	DISPLAY_WIDTH=1024 \
	DISPLAY_HEIGHT=768

# x11vnc is in testing repo
RUN echo “http://dl-3.alpinelinux.org/alpine/edge/testing” >> /etc/apk/repositories
RUN apk update 
RUN apk add —no-cache mesa mesa-demos fluxbox \ 
    git socat supervisor x11vnc xterm xvfb

# Clone noVNC from github
RUN git clone https://github.com/kanaka/noVNC.git /root/noVNC \
	&& git clone https://github.com/kanaka/websockify /root/noVNC/utils/websockify \
	&& rm -rf /root/noVNC/.git \
	&& rm -rf /root/noVNC/utils/websockify/.git \
	&& apk del git

# Modify the launch script ‘ps -p’
RUN sed -i — “s/ps -p/ps -o pid | grep/g” /root/noVNC/utils/launch.sh

EXPOSE 8080

CMD [“/usr/bin/supervisord”, “-c”, “/etc/supervisor/conf.d/supervisord.conf”]