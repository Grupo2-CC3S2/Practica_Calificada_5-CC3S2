package policy.noroot

deny[msg] {
  input.kind == "Deployment"
  not deployment_runasnonroot(input)
  msg = sprintf("Deployment %s permite correr como root", [input.metadata.name])
}

deployment_runasnonroot(d) {
  d.spec.template.spec.securityContext.runAsNonRoot == true
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container_runasnonroot(container)
  msg = sprintf("Container %s en Deployment %s permite correr como root", [container.name, input.metadata.name])
}

container_runasnonroot(c) {
  c.securityContext.runAsNonRoot == true
}
