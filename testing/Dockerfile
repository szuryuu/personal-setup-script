FROM archlinux

RUN pacman -Syu --noconfirm sudo \
    && useradd -m tedt \
    && echo "tedt ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER tedt
WORKDIR /home/tedt

CMD ["sleep", "infinity"]
