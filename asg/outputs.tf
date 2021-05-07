output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       = element(concat(aws_autoscaling_group.webserver.*.min_size, [""]), 0)
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       = element(concat(aws_autoscaling_group.webserver.*.max_size, [""]), 0)
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = element(concat(aws_autoscaling_group.webserver.*.desired_capacity, [""]), 0)
}
