# pre-push git hook for Labfolder

A [git hook](https://git-scm.com/book/de/v1/Git-individuell-einrichten-Git-Hooks) creating a labfolder entry for each push.

The hook will ask you for your Labfolder password, in case it cannot find a valid token in `$HOME/.labfolder_token.sh`
which is being created during usage.

## set up

* Copy `scripts/pre-push` to `$PROJECT_ROOT/.git/hooks/pre-push`
* create 2 needed files below
* git push as usual and enter password if needed

**note**: depending on your IDE you might not see the password prompt asking for your labfolder password.

Also 2 files are required:

### $PROJECT_ROOT/projectId.sh
this files configures the Labfolder project ID where entries go.

The project id can be found in the url bar of your browser.
![](images/labfolder_project_id.png)

```bash
#!/bin/sh
PROJECTID=3358
```

### ~/.labfolder_credentials.sh


```bash 
#!/bin/sh

USER='user'
LABFOLDER_HOST='labfolder.server.de'
```

## how to use

Simply do git push as usual. The hook 

![](images/git_push_entries.png)