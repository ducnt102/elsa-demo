
1. Create EC2 from terraform

2. ssh to ec2 instance, clone code and run scripts to install package, build web
  ```git clone git@github.com:ducnt102/elsa-demo.git
  cd elsa-demo/scripts
  ./setup.sh
  ./build.sh```

4. Deploy to k8s using minikube
  ./deploy.sh

