# developer
Developer Docker Image with Python and go with SSH Access

## testing

```bash
docker build -f Containerfile . -t developer:dev
docker run -it --rm -e USER_NAMES="kgc8 kgc9" developer:dev
```