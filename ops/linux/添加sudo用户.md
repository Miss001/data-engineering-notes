1.设置文件可写
```
chmod u+w /etc/sudoers
```
2.编辑文件
```
vi /etc/sudoers
#添加
omm ALL=(ALL) ALL
```
3.修改权限
```
chmod u-w /etc/sudoers
```
