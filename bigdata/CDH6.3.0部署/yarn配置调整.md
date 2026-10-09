## yarn
**yarn动态资源配置**     
```
#在名为default的池中运行应用程序指定的未明确配置的池    
yarn.scheduler.fair.allow-undeclared-pools=flase    
#禁止公平调度器抢占    
yarn.scheduler.fair.preemption＝false    
#未执行池名称时，所有程序都在一个名为default的共享池中运行    
yarn.scheduler.fair.user-as-default-queue=false
```
