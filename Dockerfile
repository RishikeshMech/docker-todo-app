# Stage 1
FROM python:3.12-slim AS installer
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=myapp -r requirements.txt
RUN mkdir -p /app/data

# Stage 2

FROM gcr.io/distroless/python3
WORKDIR /src
COPY --from=installer /app/myapp .
COPY --from=installer --chown=65532:65532 /app/data .
ENV PYTHONPATH=/src/lib/python3.12/site-packages
COPY app.py .
USER nonroot
ENTRYPOINT ["python"]
CMD ["app.py"]
