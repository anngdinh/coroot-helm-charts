# sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
# 

dep-node-agent:
	cd charts/node-agent && rm -rf node-agent-0.1.51.tgz
	cd charts/node-agent && curl -X DELETE localhost:8088/api/charts/node-agent/0.1.51
	cd charts/node-agent && helm dependency update
	cd charts/node-agent && helm package .
	cd charts/node-agent && curl --data-binary "@node-agent-0.1.51.tgz" http://localhost:8088/api/charts

dep-pyroscope:
	cd charts/pyroscope && rm -rf pyroscope-0.2.92.tgz
	cd charts/pyroscope && curl -X DELETE localhost:8088/api/charts/pyroscope/0.2.92
	cd charts/pyroscope && helm dependency update
	cd charts/pyroscope && helm package .
	cd charts/pyroscope && curl --data-binary "@pyroscope-0.2.92.tgz" http://localhost:8088/api/charts

dep-prometheus:
	cd charts/prometheus && rm -rf prometheus-25.8.0.tgz
	cd charts/prometheus && curl -X DELETE localhost:8088/api/charts/prometheus/25.8.0
	cd charts/prometheus && helm dependency update
	cd charts/prometheus && helm package .
	cd charts/prometheus && curl --data-binary "@prometheus-25.8.0.tgz" http://localhost:8088/api/charts

dep-clickhouse:
	cd charts/clickhouse && rm -rf clickhouse-4.1.8.tgz
	cd charts/clickhouse && curl -X DELETE localhost:8088/api/charts/clickhouse/4.1.8
	cd charts/clickhouse && helm dependency update
	cd charts/clickhouse && helm package .
	cd charts/clickhouse && curl --data-binary "@clickhouse-4.1.8.tgz" http://localhost:8088/api/charts

dep-opentelemetry-collector:
	cd charts/opentelemetry-collector && rm -rf opentelemetry-collector-0.52.1.tgz
	cd charts/opentelemetry-collector && curl -X DELETE localhost:8088/api/charts/opentelemetry-collector/0.52.1
	cd charts/opentelemetry-collector && helm dependency update
	cd charts/opentelemetry-collector && helm package .
	cd charts/opentelemetry-collector && curl --data-binary "@opentelemetry-collector-0.52.1.tgz" http://localhost:8088/api/charts

install: dep-node-agent dep-pyroscope dep-prometheus dep-clickhouse dep-opentelemetry-collector
	cd charts/coroot && rm -rf coroot-0.7.0.tgz
	cd charts/coroot && curl -X DELETE localhost:8088/api/charts/coroot/0.7.0
	cd charts/coroot && helm dependency update
	cd charts/coroot && helm package .
	cd charts/coroot && curl --data-binary "@coroot-0.7.0.tgz" http://localhost:8088/api/charts
	
	cd charts/coroot && helm repo remove coroot && helm repo add coroot http://localhost:8088
	cd charts/coroot && helm repo update coroot
	cd charts/coroot && helm install --namespace coroot coroot coroot/coroot
	# cd charts/coroot && helm install --namespace coroot --set pyroscope.enabled=false --set node-agent.profiling.pyroscopeEndpoint="" coroot coroot/coroot

uninstall:
	helm uninstall -n coroot coroot

list:
	helm list -n coroot

install-online:
	helm repo remove coroot
	helm repo add coroot https://coroot.github.io/helm-charts
	helm repo update coroot
	helm install --namespace coroot coroot coroot/coroot

delete-pv:
	kubectl delete pv $(kubectl get pv | grep Release | awk '{print $1}')
