aws cloudformation update-stack \
  --stack-name capstone-stack \
  --template-body file://capstone_eks_infrastructure.yml \
  --parameters file://capstone_eks_infrastructure_params.json \
  --region=us-west-2 \
  --capabilities CAPABILITY_NAMED_IAM
