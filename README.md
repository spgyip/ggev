Guigui env
=================

# Install

```
gem install ggev
ggev init
```

# Usage


```
        -------------------------------(commit -p)--------------------------
        |                                                                  |
        |   ----------------(commit)------     -------(push)--------       |
        |   |                            |     |                   |       |
        |   |                           \|/    |                  \|/     \|/
       |-----------|                    |-----------|             |------------|
       |local-files| <=====(diff)====>  |local-repos|             |remote-repos|
       |-----------|                    |-----------|             |------------|
       /|\ /|\                           |    /|\                  |       |
        |   |                            |     |                   |       |
        |   -------(update)---------------     -------(fetch)-------       |
        |                                                                  |
        ----------------------------------(pull)----------------------------
```

# TODO

- [X] Use `gem`
- [X] Command `init`
- [X] Reconstruct command dispatcher
- [ ] New workflow commit/push/update/fetch/diff
- [ ] Configure github action to publish rubygem
