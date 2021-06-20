FROM python:3.8.9-buster

ENV PYTHONUNBUFFERED=1

WORKDIR /analysis
RUN pip install -U pip poetry

COPY poetry.lock pyproject.toml ./

RUN poetry install
