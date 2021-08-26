FROM ruby:2.6.8

WORKDIR /tmp

# install nodejs
# 
# (below commands will not working)
# RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
# apt-get install nodejs
RUN curl -LO https://nodejs.org/dist/v12.18.0/node-v12.18.0-linux-x64.tar.xz
RUN tar xvf node-v12.18.0-linux-x64.tar.xz
RUN mv node-v12.18.0-linux-x64 /opt/node
ENV PATH /opt/node/bin:$PATH

# install yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH /home/rails/.yarn/bin:/home/rails/.config/yarn/global/node_modules/.bin:$PATH

WORKDIR /webapp

ENV ENTRYKIT_VERSION 0.4.0
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && apt-get update

RUN gem install bundler

ENTRYPOINT [ \
  "prehook", "rm -f tmp/pids/*", "--", \
  "prehook", "bundle install", "--", \
  "prehook", "ruby -v", "--"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
