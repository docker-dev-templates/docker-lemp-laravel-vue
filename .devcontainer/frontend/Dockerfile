FROM node:current-alpine
LABEL maintainer="J. Rai <jraicr@github>"

# Labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="node-alpine-envsubst"
LABEL org.label-schema.description="Image from node:current-alpine with envsubst added"

# Install envsubst on top of the current docker imagen as a new layer
RUN apk --no-cache add gettext libintl
