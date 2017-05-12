FROM elixir:1.4.2-slim

RUN apt-get update && apt-get -y install git

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /code

COPY ./mix.exs /code/
COPY ./mix.lock /code/

ENV MIX_ENV prod
RUN mix deps.update amqp
RUN mix deps.get
RUN mix deps.compile

COPY . /code

RUN mix compile

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["run"]
