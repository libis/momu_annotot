#docker build . --no-cache -f annototDockerfile -t libis/annotot
#REGISTRY=registry.docker.libis.be
#NAME=libis/annotot
#docker build . --rm --no-cache -t $NAME
#docker tag $NAME $REGISTRY/$NAME
#docker push $REGISTRY/$NAME

FROM ruby:2.7.3

RUN useradd --home /app --uid 10000 annotot

WORKDIR /app

ADD https://nodejs.org/dist/v14.17.0/node-v14.17.0-linux-x64.tar.xz .
RUN xz -d node-v14.17.0-linux-x64.tar.xz && tar xvf node-v14.17.0-linux-x64.tar && mv node-v14.17.0-linux-x64 node && rm node-v14.17.0-linux-x64.tar
ENV PATH=$PATH:/app/node/bin
ENV RAILS_ENV=production

RUN npm install --global yarn

RUN gem install rails -v=5.1.4
RUN rails new annotot_app
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

WORKDIR /app/annotot_app
RUN echo "gem 'annotot', '0.7.0'" >> Gemfile
RUN bundle

RUN rails g annotot:install
RUN rails db:migrate

RUN chown -R annotot:annotot /app
USER annotot

EXPOSE 3000

ENV LANG C.UTF-8
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
