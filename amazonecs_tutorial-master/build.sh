docker build -t rehan-repo:v_$BUILD_NUMBER --pull=true /var/lib/jenkins/workspace/rehan-repo \
&& docker tag rehan-repo:v_$BUILD_NUMBER 037627563666.dkr.ecr.ap-south-1.amazonaws.com/rehan-repo:v_$BUILD_NUMBER \
&& docker push 037627563666.dkr.ecr.ap-south-1.amazonaws.com/rehan-repo:v_$BUILD_NUMBER



