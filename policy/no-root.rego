package policy.noroot

deny[msg] {
  input.kind == "Deployment"

  # runAsNonRoot no existe o está en false
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg = sprintf("Deployment %s permite correr como root: runAsNonRoot debe ser true", [input.metadata.name])
}

deny[msg] {
  input.kind == "Deployment"

  container := input.spec.template.spec.containers[_]

  # No hay securityContext o runAsNonRoot del contenedor es false
  not container.securityContext.runAsNonRoot
  msg = sprintf("Container %s en Deployment %s permite correr como root (runAsNonRoot)", [container.name, input.metadata.name])
}
