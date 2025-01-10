FROM golang:1.22
RUN git clone https://github.com/kubernetes-sigs/cloud-provider-kind.git
RUN cd cloud-provider-kind && make


# build real cloud-provider-kind image
FROM docker:27.1-dind
COPY --from=0 --chown=root:root /go/cloud-provider-kind/bin/cloud-provider-kind /bin/cloud-provider-kind
ENTRYPOINT ["/bin/cloud-provider-kind"]