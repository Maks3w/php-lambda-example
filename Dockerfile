# Production
FROM php:8.0-alpine as production

COPY composer.json composer.lock ./
RUN wget https://getcomposer.org/download/2.0.7/composer.phar \
  && php composer.phar install --no-dev --no-scripts \
  && rm -rf /root/.composer

COPY ./ ./

ENTRYPOINT runtime/bootstrap.php


# Development
FROM production as development

EXPOSE 8080
COPY --from=public.ecr.aws/lambda/provided /usr/local/bin/aws-lambda-rie /usr/local/bin/aws-lambda-rie
ENTRYPOINT aws-lambda-rie runtime/bootstrap.php
