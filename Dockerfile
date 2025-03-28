FROM spark:3.5.0

COPY dependencies.txt download-jars.sh .

RUN chmod +x download-jars.sh && ./download-jars.sh

RUN chown -R spark:spark $SPARK_HOME/jars

ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.11.0/jmx_prometheus_javaagent-0.11.0.jar /prometheus/
RUN chmod 644 /prometheus/jmx_prometheus_javaagent-0.11.0.jar

USER ${spark_uid}

RUN mkdir -p /etc/metrics/conf
COPY conf/metrics.properties /etc/metrics/conf
COPY conf/prometheus.yaml /etc/metrics/conf
COPY requirements.txt /
RUN pip install -r /requirements.txt


ENTRYPOINT ["/opt/entrypoint.sh"]