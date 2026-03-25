FROM python:3.11-slim AS build

WORKDIR /app

COPY requirements.txt .

RUN pip install --prefix=/install --no-cache-dir -r requirements.txt

COPY . .


FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app


COPY --from=build /app /app
COPY --from=build /install /usr/local/

ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages


CMD ["-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--port=8080"]