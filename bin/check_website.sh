EMAIL="lukexor@gmail.com"
SUBJECT=""

curl -s -o /dev/null $1
ERROR=$?
if [ $ERROR -ne 0 ] ; then
  SUBJECT="Error occurred getting URL $1: "
  if [ $ERROR -eq 6 ]; then
      SUBJECT=$SUBJECT"Unable to resolve host"
  fi
  if [ $ERROR -eq 7 ]; then
      SUBJECT=$SUBJECT"Unable to connect to host"
  fi
  echo "" | mail -s "$SUBJECT" lukexor@gmail.com
fi
