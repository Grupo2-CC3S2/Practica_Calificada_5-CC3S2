package policy.noroot

deny[msg] {
  input.kind == "Deployment"

  not has_deployment_runasnonroot(input)
  msg = sprintf("Deployment %s permite correr como root: runAsNonRoot debe ser true", [input.metadata.name])
}

has_deployment_runasnonroot(obj) {
  obj.spec.template.spec.securityContext.runAsNonRoot == true
}

deny[msg] {
  input.kind == "Deployment"

  container := input.spec.template.spec.containers[_]
  not has_container_runasnonroot(container)
  msg = sprintf("Container %s en Deployment %s debe usar runAsNonRoot=true", [container.name, input.metadata.name])
}

has_container_runasnonroot(c) {
  c.securityContext.runAsNonRoot == true
}
