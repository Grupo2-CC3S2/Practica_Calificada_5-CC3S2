package kubernetes.security

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  container.securityContext.runAsUser == 0
  msg = sprintf("runAsRoot no permitido en %s", [input.metadata.name])
}
