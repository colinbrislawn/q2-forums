# 2024 ITN

## Links

- Join [Slido with code #1744 501](https://app.sli.do/event/iisXwmBsrB3MKhobXwiC1D)
- Day1 [Presendation (GSlides)](https://docs.google.com/presentation/d/14LC8ER6skD4B2pbT4qOkx3WxyoHB2fowHqw9Z7GutH0/edit#slide=id.g2f5ebe4b124_0_5)
- [workshop book](https://go.cap-lab.bio/2024.08-q2-itn-book)
- [Activate Galaxy Instance (qiime2-itn-2024)](https://usegalaxy.org/join-training/qiime2-itn-2024/) for [UseGalaxy.org](https://usegalaxy.org/)

## Stuff I ran

Installed Docker Desktop on osx-arm64

```sh
docker image \
 pull quay.io/qiime2/workshops:2024.08.27-nih-amplicon-2024.5

docker container run \
  -itd --rm -v qiime2-workshop:/home/qiime2 \
  --name qiime2-workshop -p 8889:8888 --platform "linux/amd64" \
  quay.io/qiime2/workshops:2024.08.27-nih-amplicon-2024.5

docker container stop qiime2-workshop
```

## Docker

```sh
# View
docker ps
docker image ls

# Cleanup
docker image prune
docker image prune -a
docker system prune # ⚠️ Warning ‼️
```
