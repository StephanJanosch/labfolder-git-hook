# git hook

## pre-push
a git hook creating a labfolder entry for each push.

Author: Stephan Janosch; janosch@mpi-cbg.de

required command line tools: 
* curl
* jq

Also 2 files are required:


#### $GIT_DIR/projectId.sh
this files configures the Labfolder project ID where entries go

```bash
#!/bin/sh
PROJECTID=3358
```

#### ~/.labfolder_credentials.sh


```bash 
#!/bin/sh

USER='user'
LABFOLDER_HOST='labfolder.server.de'
```

