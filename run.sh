#!/bin/bash
i=1
cond=0
while [ $cond -eq 0 ]; do
numberOfService=13
for line in $(kubectl get pods -n test | grep -oe '\([0-9.]\/[0-9.]\)'); do
if [ $line = "1/1" ] || [ $line = "2/2" ]; then
numberOfService=$((--numberOfService))
fi
if [ $numberOfService -eq 0 ]; then
kubectl get pods -n test
echo 'all the servicess are running in test name space, starting the test'
cond=1
break
fi
done
if [ $cond -eq 1 ]; then
break
fi
echo 'waiting for the services to to be in running state...'
sleep 20;
done
