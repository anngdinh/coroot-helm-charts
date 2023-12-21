# sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
# 

dep-node-agent:
	cd charts/node-agent && helm dependency update
	cd charts/node-agent && helm package .

dep-pyroscope:
	cd charts/pyroscope && helm dependency update
	cd charts/pyroscope && helm package .

dep-prometheus:
	cd charts/prometheus && helm dependency update
	cd charts/prometheus && helm package .

dep-clickhouse:
	cd charts/clickhouse && helm dependency update
	cd charts/clickhouse && helm package .

dep-opentelemetry-collector:
	cd charts/opentelemetry-collector && helm dependency update
	cd charts/opentelemetry-collector && helm package .

install: dep-node-agent dep-pyroscope dep-prometheus dep-clickhouse dep-opentelemetry-collector
	cd charts/coroot && helm dependency update
	cd charts/coroot && helm package .

	helm cm-push -f charts/node-agent/node-agent-0.1.51.tgz hub-cls
	helm cm-push -f charts/pyroscope/pyroscope-0.2.92.tgz hub-cls
	helm cm-push -f charts/prometheus/prometheus-25.8.0.tgz hub-cls
	helm cm-push -f charts/clickhouse/clickhouse-4.1.8.tgz hub-cls
	helm cm-push -f charts/opentelemetry-collector/opentelemetry-collector-0.52.1.tgz hub-cls
	helm cm-push -f charts/coroot/coroot-0.7.0.tgz hub-cls

	helm repo update
	helm install --namespace coroot coroot hub-cls/coroot

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

add-cls:
	helm repo remove hub-cls && helm repo add hub-cls http://localhost:8088

