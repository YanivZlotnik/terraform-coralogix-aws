variable "coralogix_region" {
  description = "Coralogix account region: EU1, EU2, AP1, AP2, AP3, US1, US2"
  type        = string
  validation {
    condition     = contains(["EU1", "EU2", "AP1", "AP2", "AP3", "US1", "US2"], var.coralogix_region)
    error_message = "The coralogix region must be one of these values: [EU1, EU2, AP1, AP2, AP3, US1, US2]."
  }
}

variable "api_key" {
  description = "Coralogix account api key"
  type        = string
  sensitive   = true
}

variable "firehose_stream" {
  description = "AWS Kinesis firehose delivery stream name"
  type        = string
}

variable "application_name" {
  description = "The name of your application in Coralogix"
  type        = string
  default     = null
}

variable "subsystem_name" {
  description = "The subsystem name of your application in Coralogix"
  type        = string
  default     = null
}

variable "cloudwatch_retention_days" {
  description = "Days of retention in Cloudwatch retention days"
  type        = number
  default     = 1
}

variable "custom_domain" {
  description = "Custom domain for Coralogix firehose integration endpoints, does not work for privatelink (e.g. cust.coralogix-123.net:8443 for https://ingress.cust.coralogix-123.net:8443/aws/firehose)"
  type        = string
  default     = null
}

variable "integration_type_metrics" {
  description = "The integration type of the firehose delivery stream: 'CloudWatch_Metrics_OpenTelemetry070' or 'CloudWatch_Metrics_OpenTelemetry070_WithAggregations'"
  type        = string
  default     = "CloudWatch_Metrics_OpenTelemetry070_WithAggregations"
}

variable "output_format" {
  description = "The output format of the cloudwatch metric stream: 'json' or 'opentelemetry0.7'"
  type        = string
  default     = "opentelemetry0.7"
}

variable "enable_cloudwatch_metricstream" {
  description = "Should be true if you want to create a new Cloud Watch metric stream and attach it to Firehose"
  type        = bool
  default     = true
}

variable "cloudwatch_metric_stream_custom_name" {
  description = "Set the name of the CloudWatch metric stream, otherwise variable '{firehose_stream}-cw' will be used"
  type        = string
  default     = null
}

variable "include_metric_stream_namespaces" {
  description = "List of specific namespaces to include in the CloudWatch metric stream, see https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
  type        = list(string)
  default     = []
}

variable "include_metric_stream_filter" {
  description = "List of inclusive metric filters for namespace and metric_names. Specify this parameter, the stream sends only the conditional metric names from the metric namespaces that you specify here. If metric names is empty or not specified, the whole metric namespace is included"
  type = list(object({
    namespace    = string
    metric_names = list(string)
    })
  )
  default = []
}

variable "include_linked_accounts_metrics" {
  description = "include_linked_accounts_metrics (Optional) If you are creating a metric stream in a monitoring account, specify true to include metrics from source accounts that are linked to this monitoring account, in the metric stream. The default is false."
  type        = bool
  default     = false
}

variable "additional_metric_statistics_enable" {
  description = "To enable the inclusion of additional statistics to the streaming metrics"
  type        = bool
  default     = false
}

variable "additional_metric_statistics" {
  description = "For each entry, specify one or more metrics (metric_name and namespace) and the list of additional statistics to stream for those metrics. Each configuration of metric name and namespace can have a list of additional_statistics included into the AWS CloudWatch Metric Stream"
  type = list(object({
    additional_statistics = list(string)
    metric_name           = string
    namespace             = string
  }))
  default = [
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "VolumeTotalReadTime",
      namespace             = "AWS/EBS"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "VolumeTotalWriteTime",
      namespace             = "AWS/EBS"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "Latency",
      namespace             = "AWS/ELB"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "Duration",
      namespace             = "AWS/ELB"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "PostRuntimeExtensionsDuration",
      namespace             = "AWS/Lambda"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "FirstByteLatency",
      namespace             = "AWS/S3"
    },
    {
      additional_statistics = ["p50", "p75", "p95", "p99"],
      metric_name           = "TotalRequestLatency",
      namespace             = "AWS/S3"
    }
  ]
}

variable "s3_backup_custom_name" {
  description = "Set the name of the S3 backup bucket, otherwise variable '{firehose_stream}-backup-metrics' will be used"
  type        = string
  default     = null
}

variable "existing_s3_backup" {
  description = "Use an existing S3 bucket to use as a backup bucket"
  type        = string
  default     = null
}

variable "govcloud_deployment" {
  description = "Enable if you deploy the integration in govcloud"
  type        = bool
  default     = false
}

variable "lambda_processor_enable" {
  description = "Enable lambda processor function, defaults to true"
  type        = bool
  default     = true
}

variable "lambda_processor_custom_name" {
  description = "Set the name of the lambda processor function, otherwise variable '{firehose_stream}-metrics-transform' will be used"
  type        = string
  default     = null
}

variable "lambda_processor_iam_custom_name" {
  description = "Set the name of the lambda processor IAM role & policy, otherwise variable '{firehose_stream}-lambda-processor-iam' will be used"
  type        = string
  default     = null
}

variable "existing_lambda_processor_iam" {
  description = "Use an existing lambda processor IAM role"
  type        = string
  default     = null
}

variable "firehose_iam_custom_name" {
  description = "Set the name of the firehose IAM role & policy, otherwise variable '{firehose_stream}-firehose-metrics-iam' will be used"
  type        = string
  default     = null
}

variable "existing_firehose_iam" {
  description = "Use an existing IAM role to use as a firehose role"
  type        = string
  default     = null
}

variable "metric_streams_iam_custom_name" {
  description = "Set the name of the cloudwatch metric streams IAM role & policy, otherwise variable '{firehose_stream}-cw-iam' will be used"
  type        = string
  default     = null
}

variable "existing_metric_streams_iam" {
  description = "Use an existing IAM role to use as a metric streams role"
  type        = string
  default     = null
}

variable "user_supplied_tags" {
  description = "Tags supplied by the user to populate to all generated resources"
  type        = map(string)
  default     = {}
}

variable "override_default_tags" {
  description = "Override and remove the default tags by setting to true"
  type        = bool
  default     = false
}

variable "custom_s3_bucket" {
  description = "Custom S3 bucket to use for the lambda processor"
  type        = string
  default     = null
}

variable "server_side_encryption" {
  description = "Server side encryption configuration"
  type = object({
    enabled  = bool
    key_type = optional(string)
    key_arn  = optional(string)
  })
  default = {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }

  validation {
    condition = contains(["AWS_OWNED_CMK", "CUSTOMER_MANAGED_CMK"], var.server_side_encryption.key_type)
    error_message = "Valid values for key_type are AWS_OWNED_CMK and CUSTOMER_MANAGED_CMK."
  }
}