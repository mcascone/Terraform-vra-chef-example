# Terraform-vra-chef-example
A very basic Terraform example to spin up a server on a vRa host and run Chef on it.

I've left this repo in a working state as an example to build more advanced automation off of.
I've made it as generic as possible, parameterized everything, etc. There are still a few places where you need your own files - specifically, the `<username>.pem` file that is created by the chef server when setting up your chef account. I don't know of a way around this at this time.

The chef provisioning is tested and it works!



# How to use this repo
1. Clone it down to your local
2. Install [Terraform 11](https://releases.hashicorp.com/terraform/0.11.14/), and make sure it's on your `$PATH`
    * As of this writing, the vra7 driver was not compatible with TF 12, so stick with 11 for now.
3. Set your environment variables: see [my powershell profile gist](https://gist.github.com/mcascone/7a12e98f9707991785fe4cc5bbe59eb2)
3. Copy your chef private key into the local repo:
    
    ```bash
    cp ~/.chef/<username>.pem .
    ```

3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply -auto-approve`
6. Bask in the ease with which you can now spin up any number of vRa machines!

## Tips and Tricks
1. The `server_count` default is 1. To change this:
    1. Edit `main.tf` or `variables.tf` depending on your needs, or
    2. Run TF with a command-line variable argument:

    ```bash
    terraform [plan, apply] -var server_count=10
    ```
    
    3. This applies to any variable defined in `variables.tf`.

# Next Steps
1. ~~Get Chef working as a Terraform Provisioner~~
2. ~~Update node names and other identifying info to be compatible with multi-machine runs.~~
    1. ~~I haven't tested that it *doesn't* work, but i have a feeling it'll collide with itself without dynamically-incrementing names/id's.~~
2. Get and POC production permisisons and workflow
