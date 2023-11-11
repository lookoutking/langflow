FROM python:3.10-slim

WORKDIR /app

# Install Poetry
RUN apt-get update && apt-get install gcc g++ curl build-essential postgresql-server-dev-all -y
RUN curl -sSL https://install.python-poetry.org | python3 -
# # Add Poetry to PATH
ENV PATH="${PATH}:/root/.local/bin"
# # Copy the pyproject.toml and poetry.lock files
COPY poetry.lock pyproject.toml ./
# Copy the rest of the application codes
COPY ./ ./

EXPOSE 7860

RUN python -m pip install --upgrade pip
# Install dependencies
RUN poetry config virtualenvs.create false

ENV POETRY_REQUESTS_TIMEOUT=500

RUN poetry install --no-interaction --no-ansi --without dev --extras deploy

CMD ["uvicorn", "--factory", "src.backend.langflow.main:create_app", "--host", "0.0.0.0", "--port", "7860", "--reload", "--log-level", "debug"]
