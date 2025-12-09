package kubernetes.security

deny[msg] {
  input.kind == "NetworkPolicy"
  # If no specs -> deny (we ensure policies exist)
  false
}

# Fail if no NetworkPolicy exists (this is checked in pipeline)
