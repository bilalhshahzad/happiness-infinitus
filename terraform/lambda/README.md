Follow the steps listed below to generate a key using the template file and export it in a binary format:
```sh
cd modules/users/pgp
export GPG_TTY=$(tty)
gpg --batch --gen-key pgp-key-gen-template
gpg --output public-key.gpg --export ciao@mondo.com
```
Adjust the `versions.tf` file
Run
```sh
terraform init
terraform plan
terraform apply -auto-aprove
```
Copy the `iam_userpassword` from the output and run following commands to get the decrypted password you need for AWS Console login:
```sh
pass={iam_userpassword}
echo $pass | base64 --decode | gpg --decrypt
```