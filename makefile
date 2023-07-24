# sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
# 

dependency:
	cd charts/prometheus && rm -rf prometheus-23.1.0.tgz
	cd charts/prometheus && curl -X DELETE localhost:8088/api/charts/prometheus/23.1.0
	cd charts/prometheus && helm dependency update
	cd charts/prometheus && helm package .
	cd charts/prometheus && curl --data-binary "@prometheus-23.1.0.tgz" http://localhost:8088/api/charts

	cd charts/clickhouse && rm -rf clickhouse-3.5.5.tgz
	cd charts/clickhouse && curl -X DELETE localhost:8088/api/charts/clickhouse/3.5.5
	cd charts/clickhouse && helm dependency update
	cd charts/clickhouse && helm package .
	cd charts/clickhouse && curl --data-binary "@clickhouse-3.5.5.tgz" http://localhost:8088/api/charts

install:
	cd charts/coroot && rm -rf coroot-0.2.44.tgz
	cd charts/coroot && curl -X DELETE localhost:8088/api/charts/coroot/0.2.44
	cd charts/coroot && helm dependency update
	cd charts/coroot && helm package .
	cd charts/coroot && curl --data-binary "@coroot-0.2.44.tgz" http://localhost:8088/api/charts
	
	cd charts/coroot && helm repo remove coroot && helm repo add coroot http://localhost:8088
	cd charts/coroot && helm repo update
	cd charts/coroot && helm install --namespace coroot --create-namespace coroot coroot/coroot

