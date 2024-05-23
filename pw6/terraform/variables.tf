variable "gcp_project_id" {
  description = ""
  type        = string
  nullable    = false
}

variable "gcp_service_account_key_file_path" {
  description = ""
  type        = string
  nullable    = false
}

variable "gce_instance_name" {
  description = ""
  type        = string
  nullable    = false
}

variable "gce_instance_user" {
  description = ""
  type        = string
  nullable    = false
}

variable "gce_ssh_pub_key_file_path" {
  description = ""
  type        = string
  nullable    = false
}
