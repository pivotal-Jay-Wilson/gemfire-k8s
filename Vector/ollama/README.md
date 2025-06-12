helm repo add ollama-helm https://otwld.github.io/ollama-helm/
helm repo update
helm install ollama ollama-helm/ollama --namespace ollama --create-namespace
curl http://ollama.ollama.svc.cluster.local:11434/api/embeddings -d '{"model": "all-minilm:l12-v2","prompt": "The sky is blue because of Rayleigh scattering"}'


