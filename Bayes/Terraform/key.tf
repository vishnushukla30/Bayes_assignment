resource "aws_key_pair" "kubekey" {
  key_name   = "kubekey.pub"
  public_key = "${file("/home/ec2-user/bayes/kubekey.pub")}"
}
