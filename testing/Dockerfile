FROM archlinux

RUN pacman -Syu --noconfirm sudo \
    && useradd -m tedt \
    && echo "tedt ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER tedt
WORKDIR /home/tedt

COPY --chown=tedt:tedt folder-setup.sh removing-folders.sh ./
RUN chmod +x folder-setup.sh removing-folders.sh

RUN ./folder-setup.sh

RUN test -d Personal/projects/cli && \
    test -d Personal/archives/project-completed && \
    echo "Folder structure verified successfully"

CMD ["sleep", "infinity"]
