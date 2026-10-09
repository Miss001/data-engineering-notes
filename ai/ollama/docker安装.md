# ollama 安装
```
docker pull ollama/ollama

docker run -d --name ollama \
  -p 11434:11434 \
  -v /opt/ollama:/root/.ollama \
  -e OLLAMA_HOST=0.0.0.0:11434 \
  ollama/ollama

```
# 模型安装
```
ollama create qwen2.5-3b -f Modelfile
```
