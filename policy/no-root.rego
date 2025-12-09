package policy.noroot

# Recorremos todos los documentos entregados por Conftest
deny[msg] {
  doc := input[_]
  doc.kind == "Deployment"
  not has_deployment_runasnonroot(doc)
  msg = sprintf("Deployment %s permite correr como root", [doc.metadata.name])
}

deny[msg] {
  doc := input[_]
  doc.kind == "Deployment"
  container := doc.spec.template.spec.containers[_]
  not has_container_runasnonroot(container)
  msg = sprintf(
    "Container %s en Deployment %s permite correr como root",
    [container.name, doc.metadata.name]
  )
}

has_deployment_runasnonroot(d) {
  d.spec.template.spec.securityContext.runAsNonRoot == true
}

has_container_runasnonroot(c) {
  c.securityContext.runAsNonRoot == true
}
