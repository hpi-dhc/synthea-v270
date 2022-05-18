FROM openjdk:15-jdk-slim

LABEL maintainer="Jan Philipp Sachs" \
      email="jan-philipp.sachs@hpi.de" \
      institution="Hasso Plattner Institute, University of Potsdam, Germany"

RUN groupadd -r leastprivilegedgroup && \
    useradd -r -s /bin/false -g leastprivilegedgroup leastprivilegeduser

RUN apt-get update \
 && apt-get install -y --no-install-recommends wget=1.20.1-1.1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN wget --progress=bar:force:noscroll https://github.com/synthetichealth/synthea/releases/download/v2.7.0/synthea-with-dependencies.jar \
    && chown -R leastprivilegeduser:leastprivilegedgroup /app

USER leastprivilegeduser

ENV populationSize=1

ENTRYPOINT  [ "sh", "-c", "java -jar ./synthea-with-dependencies.jar -c ./synthea.properties -p $populationSize" ]