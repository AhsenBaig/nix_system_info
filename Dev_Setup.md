# Add multiple git remotes

```bash
git remote -v
git config --add remote.all.url git@github.com:<user>/<repo>.git
git config --add remote.all.url git@github.com:<org>/<repo>.git
git remote -v
```