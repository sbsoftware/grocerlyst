#/bin/sh

export DATABASE_URL=sqlite3://./data.db
export ORMA_CONTINUOUS_MIGRATION=1
export OTEL_SERVICE_NAME=EKL-dev
export OTEL_TRACES_EXPORTER=http
export OTEL_EXPORTER_OTLP_ENDPOINT=https://otlp.eu01.nr-data.net:4318
export OTEL_EXPORTER_OTLP_HEADERS=\"api-key=eu01xx2b05d29d985321e8dfaaa8f970FFFFNRAL\"
export LOG_LEVEL=trace

lib/crumble/src/watch.sh einkaufsliste 3002
