package policy.noroot

# Denegar Deployment sin runAsNonRoot en securityContext
# Fíjate que eliminamos el "if" antes de la llave {
deny[msg] {
  doc := input[_]
  doc.kind == "Deployment"
  not has_deployment_runasnonroot(doc)
  msg := sprintf("Deployment %s permite correr como root", [doc.metadata.name])
}

# Denegar containers sin runAsNonRoot
deny[msg] {
  doc := input[_]
  doc.kind == "Deployment"
  container := doc.spec.template.spec.containers[_]
  not has_container_runasnonroot(container)
  msg := sprintf(
    "Container %s en Deployment %s permite correr como root",
    [container.name, doc.metadata.name]
  )
}

# Funciones auxiliares (también sin "if")
has_deployment_runasnonroot(d) {
  d.spec.template.spec.securityContext.runAsNonRoot == true
}

has_container_runasnonroot(c) {
  c.securityContext.runAsNonRoot == true
}