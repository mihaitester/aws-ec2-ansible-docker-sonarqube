# Introduction
    Example of a reverse proxy using NGINX docker from [ https://phoenixnap.com/kb/docker-nginx-reverse-proxy ]

# References
1. Starting up with NGINX
    - TODO: configure a reverse proxy with NGINX so that SSL/https connections will work properly
    - https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
    - https://docs.sonarqube.org/latest/setup/operate-server/#header-5
    - https://hub.docker.com/_/nginx
    - https://phoenixnap.com/kb/docker-nginx-reverse-proxy
    - https://phoenixnap.com/kb/nginx-reverse-proxy - on the host, without docker
    - https://jessehouwing.net/sonarqube-configure-ssl-on-windows/
    
    - https://www.docker.com/blog/how-to-use-the-official-nginx-docker-image/

    - https://hub.docker.com/r/jwilder/nginx-proxy
    - https://docs.docker.com/registry/recipes/nginx/
    - https://www.freecodecamp.org/news/docker-nginx-letsencrypt-easy-secure-reverse-proxy-40165ba3aee2/

    - https://docs.docker.com/compose/networking/
    - https://docs.docker.com/compose/compose-file/compose-file-v2/#network-configuration-reference

    - https://www.baeldung.com/ops/docker-container-filesystem
        - viewing files inside the container, will need to check files are properly configured
            [ docker container cp <container_name_or_id>:/ ./test ] - basically copy the root of the container outside from the container

    TODO: use secrets to store the certfile and keyfile instead of plainly injecting them into the container

2. how to configure [ docker-compose.yml ] to build local [ Dockerfile ]
    - https://docs.docker.com/compose/compose-file/compose-file-v3/#image

3. How to get a self signed certificate, however this will need to be created outside of deployment and spread throughout company
    - [ https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl ]

        It's important to put DNS name in the SAN and not the CN, because both the IETF and the CA/Browser Forums specify the practice. They also specify that DNS names in the CN are deprecated (but not prohibited). If you put a DNS name in the CN, then it must be included in the SAN under the CA/B policies. So you can't avoid using the Subject Alternate Name.

        If you don't do put DNS names in the SAN, then the certificate will fail to validate under a browser and other user agents which follow the CA/Browser Forum guidelines.

        Related: browsers follow the CA/Browser Forum policies; and not the IETF policies. That's one of the reasons a certificate created with OpenSSL (which generally follows the IETF) sometimes does not validate under a browser (browsers follow the CA/B). They are different standards, they have different issuing policies and different validation requirements.

        - Create a self signed certificate (notice the addition of -x509 option):
            openssl req -config example-com.conf -new -x509 -sha256 -newkey rsa:2048 -nodes -keyout example-com.key.pem -days 365 -out example-com.cert.pem

        - Create a signing request (notice the lack of -x509 option):
            openssl req -config example-com.conf -new -sha256 -newkey rsa:2048 -nodes -keyout example-com.key.pem -days 365 -out example-com.req.pem

        - Print a self-signed certificate:
            openssl x509 -in example-com.cert.pem -text -noout

        - Print a signing request:
            openssl req -in example-com.req.pem -text -noout

    - [ https://unix.stackexchange.com/questions/104171/create-ssl-certificate-non-interactively ]
    - [ https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs ]
        - really good tutorial with plenty of commands on how to use openssl
    - [ https://www.ibm.com/docs/en/api-connect/2018.x?topic=overview-generating-self-signed-certificate-using-openssl ]
    - [ https://helpcenter.gsx.com/hc/en-us/articles/115015960428-How-to-Generate-a-Self-Signed-Certificate-and-Private-Key-using-OpenSSL ]

4. Build docker container before running
    - [ https://docs.docker.com/engine/reference/commandline/build/ ]

5. Fixing expecting trusted certificate
    - [ https://ma.ttias.be/nginx-ssl-certificate-errors-pem_read_bio_x509_aux-pem_read_bio_x509-ssl_ctx_use_privatekey_file/ ]

6. Fixing cyphers issue - assuming issue is line endings in ./includes/ssl.conf
    - [ https://guillermo.at/nginx-letsencrypt-docker-error ]

7. Understanding docker networks
    - [ https://docs.docker.com/engine/tutorials/networkingcontainers/ ]
    - [ https://www.youtube.com/watch?v=c6Ord0GAOp8 = Docker Networking Tutorial | Container Network Model | Docker Tutorial For Beginners | Simplilearn ]

    - [ https://www.youtube.com/watch?v=MGBAXJnoqbA = Docker Networking ]
        - this is way better

    - [ https://docs.docker.com/compose/networking/ ]
        - docker compose is kind of bad, as it always creates new networks
            - need to connect created containers to an existing precreated docker network, instead of creating networks left and right using docker-compose

        - If you want your containers to join a pre-existing network, use the external option:
            - VERY IMPORTANT REMARK, OTHERWISE DOCKER COMPOSE KEEPS CREATING NETWORKS
    
8. Nginx reverse-proxy
    - [ https://phoenixnap.com/kb/docker-nginx-reverse-proxy ]
        - really good tutorial, just a little bit incomplete

    - [ https://www.digitalocean.com/community/questions/nginx-reverse-proxy-502-bad-gateway-only-with-https ]
        - fix the 502 problem, had to use docker0 bridge IP, instead of host IP
            
            - [ https://stackoverflow.com/questions/3893839/how-do-i-redirect-https-to-http-on-nginx ]
            - [ https://serverfault.com/questions/145383/proxy-https-requests-to-a-http-backend-with-nginx ]
            - [ https://tumblr.intranation.com/post/766288369/using-nginx-reverse-proxy ]
            - [ https://www.ruby-forum.com/t/what-exactly-does-proxy-http-version-mean/221167/4 ]

9. Understanding docker-compose
    - [ https://docs.docker.com/compose/compose-file/compose-file-v3/#environment ]
        - very useful to have different files containing the passwords used

10. Understanding docker
    - [ https://www.freecodecamp.org/news/how-to-get-a-docker-container-ip-address-explained-with-examples/ ]
        - how to query the docker configurations using INSPECT and for example getting the assigned IP class for docker bridges or networks
