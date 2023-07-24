# sudo docker run --rm -u 0 -it -p 8088:8080 -e DEBUG=1 -e STORAGE=local -e STORAGE_LOCAL_ROOTDIR=/charts -v $(pwd)/charts:/charts chartmuseum/chartmuseum:latest
# export KUBECONFIG=/home/annd2/Downloads/abpf2.txt
# helm dependency update
# 
build:
	rm -rf coroot-0.2.44.tgz
	curl -X DELETE localhost:8088/api/charts/coroot/0.2.44
	helm dependency update
	helm package .
	curl --data-binary "@coroot-0.2.44.tgz" http://localhost:8088/api/charts

install:
	# kubectl delete ns coroot
	helm repo remove coroot && helm repo add coroot http://localhost:8088
	helm repo update
	helm install --namespace coroot --create-namespace coroot coroot/coroot

all: build install