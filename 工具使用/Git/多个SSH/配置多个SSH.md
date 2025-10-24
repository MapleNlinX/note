使用==-f==参数可以设置ssh文件的命名，配置设置不一样的命名就能让多个ssh文件共存
```git
ssh-keygen -t rsa -C 'xxx@xx.com' -f ~/.ssh/gitlab_rsa

ssh-keygen -t rsa -C 'xxx@xx.com' -f ~/.ssh/github_rsa
```

在==~/.ssh==目录下修改/新增config文件，设置不同域名用不同的ssh
```
# GitHub配置
Host github.com
    HostName github.com
    User nlinx@foxmail.com
    IdentityFile ~/.ssh/github_rsa

# GitLab配置  
Host gitlab.cokutau.cn
    HostName gitlab.cokutau.cn
    User liangxiaofeng@cokutau.com
    IdentityFile ~/.ssh/gitlab_rsa
```

测试代码，会有不一样的输出，既成功
```
ssh -T git@github.com

ssh -T git@gitlab.com
```