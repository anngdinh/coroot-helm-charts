# sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
# export KUBECONFIG=/home/annd2/Downloads/abpf2.txt
# 
build:
	rm -rf prometheus-23.1.0.tgz
	curl -X DELETE localhost:8088/api/charts/prometheus/23.1.0
	helm package .
	curl --data-binary "@prometheus-23.1.0.tgz" http://localhost:8088/api/charts

# install:
# 	# kubectl delete ns coroot
# 	helm repo remove coroot && helm repo add coroot http://localhost:8088
# 	helm repo update
# 	helm install --namespace coroot --create-namespace coroot coroot/coroot

# all: build install