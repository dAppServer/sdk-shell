### WARNING: Alpha Ware, Dont use unless you're a sadist.

You can use this direct, or via docker. If that confused you, you want docker.

- Build It: ` docker build -t lethean/wallet .`
- Run Interactive: `docker run -it --entrypoint /bin/bash lethean/wallet` (type `exit` in the console and hit enter to exit)
- Run Restful: ` docker run lethean/wallet wallet lthn balance`