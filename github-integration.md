
Setup to setup CI integration

- Visit your domain hosting the Drone CI [Example: https://drone.codingcoffee.me/]
- Login via GitHub
- Select the repository you want and click on 'Activate Repository'
- In the secrets section add the following
  - Secret Name: `aws_access_key_id`
    Secret Value: Your AWS access key ID
  - Secret Name: `aws_secret_access_key`
    Secret Value: Your AWS secret access key
- Thats it. Every new `master` merge would build the binary and copy to S3 here on out.

