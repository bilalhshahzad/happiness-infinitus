#!/bin/bash
IFS=$'\n\t'

#####################################################################################
## All right amigo! It is just a basic wrapper script to set the AWS access keys for Terraform to do some magic for you.
## You know that usually we setup AWS et al bits by orchestrating Terraform runs in some sort of automation, right?
#####################################################################################


###################
##AWS_ACCESS_KEY_ID
###################
prompt="Enter the access key for your AWS account (AWS_ACCESS_KEY_ID):"
while true; do
    read -p "${prompt}" doremi
    [[ $char = $'\0' ]] && break
done

AWS_ACCESS_KEY_ID=$doremi

if [[ -z $AWS_ACCESS_KEY_ID ]]
then
    printf "\n\n**********************************************************************************\n"
    printf "I am sorry my friend but I need an AWS access key associated with an IAM user or role."
    printf "\n************************************************************************************\n\n"
    exit 1
fi

########################
##AWS_SECRET_ACCESS_KEY
########################
prompt="Enter the secret access key for your AWS account (AWS_SECRET_ACCESS_KEY):"
while IFS= read -p "$prompt" -r -s -n 1 char
do
    [[ $char == $'\0' ]] && break
    prompt='*'
    AWS_SECRET_ACCESS_KEY+="$char"
done
printf "\n"
if [[ -z $AWS_SECRET_ACCESS_KEY ]]
then
    printf "\n\n***********************************************************************************************\n"
    printf "I am sorry my friend but I need the secret key associated with the access key you provided earlier."
    printf "\n*************************************************************************************************\n\n"
    exit 1
fi

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"

cat << "EOF"
    .-"^`\                                        /`^"-.
  .'   ___\                                      /___   `.
 /    /.---.                                    .---.\    \
|    //     '-.  ___________________________ .-'     \\    |
|   ;|         \/--------------------------//         |;   |
\   ||       |\_)      May the wind        (_/|       ||   /
 \  | \  . \ ;  |    under your wings      || ; / .  / |  /
  '\_\ \\ \ \ \ |        bear you          ||/ / / // /_/'
        \\ \ \ \|   where the sun sails    |/ / / //
         `'-\_\_\    and the moon walks    /_/_/-'`
                '--------------------------'
EOF

echo "You are all set my :friend:"