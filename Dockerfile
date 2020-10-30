# 公式のイメージから取得
FROM ruby:2.6.3

# Dockerfile内部で使える変数として定義
ARG RAILS_ENV
ARG RAILS_MASTER_KEY

# コンテナ内のルートとする変数を/appと定義
ENV APP_ROOT /app

# 環境変数化
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

# コンテナ内のルートとする。
WORKDIR $APP_ROOT

# ローカルのGemfile, Gemfile.lockをコンテナ内のルートへコピー
ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

# bundle install実行。
# (バージョンのエラーが出る為、一応bundler 2.0.2を指定)
RUN \
    gem install bundler:2.0.2 && \ 
    bundle install && \
    rm -rf ~/.gem

# バンドルインストールが終わってから他のファイルもコンテナ内へコピー
ADD . $APP_ROOT

# 本番環境の場合プロダクション
RUN if ["${RAILS_ENV}" = "production"]; then bundle exec rails assets:precompile; else export RAILS_ENV=development; fi

# ポート3000番を公開
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

