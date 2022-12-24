#!/usr/bin/env bash
if [[ -z "$@" ]]; then
  echo "Missing file input arguments"
  exit 1
fi

# while getopts o: flag
# do
#     case "${flag}" in
#         o) output=${OPTARG};;
#     esac
# done

echo "terraform plan \\"
for FILE in "$@"
do
  RESOURCE=$(sed -n 's/resource "\([^"]*\)" "\([^"]*\)".*/-target=\1.\2 \\/gp' $FILE)
  MODULE=$(sed -n 's/module "\([^"]*\)".*/-target=module.\1 \\/gp' $FILE)
  if [[ -z "$RESOURCE" ]] && [[ -z "$MODULE" ]]; then
    echo "Cannot detect terraform resource and module in $FILE"
    exit 1
  fi

  if [[ ! -z "$RESOURCE" ]]; then
    echo -e $"$RESOURCE"
  fi
  if [[ ! -z "$MODULE" ]]; then
    echo -e $"$MODULE"
  fi
done

echo "-refresh=false -destroy \\"

echo "-out magic-plan.plan";