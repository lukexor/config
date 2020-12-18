BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
STATUS=$(git status --porcelain 2> /dev/null)
BSTATUS=$(git status --porcelain -b 2> /dev/null | rg 'ahead|diverged|behind')

shopt -u nocasematch
shopt -u nocaseglob

CHANGES=""
if [[ ! -z $STATUS ]]; then
  if [[ $STATUS =~ [[:space:]][AMD][[:space:]] ]]; then
    CHANGES="$CHANGE*"
  fi
  if [[ $STATUS =~ [AMD][[:space:]]{2} ]]; then
    CHANGES="$CHANGES+"
  fi
  if [[ $STATUS =~ [?]{2} ]]; then
    CHANGES="$CHANGES?"
  fi
fi

if [[ ! -z $BSTATUS ]]; then
  if [[ $BSTATUS =~ "ahead" ]] || [[ $BSTATUS =~ "diverged" ]]; then
    CHANGES="$CHANGES!"
  fi
  if [[ $BSTATUS =~ "behind" ]]; then
    CHANGES="$CHANGES^"
  fi
fi

if [[ ! -z $BRANCH ]]; then
  if [[ ! -z $CHANGES ]]; then
    CHANGES=" $CHANGES"
  fi
  echo "($BRANCH$CHANGES)"
else
  echo ""
fi
shopt -s nocasematch
shopt -s nocaseglob
