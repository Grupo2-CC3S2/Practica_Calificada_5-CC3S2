package policy.networkpolicy

deny[msg] {
  not exists_networkpolicy
  msg := "No existe ninguna NetworkPolicy en los manifests"
}

exists_networkpolicy {
  doc := input[_]
  doc.kind == "NetworkPolicy"
}