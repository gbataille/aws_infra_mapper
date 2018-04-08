# AwsInfraMapper

# Disclaimer

This project is in its infancy. It does something already (check the CHANGELOG) and it is enough for
you to have a look, but it currently brings limited value

# Running

Simply launch
```shell
aws_infra_mapper
```
after making sure your aws credentials are setup (through common means, like env variables or config
file. _Check out [aws-vault](https://github.com/99designs/aws-vault) for a nice way to manage your
credentials on your local computer)_

This will scrap the data from your AWS account, create a JSON representing your datacenter as a
graph and finally start a small HTTP server to view your datacenter and interact with it.

## Testing

### Rspec

Nothing special, you know what to do :D

### Moto

_(Optional: without moto, some tests are simply skipped)_

Some tests are actually testing the AWS interface. To do so, it uses moto which is a local server
that mocks the AWS API.

See [here](https://github.com/spulec/moto) to install it.
