# Test Scripts

## Modify and copy appsInfo.sh script

```bash
vi appsInfo.sh && docker cp appsInfo.sh <containerid>:/usr/local/tomcat/
```

## Scripts - Copy and make executable
    
```bash
docker cp scripts/ <containerid>:/usr/local/tomcat && docker exec -u root <containerid> bash -c 'chmod +x /usr/local/tomcat/scripts/*.sh'
```

## Run a specific script inside the container

> Example: Run appsInfo.sh script
>```bash
>clear && ./appsInfo.sh
>```